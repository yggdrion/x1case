# Measurements

Numbers match [measure.png](measure.png). All values in mm. One number = one value. Fill in the value column and commit, or paste the numbers into chat.

Order: lid first (1–17) unblocks the `test_corner` print. Board (18–33) next, cables (34, 35) last.

## Lid (A, B, C)

| # | What | Parameter | Value |
|---|---|---|---|
| 1 | Lid width, outer edge to outer edge | `lid_w` | |
| 2 | Lid height, outer edge to outer edge (hinge stubs not included) | `lid_h` | |
| 3 | Corner radius, seen from the front | `lid_r` | |
| 4 | Bezel left: lid edge to first lit pixel | `bezel[0]` | |
| 5 | Bezel right | `bezel[1]` | |
| 6 | Bezel top | `bezel[2]` | |
| 7 | Bezel bottom | `bezel[3]` | |
| 11 | Cable exit: start x from 0,0 | `cable_exit[0]` | |
| 12 | Cable exit: width | `cable_exit[1]` | |
| 15 | Thickness at the thickest point | `lid_t` | |
| 16 | Thickness 3 mm in from the edge (left / right / top / bottom) | `lid_t_edge` | |

Old hinge screw holes (8–10), one row per hole:

| Hole | 8: x | 9: y | 10: diameter / thread |
|---|---|---|---|
| | | | |

Hinge stubs (13, 14, 17). Remove them if they come off with their screw, no force, and write "removed":

| Stub | 13: start x | 14: width | 17: sticks out past back cover |
|---|---|---|---|
| left | | | |
| right | | | |

## Board (D, E, F)

| # | What | Parameter | Value |
|---|---|---|---|
| 18 | Board width | `board_w` | |
| 19 | Board height | `board_h` | |
| 23 | Heatsink + blowers: x from 0,0 | `heatsink_pos[0]` | |
| 24 | Heatsink + blowers: y from 0,0 | `heatsink_pos[1]` | |
| 25 | Heatsink + blowers: width | `heatsink_size[0]` | |
| 26 | Heatsink + blowers: height | `heatsink_size[1]` | |
| 27 | Board thickness | `board_t` | |
| 28 | Heatsink + blowers: height above the board | `heatsink_h` | |
| 29 | Tallest other part on the heatsink side (RAM, SSD) | `comp_h` | |
| 30 | Tallest part on the screen side | `gap` | |
| 31 | DC-in centre: distance from the board's bottom edge | `dc_in_y` | |
| 32 | DC-in centre: height above the board surface | — | |
| 33 | Plug length, metal tip to end of the strain relief | `dc_plug_len` | |
| — | DC-in board edge (left / right in D) and side (heatsink / screen) | `dc_in_side` | |

Board holes (20–22), one row per hole:

| Hole | 20: x | 21: y | 22: diameter |
|---|---|---|---|
| H1 | | | |

If the board isn't a plain rectangle, add a photo taken straight from above with a ruler next to it.

## Cables (G)

| # | What | Value |
|---|---|---|
| 34 | eDP cable length, connector to connector (laid flat) | |
| 35 | Wi-Fi antenna cable lengths, from the M.2 card | |
