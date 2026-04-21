const QRCode = require('qrcode');
const fs = require('fs');

const qr = QRCode.create('https://audio-failure-analyzer.vercel.app', {errorCorrectionLevel: 'M'});
const modules = qr.modules;
const size = modules.size;

const SCALE = 6;
const BORDER = 2;
const imgSize = (size + BORDER * 2) * SCALE;

console.log('QR size:', size, '  Image px:', imgSize, 'x', imgSize);

const lines = [];
lines.push('#include "lvgl.h"');
lines.push('');
lines.push('/* QR code for https://audio-failure-analyzer.vercel.app */');
lines.push('/* ' + imgSize + 'x' + imgSize + ' px, RGB565 (big-endian byte order) */');
lines.push('#define QR_IMG_SIZE ' + imgSize);
lines.push('');
lines.push('static const uint16_t qr_pixels[' + (imgSize * imgSize) + '] = {');

const rowStrings = [];
for (let py = 0; py < imgSize; py++) {
  const my = Math.floor(py / SCALE) - BORDER;
  const rowPx = [];
  for (let px = 0; px < imgSize; px++) {
    const mx = Math.floor(px / SCALE) - BORDER;
    let dark = false;
    if (my >= 0 && my < size && mx >= 0 && mx < size) {
      dark = modules.get(my, mx);
    }
    rowPx.push(dark ? '0x0000' : '0xFFFF');
  }
  for (let c = 0; c < rowPx.length; c += 16) {
    rowStrings.push('    ' + rowPx.slice(c, c + 16).join(', '));
  }
}
lines.push(rowStrings.join(',\n'));
lines.push('};');
lines.push('');
lines.push('const lv_img_dsc_t ui_img_qr_code = {');
lines.push('    .header = {');
lines.push('        .cf = LV_COLOR_FORMAT_RGB565,');
lines.push('        .w  = ' + imgSize + ',');
lines.push('        .h  = ' + imgSize + ',');
lines.push('    },');
lines.push('    .data_size = sizeof(qr_pixels),');
lines.push('    .data      = (const uint8_t *)qr_pixels,');
lines.push('};');

const outPath = 'qr_gen.c';
fs.writeFileSync(outPath, lines.join('\n'));
console.log('Written', outPath, '  pixels:', imgSize * imgSize);
