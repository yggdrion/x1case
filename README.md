# x1case

A 3D-printable all-in-one case for a **Lenovo ThinkPad X1 Extreme Gen 1** (same chassis as the P1 Gen 1). The 4K touch panel sits at the front, and the mainboard sits behind it. The back shell carries a 120 mm assist fan controlled by an ESP32 and a VESA 100 mount. The keyboard is removed and replaced by a wireless one. The machine runs on AC only, with no battery.

The split-and-glue approach follows [yggdrion/wooting-waveshare](https://github.com/yggdrion/wooting-waveshare): parametric OpenSCAD, dovetailed pieces glued together, and seams hidden in V-grooves.

> **Status: skeleton.** Every dimension marked `PLACEHOLDER` in `x1case.scad` is a guess. Nothing has been printed or test-fitted yet.

## Layout (front to back)

| Layer | Part | Notes |
|---|---|---|
| Bezel lip + panel pocket | `frame_*` | 3 pieces, printed front face down. M3 heat-set inserts in the 7 mm border |
| Backer plate | `backer_*` | 3 pieces. Holds the panel flat and carries the board standoffs (M2 inserts) |
| Air gap, board + stock heatsink/blowers | — | Board top side faces the panel, heatsink side faces the back |
| Back shell | `shell_*` | 3 pieces, printed back face down. 120 mm fan grille, VESA 100 bosses with M4 inserts, ESP32 + 2× buck cradles, side port cutouts, top/bottom vents |

The shell's front rim clamps the backer, and the backer clamps the panel against the lip. Shell screws (M3 × 12) go in from the back through counterbored bosses into the frame inserts.

## Split

Seams sit at `seams = [133, 263]`, giving pieces of about 133 / 130 / 102 × 231 mm on a 256 mm bed. The left piece holds the fan, the middle piece holds the VESA pad, and the right piece holds the electronics bay. Mirrored fake grooves keep the pattern symmetric. The dovetails slide together along Z (front to back), and the glue line sits in a groove. The file prints a `WARNING` echo when a piece does not fit the bed or a seam cuts through the fan or VESA pad.

`frame_m` exports as two separate strips (top and bottom bezel), because the window spans the full middle piece. Glue both strips to the end pieces in one go, so the dovetails keep them aligned.

![Back](images/assembly_back.png)
![Exploded](images/inside.png)

## Cooling and power

- The stock heatpipe and blowers stay. The 120 mm fan (NF-A12x15 by default, `fan_t = 25` for a standard fan) pulls air from the bottom vents across the board and out the back. The top vents act as a chimney.
- The charger plugs into a DC jack on the right wall. It feeds the board's DC-in, a 12 V buck for the fan and a 5 V buck for the ESP32.
- The ESP32-C3 SuperMini runs standalone. DS18B20 sensors on the heatsink, VRM area and exhaust set a firmware fan curve: 25 kHz PWM, tach read back, 100 % if a sensor fails. Its USB-C port is reachable through the right wall.

## Machine setup

- BIOS → Config → Power → **Power On with AC Attach**, because the power button goes away with the keyboard.
- Check for battery-less throttling (BD PROCHOT) under load. If needed, clear bit 0 of MSR `0x1FC` at boot.

## Still to measure

1. Panel outline, thickness, active area and offset, and eDP/touch connector position (`panel_*`, `active_*`, `edp_*`)
2. Board outline, mounting holes, heatsink footprint and height, tallest parts (`board_*`, `heatsink_*`, `comp_h`)
3. eDP cable length, which limits how far `board_pos` can sit from the panel connector
4. Port positions and sizes along both board edges (`ports`)

## Render

Requires OpenSCAD 2021.01+.

```bash
openscad -o stl/shell_m.stl -D 'part="shell_m"' x1case.scad
```

Parts: `frame_l|m|r`, `backer_l|m|r`, `shell_l|m|r`, plus `assembly` (with `explode` and `show_ghosts`).
