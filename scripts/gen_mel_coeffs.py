#!/usr/bin/env python3
"""Generate a mel filterbank ROM for mel_filterbank.v.

Why this exists
----------------
The CNN autoencoder (submission/src/qmodel.ipynb) was trained on mel
spectrograms produced by:

    librosa.feature.melspectrogram(y, sr=16000, n_fft=1024,
                                    hop_length=512, n_mels=64, power=1)

...i.e. a 64-band mel filterbank (Slaney formula, htk=False, the librosa
default) spanning 0 Hz to Nyquist = 8000 Hz, applied to a magnitude
spectrum.

The FPGA's own FFT front end runs at a different sample rate and FFT
size (46,875 Hz / 512-pt, vs. training's 16,000 Hz / 1024-pt) for
unrelated reasons (I2S mic rate, real-time streaming constraints), so
its 256 usable linear bins cannot be re-binned into a bit-exact replica
of the training features. What we CAN do is warp those same 256 bins
through a same-shaped mel filterbank (same Slaney formula, same 64
bands, same fmax=8000 Hz so bins above the training Nyquist are
naturally excluded) so the frequency axis the CNN sees is
perceptually/mel-shaped again, matching what it was trained to expect,
rather than the flat linear "every 4th bin" decimation used previously.

Because triangular mel filters are contiguous and only overlap with
their immediate neighbour, any single linear FFT bin contributes to at
most two mel bands. This lets the hardware accumulate a whole frame
with a tiny per-bin ROM lookup: two (band_index, weight) pairs per bin,
looked up and multiply-accumulated into 64 running sums as each of the
256 per-bin magnitudes streams past (one per clock).

Output format
-------------
One 32-bit hex word per FFT bin (bins 0..255), $readmemh-compatible:

    bit [31:30] = 2'b00  (pad)
    bit [29:24] = mel_idx_b[5:0]   (second contributing band, 0-63)
    bit [23:16] = weight_b[7:0]    (unsigned Q0.8, 0..255 approx 0..1.0)
    bit [15:14] = 2'b00  (pad)
    bit [13:8]  = mel_idx_a[5:0]   (first contributing band, 0-63)
    bit [7:0]   = weight_a[7:0]    (unsigned Q0.8, 0..255 approx 0..1.0)

When a bin only touches one band, mel_idx_b == mel_idx_a and
weight_b == 0 (safe: contributes nothing, and never double-writes the
same accumulator in the same cycle since the RTL only issues a second
write when mel_idx_a != mel_idx_b).

Weights are *unnormalized* triangular filters peaking at 1.0 (not
librosa's default area-normalized 'slaney' weighting) — the downstream
log2 feature quantizer already compresses whatever dynamic range comes
out, so matching relative *shape* across bands matters far more than
matching absolute gain.
"""

import argparse
import math
from pathlib import Path


def hz_to_mel(f: float) -> float:
    """Slaney-style Hz->mel (librosa default, htk=False)."""
    f_min = 0.0
    f_sp = 200.0 / 3.0
    mel = (f - f_min) / f_sp

    min_log_hz = 1000.0
    min_log_mel = (min_log_hz - f_min) / f_sp
    logstep = math.log(6.4) / 27.0

    if f >= min_log_hz:
        mel = min_log_mel + math.log(f / min_log_hz) / logstep
    return mel


def mel_to_hz(mel: float) -> float:
    """Slaney-style mel->Hz (inverse of hz_to_mel)."""
    f_min = 0.0
    f_sp = 200.0 / 3.0
    freq = f_min + f_sp * mel

    min_log_hz = 1000.0
    min_log_mel = (min_log_hz - f_min) / f_sp
    logstep = math.log(6.4) / 27.0

    if mel >= min_log_mel:
        freq = min_log_hz * math.exp(logstep * (mel - min_log_mel))
    return freq


