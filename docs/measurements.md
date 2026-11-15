# Measurements

Numbers match [measure.png](measure.png). All values in mm. One number = one value. Fill in the value column and commit, or paste the numbers into chat.

Order: lid first (1–18) unblocks the `test_corner` print. Board and cooler (19–32) next, then DC-in jack (33–36) and cables (37, 38).

## Lid (A, B, C)

| # | What | Parameter | Value |
|---|---|---|---|
| 1 | Lid width, outer edge to outer edge | `lid_w` | 361 |
| 2 | Lid height, outer edge to outer edge (hinge stubs not included) | `lid_h` | 245 |
| 3 | Corner radius, seen from the front | `lid_r` | 3 (guessed small on purpose) |
| 4 | Bezel left: lid edge to first lit pixel | `bezel[0]` | 8.8 |
| 5 | Bezel right | `bezel[1]` | 8 |
| 6 | Bezel top | `bezel[2]` | 14 |
| 7 | Bezel bottom | `bezel[3]` | 37 |
| 11 | Cable exit: start x from 0,0 | `cable_exits` | two exits, centred ~70 mm from the right edge and ~100 mm from the left edge (looking at the glass; checked with `test_corner`) |
| 12 | Cable exit: width | `cable_exits` | round cables only, no ribbon: 15 mm channel |
| 16 | Thickness at the thickest point | `lid_t` | 6.7–7 (flat) |
| 17 | Thickness 3 mm in from the edge (left / right / top / bottom) | `lid_t_edge` | 7 |

Old hinge screw holes (8–10), one row per hole:

| Hole | 8: x | 9: y | 10: diameter / thread |
|---|---|---|---|
| none: the stubs have no screw | | | |

The bottom 14 mm of the glass side is an open strip (antennas, cables, stubs): `lip_w_bottom = 14` covers it.

Hinge stubs (13–15, 18). They stick out on the glass side and stay on (no screw):

| Stub | 13: start x | 14: width | 15: height up from the bottom edge | 18: sticks out past the glass |
|---|---|---|---|---|
| left | 44 | 6 | 8 | 12 |
| right | 44 from the right edge | 6 | 8 | 12 |

## Board and cooler (D, E)

| # | What | Parameter | Value |
|---|---|---|---|
| 19 | Board width | `board_w` | 355 |
| 20 | Board height | `board_h` | 138 |
| 29 | Board thickness | `board_t` | |
| 30 | Blowers + heatpipes: height above the board | `heatsink_h` | ~10 (others guessed, with room to spare) |
| 31 | Tallest other part on the heatsink side (RAM, SSD) | `comp_h` | |
| 32 | Tallest part on the screen side | `gap` | |

Board holes (21–23), one row per hole:

| Hole | 21: x | 22: y | 23: diameter |
|---|---|---|---|
| H1 | 28 | 4 | M2 |
| H2 | 41.5 | 34 | M2 |
| H3 | 109.5 | 132 | M2 |
| H4 | 245 | 132 | M2 |
| H5 | 175 | 18 | M2 |
| H6 | 242 | 3.5 | M2 |
| H7 | 127 | 3.5 | M2 |
| H8 | 349 | 15 | M2 |
| H9 | 352 | 47 | M2 |
| H10 | 350 | 75 | M2 |
| H11 | 353 | 94 | M2 |
| H12 | 343 | 103 | M2 |

Blowers (24–26) and fin-stack exhausts (27, 28). The edge with the fin stacks is drawn at the top:

| Blower | 24: intake centre x | 25: intake centre y | 26: intake diameter | 27: fin exhaust start x | 28: fin exhaust width |
|---|---|---|---|---|---|
| left | 56 | 88 | 41 | 34 | 72 |
| right | 290 | 90 | 41 | 250 | 66 |

`blowers`, `fin_exhausts`. The two 120 mm fans sit side by side over the heatpipe (`fan_y`).

If the board isn't a plain rectangle, add a photo taken straight from above with a ruler next to it.

## DC-in jack (F)

| # | What | Parameter | Value |
|---|---|---|---|
| 33 | Jack body width (plug side) | `dc_window` | not needed: hot-glued in a window |
| 34 | Jack body height | — | not needed |
| 35 | Jack body length | — | not needed |
| 36 | Cable length, jack to board connector | — | very short: the jack can't move, it points out the back |

Add a photo of how the jack was held in the laptop (bracket, screw).

## Cables (G)

| # | What | Value |
|---|---|---|
| 37 | eDP cable length, connector to connector (laid flat) | |
| 38 | Wi-Fi antenna cable lengths, from the M.2 card | |
