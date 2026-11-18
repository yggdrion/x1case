# x1case

A 3D-printable all-in-one case for a **Lenovo ThinkPad X1 Extreme Gen 1** (machine type 20MF, same chassis as the P1 Gen 1; panel AUO B156ZAN03.2, active area 344 × 193 mm). The original display lid (4K touch panel, bezel and back cover) stays intact; only the laptop base is removed. A printed clamp wraps the lid, and the mainboard sits behind it. The back shell carries two 120 mm assist fans controlled by an ESP32, with a VESA 100 mount between them. The keyboard is removed and replaced by a wireless one. The machine runs on AC only, with no battery.

The split-and-glue approach follows [yggdrion/wooting-waveshare](https://github.com/yggdrion/wooting-waveshare): parametric OpenSCAD, dovetailed pieces glued together, and seams hidden in V-grooves.

> **Status: skeleton.** Every dimension marked `PLACEHOLDER` in `x1case.scad` is a guess. Nothing has been printed or test-fitted yet.

## Layout (front to back)

| Layer | Part | Notes |
|---|---|---|
| Front clamp ring | `frame_*` | 4 pieces, printed front face down. A 1.2 mm lip over the lid's front edge, a 6 mm wall (7.5 mm at the bottom, with the cable channel) and M2 heat-set inserts for the shell screws |
| Display lid | — | Original. The hinge stubs stay on and stick out 12 mm past the glass; a 14 mm bottom lip covers the open strip along the hinge edge, with an open hole for each stub (cut the stubs off later) |
| Board tray | `tray_*` | 4 pieces. Covers the lid back up to its edge; the shell squeezes it onto the lid (no screws). Flat: M2 × 5 mm brass standoffs (female-female) screw onto the board and get glued to the tray, so no hole positions need measuring. Aluminium tape with Kapton over it goes on the board side, inside the board footprint only (`tape_t`) |
| Air gap, board + stock heatsink/blowers | — | Board top side faces the lid, heatsink side faces the back |
| Back shell | `shell_*` | 4 pieces, printed back face down. Stepped: a deep box (57.7 mm) up to `hseam` over the board, cooler and fans, and a thin plate (`top_t`, 14 mm total) above it, where only the lid is behind. Two 120 mm fan grilles, VESA 100 bosses with M4 inserts, ESP32 + 2× buck cradles inside the VESA square, a window for the stock DC-in jack in the bottom wall, bottom vents (wider at the fin-stack exhausts) and top vents in the step. No board port cutouts: only DC-in is used |

The lid is a sandwich: frame lip, lid, tray, shell. The frame's pocket is exactly `lid_t_edge` deep, so the lid back sits flush with the frame back (0.3 mm below it on a 6.7 mm lid). The tray lies on the lid back, and the shell's tray recess is `tray_press` (0.3 mm) shallower than the tray, so the rim and the thin upper plate squeeze the tray onto the lid: 0.3 mm on a 7 mm lid, 0 on a 6.7 mm one. Nothing is glued to the lid. The shell screws pull it all together: M2 machine screws (socket or button head) from the back through counterbored bosses into M2 × 4 heat-set inserts in the frame wall (3.2 mm hole, melted in from the frame's back face), M2 × 10 in the deep part and M2 × 6 in the thin upper part. The tray tape stays inside the board footprint, where the rim is cut out, so it never sits in the clamp stack; it only takes 0.2 mm off the 5 mm air gap under the board. The cable bundle leaves the lid's bottom edge at the old hinge gap, runs through a channel in the bottom wall and enters the shell through a gap in the rim.

## Split

One vertical seam sits at `seams = [125.65]` (columns of about 126 / 245 mm), in the 5 mm gap between the left fan and the VESA pad; a mirrored fake groove on the right keeps it symmetric. The case is taller than the 256 mm bed, so a horizontal seam at `hseam = 156` splits each column into a bottom (`b`, 156 mm) and a top (`t`) piece: 4 pieces per part. The seam is the shell's step: bottom shell pieces are the deep box, top shell pieces are flat 5 mm plates that print without supports. The shell's step joint is a glued butt joint (`shell_htabs = []`), and each top piece also has its own screws into the frame. The bottom row holds fan, VESA pad, fan side by side, so the mount sits in the same row as the heavy parts and only the light top row hangs on the horizontal seam. The dovetails slide together along Z (front to back), and the glue line sits in a groove. The file prints a `WARNING` echo when a piece does not fit the bed, a seam cuts through the fan, VESA pad, cable channel or the DC jack window, the step sits too low for the board, or the electronics don't fit in the VESA square.

Glue each column's bottom and top piece first, then the columns together, so the dovetails keep everything aligned.

![Back](images/assembly_back.png)
![Exploded](images/inside.png)

## Cooling and power

- The stock cooler stays: one blower at each end of the board, heatpipes between, fin stacks on one long edge. The board is turned 180° (`board_flip`) so the fin edge faces down, next to the lid's cable exits: shortest cable run to the display. The fin stacks blow down, about 9 mm, straight into wider bottom vents (`vent_w_fin`).
- The board sits low (`board_bottom_gap`), close to the lid's cable exits. Two 120 mm × 25 mm fans (`fan_t = 15` for slim NF-A12x15s) sit against the side walls, low down (`fan_y`), each right over a blower intake. They pull air in through the back grilles and push fresh air into the blowers and over the board. The depth budget stacks the fans on the heatsink.
- The stock DC-in jack sits on a short cable next to a fin stack, so with the board flipped it ends up at the bottom edge. It points down through an oversized window in the bottom wall (`dc_cut`) and is hot-glued in place, so the original charger plugs in from below; the brick stays outside the case because of its heat. Tap its two wires for the 12 V buck (fan) and the 5 V buck (ESP32).
- The ESP32-C3 SuperMini runs standalone. DS18B20 sensors on the heatsink, VRM area and exhaust set a firmware fan curve: 25 kHz PWM, tach read back, 100 % if a sensor fails. It sits with both bucks in the VESA square, where the mount plate covers it, so flash it once over USB before assembly and over the air after that.

## Machine setup

- BIOS → Config → Power → **Power On with AC Attach**, because the power button goes away with the keyboard.
- Check for battery-less throttling (BD PROCHOT) under load. If needed, clear bit 0 of MSR `0x1FC` at boot.

## Still to measure

See [docs/measure.png](docs/measure.png) (numbered drawing) and [docs/measurements.md](docs/measurements.md) (fill-in list).

1. Lid outline, corner radius, thickness (thickest point and at the edge) and bezel widths (`lid_*`, `bezel`), old hinge holes and their thread (`lid_anchors`), hinge stubs, and cable exit (`cable_exit`)
2. Board outline, mounting holes, blower intakes and fin-stack exhausts, heatsink height, tallest parts (`board_*`, `blowers`, `fin_exhausts`, `heatsink_h`, `comp_h`)
3. eDP cable length, which limits how far `board_pos` can sit from the cable exit
4. Nothing for the DC-in jack: it is hot-glued in an oversized bottom-wall window (`dc_cut`)

## Test prints

Small slices of the real parts, to check fit before printing full pieces:

- `test_corner`: bottom-left frame corner (70 × 50 mm). Lay the lid corner in: check the fit gap, corner radius, lip over the bezel, and that the lid back sits flush with the frame back. Print after the lid is measured.
- `test_seam`: frame + shell halves around the left seam, bottom wall. Check dovetail slide fit, the V-groove, and an M2 × 4 heat-set insert in its hole (melt it in, then screw in an M2 × 10).
- `test_vesa`: one VESA boss with its ribs and the back plate around it. Melt in an M4 insert, bolt on the real mount and pull hard: this boss carries the whole machine.
- `test_step`: left side wall around the shell step, 4 pieces (frame bottom + top, shell deep box + thin plate). Check the frame's horizontal dovetail, the shell butt joint, and the M2 × 6 side screw through the 2 mm counterbore floor of the thin plate.
- `test_fan`: strip of the left fan's back plate with its two bottom screw holes. Hold the real fan against it to check the 105 mm hole pitch and the screws.

`test_seam`, `test_vesa`, `test_step` and `test_fan` don't depend on the measurements, so they can print now.

Tune `fit`, `tol` and `insert_d` from the results.

## Interim stand

`stand_shoe` (print 2): two small identical shoes that hold the bare lid upright and the board behind it until the case is printed (`stand` previews them with a ghost lid and board). The board sits as in the case: fin edge down so the exhaust points down, flat chip side toward the lid, heatsink side back, connectors at the top centre. Each shoe has two slots, leaning back `stand_tilt` (12°), with both bottom edges `stand_h` (12 mm) above the cardboard, kept low because the eDP cable is short. The lid's slot has a 20 mm front wall (`stand_grip`). A 45 mm wall (`stand_grip_back`) sits between the lid and the board: the lid leans on it, so the tall wall takes load off the lid's bottom edge. The board's slot has an 8 mm rear lip (`stand_board_lip`) that touches only the bottom strip of the heatsink side. Place the shoes towards the centre, where the board's bottom edge has no fins and the lid's bottom edge has no cables, and tape them onto cardboard. Each shoe is one side profile extruded 30 mm (70 × 55 × 30 mm): print it lying on the profile, no supports.

![stand](images/stand.png)

![test_seam](images/test_seam.png)

## Render

Requires OpenSCAD 2021.01+.

```bash
openscad -o stl/shell_rb.stl -D 'part="shell_rb"' x1case.scad
```

Photo renders (Blender 5.x, stand-in board, cooler, fans, electronics, tray tape, standoffs and a placeholder power brick): `bash render/render.sh` writes `images/render_front.png`, `images/render_exploded.png` and `images/render_inside.png` (shell left out).

![render](images/render_exploded.png)
![inside](images/render_inside.png)

Parts: `frame|tray|shell` + `_` + column `l|r` + row `b|t` (e.g. `shell_lb`), `test_corner`, `test_seam`, `test_vesa`, `test_step`, `test_fan`, plus `assembly` (with `explode` and `show_ghosts`).