def build_filterbank(n_bins: int, sample_rate: float, fft_n: int,
                      n_mels: int, fmin: float, fmax: float):
    """Return per-bin list of (band_idx, weight) pairs, weight in [0,1]."""
    bin_freqs = [k * (sample_rate / fft_n) for k in range(n_bins)]

    mel_lo = hz_to_mel(fmin)
    mel_hi = hz_to_mel(fmax)
    mel_pts = [mel_lo + i * (mel_hi - mel_lo) / (n_mels + 1) for i in range(n_mels + 2)]
    hz_pts = [mel_to_hz(m) for m in mel_pts]

    contributions = [[] for _ in range(n_bins)]
    for band in range(n_mels):
        lower, center, upper = hz_pts[band], hz_pts[band + 1], hz_pts[band + 2]
        for k, f in enumerate(bin_freqs):
            if lower <= f <= center and center > lower:
                w = (f - lower) / (center - lower)
            elif center < f <= upper and upper > center:
                w = (upper - f) / (upper - center)
            else:
                continue
            if w > 0.0:
                contributions[k].append((band, w))

    return contributions, hz_pts


def main() -> None:
    parser = argparse.ArgumentParser(description="Generate mel filterbank ROM")
    parser.add_argument("--n-bins", type=int, default=256, help="Linear FFT bins fed in (0..N-1)")
    parser.add_argument("--sample-rate", type=float, default=46875.0, help="FPGA ADC/FFT sample rate")
    parser.add_argument("--fft-n", type=int, default=512, help="FPGA FFT transform size")
    parser.add_argument("--n-mels", type=int, default=64, help="Number of mel bands (CNN input width)")
    parser.add_argument("--fmin", type=float, default=0.0, help="Mel filterbank lower edge (Hz)")
    parser.add_argument("--fmax", type=float, default=8000.0,
                         help="Mel filterbank upper edge (Hz) — matches training's 16 kHz/2 Nyquist")
    parser.add_argument("--out", type=Path, default=Path("src_main/mel_coeffs.mem"))
    args = parser.parse_args()

    contributions, hz_pts = build_filterbank(
        args.n_bins, args.sample_rate, args.fft_n, args.n_mels, args.fmin, args.fmax)

    lines = []
    truncated = 0
    active_bins = 0
    max_bands_touched = 0
    for k in range(args.n_bins):
        pairs = contributions[k]
        if len(pairs) > 2:
            truncated += 1
            pairs = sorted(pairs, key=lambda p: p[1], reverse=True)[:2]
        if pairs:
            active_bins += 1
        max_bands_touched = max(max_bands_touched, len(pairs))

        if len(pairs) == 0:
            mel_a, w_a = 0, 0
            mel_b, w_b = 0, 0
        elif len(pairs) == 1:
            mel_a, wf_a = pairs[0]
            w_a = max(0, min(255, round(wf_a * 255)))
            mel_b, w_b = mel_a, 0
        else:
            (mel_a, wf_a), (mel_b, wf_b) = pairs
            w_a = max(0, min(255, round(wf_a * 255)))
            w_b = max(0, min(255, round(wf_b * 255)))

        word = ((mel_b & 0x3F) << 24) | ((w_b & 0xFF) << 16) | \
               ((mel_a & 0x3F) << 8) | (w_a & 0xFF)
        lines.append(f"{word:08X}")

    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_text("\n".join(lines) + "\n", encoding="ascii")

    bin_hz = args.sample_rate / args.fft_n
    last_active_bin = max((k for k in range(args.n_bins) if contributions[k]), default=0)
    print(f"Generated {args.n_bins}-bin mel filterbank -> {args.out}")
    print(f"  bin spacing        : {bin_hz:.3f} Hz/bin")
    print(f"  mel range           : {args.fmin:.1f} - {args.fmax:.1f} Hz, {args.n_mels} bands")
    print(f"  active bins         : {active_bins}/{args.n_bins} (rest carry zero weight)")
    print(f"  highest active bin  : {last_active_bin} (~{last_active_bin * bin_hz:.1f} Hz)")
    print(f"  max bands/bin       : {max_bands_touched}")
    if truncated:
        print(f"  WARNING: {truncated} bins touched >2 bands; kept the 2 largest weights")
    print("  band center frequencies (Hz):")
    for m in range(args.n_mels):
        print(f"    band {m:2d}: {hz_pts[m+1]:8.1f} Hz", end="")
        print("" if (m + 1) % 4 else "\n", end="")
    print()


if __name__ == "__main__":
    main()
