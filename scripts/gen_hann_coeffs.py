#!/usr/bin/env python3
"""Generate Hann window coefficients for Verilog ROM initialization.

Output format:
- One hex value per line (Vivado $readmemh compatible).
- Q1.(coeff_width-1) fixed-point unsigned values in range [0, 2^(W-1)-1].

Example:
    python scripts/gen_hann_coeffs.py --n 512 --coeff-width 16 \
      --out src_main/hann_512_q15.mem
"""

import argparse
import math
from pathlib import Path


def hann_value(n: int, length: int) -> float:
    if length <= 1:
        return 1.0
    return 0.5 * (1.0 - math.cos((2.0 * math.pi * n) / (length - 1)))


def main() -> None:
    parser = argparse.ArgumentParser(description="Generate Hann window coefficients")
    parser.add_argument("--n", type=int, default=512, help="Window length")
    parser.add_argument("--coeff-width", type=int, default=16, help="Coefficient bit width")
    parser.add_argument(
        "--out",
        type=Path,
        default=Path("src_main/hann_512_q15.mem"),
        help="Output .mem file path",
    )
    args = parser.parse_args()

    if args.n <= 0:
        raise ValueError("Window length must be positive")
    if args.coeff_width < 2:
        raise ValueError("Coefficient width must be at least 2")

    scale = (1 << (args.coeff_width - 1)) - 1
    hex_digits = (args.coeff_width + 3) // 4

    lines = []
    for i in range(args.n):
        coeff = hann_value(i, args.n)
        q = int(round(coeff * scale))
        q = max(0, min(scale, q))
        lines.append(f"{q:0{hex_digits}X}")

    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_text("\n".join(lines) + "\n", encoding="ascii")

    print(f"Generated {args.n} coefficients -> {args.out}")


if __name__ == "__main__":
    main()
