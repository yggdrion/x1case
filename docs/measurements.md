# Measurements

Numbers match [measure.png](measure.png). All values in mm. One number = one value. Fill in the value column and commit, or paste the numbers into chat.

Order: lid first (1–18) unblocks the `test_corner` print. Board and cooler (19–32) next, then DC-in jack (33–36) and cables (37, 38).

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
| 16 | Thickness at the thickest point | `lid_t` | |
| 17 | Thickness 3 mm in from the edge (left / right / top / bottom) | `lid_t_edge` | |

Old hinge screw holes (8–10), one row per hole:

| Hole | 8: x | 9: y | 10: diameter / thread |
|---|---|---|---|
| | | | |

Hinge stubs (13–15, 18). They stick out on the glass side. Remove them if they come off with their screw, no force, and write "removed":

| Stub | 13: start x | 14: width | 15: height up from the bottom edge | 18: sticks out past the glass |
|---|---|---|---|---|
| left | | | | |
| right | | | | |

## Board and cooler (D, E)

| # | What | Parameter | Value |
|---|---|---|---|
| 19 | Board width | `board_w` | |
| 20 | Board height | `board_h` | |
| 29 | Board thickness | `board_t` | |
| 30 | Blowers + heatpipes: height above the board | `heatsink_h` | |
| 31 | Tallest other part on the heatsink side (RAM, SSD) | `comp_h` | |
| 32 | Tallest part on the screen side | `gap` | |

Board holes (21–23), one row per hole:

| Hole | 21: x | 22: y | 23: diameter |
|---|---|---|---|
| H1 | | | |

Blowers (24–26) and fin-stack exhausts (27, 28). The edge with the fin stacks is drawn at the top:

| Blower | 24: intake centre x | 25: intake centre y | 26: intake diameter | 27: fin exhaust start x | 28: fin exhaust width |
|---|---|---|---|---|---|
| left | | | | | |
| right | | | | | |

`blowers`, `fin_exhausts`. The 120 mm fan sits on the blower picked by `fan_blower`.

If the board isn't a plain rectangle, add a photo taken straight from above with a ruler next to it.

## DC-in jack (F)

| # | What | Parameter | Value |
|---|---|---|---|
| 33 | Jack body width (plug side) | `dc_jack[0]` | |
| 34 | Jack body height | `dc_jack[1]` | |
| 35 | Jack body length | `dc_jack[2]` | |
| 36 | Cable length, jack to board connector | — | |

Add a photo of how the jack was held in the laptop (bracket, screw).

## Cables (G)

| # | What | Value |
|---|---|---|
| 37 | eDP cable length, connector to connector (laid flat) | |
| 38 | Wi-Fi antenna cable lengths, from the M.2 card | |
