# Measurements

Numbers match [measure.png](measure.png). All values in mm. Fill in the value column and commit, or paste the numbers into chat.

| # | What | Parameter | Value |
|---|---|---|---|
| 1 | Lid outline width | `lid_w` | |
| 2 | Lid outline height (hinges removed) | `lid_h` | |
| R | Lid corner radius, seen from the front | `lid_r` | |
| 3 | Left: lid edge to first lit pixel | `bezel[0]` | |
| 4 | Right: lid edge to first lit pixel | `bezel[1]` | |
| 5 | Top: lid edge to first lit pixel | `bezel[2]` | |
| 6 | Bottom: lid edge to first lit pixel | `bezel[3]` | |
| 7 | Lid thickness at its thickest point | `lid_t` | |
| 8 / 9 | Every old hinge screw hole: x / y from the lid corner, plus diameter | `lid_anchors` | |
| 10 | Cable bundle exit at the bottom edge: start x + width | `cable_exit` | |
| 11 | Board width | `board_w` | |
| 12 | Board height | `board_h` | |
| 13 / 14 | Every screw hole H1, H2…: x / y from 0,0, plus hole diameter | `board_holes` | |
| 15 / 16 | Heatsink + blowers: x / y from 0,0 | `heatsink_pos` | |
| 17 / 18 | Heatsink + blowers: width / height | `heatsink_size` | |
| 19 | Heatsink + blowers: height above board | `heatsink_h` | |
| 20 | Tallest other part on the heatsink side (RAM, SSD) | `comp_h` | |
| 21 | Tallest part on the screen side | `gap` | |
| 22 | Board thickness | `board_t` | |
| 23 | DC-in centre: distance from the board's bottom edge | `dc_in_y` | |
| 26 | DC-in centre: height above the board, and on which side | — | |
| 27 | Plug length incl. strain relief, plus which edge (L/R) | `dc_plug_len`, `dc_in_side` | |
| 28 | eDP cable length, connector to connector | — | |
| 29 | Wi-Fi antenna cable lengths, from the M.2 card | — | |

If the board isn't a plain rectangle, a photo taken straight from above with a ruler next to it is enough for the outline.
