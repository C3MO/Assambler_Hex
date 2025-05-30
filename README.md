# Assembler Programs

## HEX.COM
Hexadecimal and decimal number display program. Demonstrates:
- 16-bit hex output (4 digits)
- 8-bit hex output (2 digits)
- 4-bit hex output (1 digit)
- New 8-bit and 16-bit decimal output

## GRAFIK.COM
VGA graphics program. Demonstrates:
- Line drawing algorithms
- Rectangle drawing
- Circle drawing (stub implementation)
- Mode switching (text ↔ graphics)

## Building
1. Ensure NASM is installed (included in `tools/` directory)
2. Assemble programs:
```bash
tools\nasm -f bin asm _ com\hex.asm -o asm _ com\HEX.COM
tools\nasm -f bin asm _ com\grafik.asm -o asm _ com\GRAFIK.COM
```

## Running
```bash
asm _ com\HEX.COM
asm _ com\GRAFIK.COM
```

## HEX.COM Features
- Automatic demonstration of output routines
- Shows hex and decimal conversions
- Example calculations: 
  - a + b = 23h + 85h = A8h
  - c + d = 35h + 27h = 5Ch

## GRAFIK.COM Features
- Press any key between drawing stages
- Draws:
  - Diagonal line
  - Horizontal line
  - Vertical line
  - Rectangle
  - Circle (stub implementation)
- Blue background with green shapes

## Function Reference (HEX.COM)
- `outhexword`: Output 16-bit value as 4 hex digits
- `outhexbyte`: Output 8-bit value as 2 hex digits
- `outhexdigit`: Output 4-bit value as 1 hex digit
- `outdecword`: New 16-bit decimal output
- `outdecbyte`: New 8-bit decimal output

## Function Reference (GRAFIK.COM)
- `draw_line`: Draws line between two points
- `draw_rect`: Draws rectangle
- `draw_circle`: Draws circle (stub)
- `wait_key`: Waits for keypress

## Dependencies
- DOS environment (or DOSBox)
- NASM assembler (included)
