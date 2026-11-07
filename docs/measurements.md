# Measurements

Numbers match [measure.png](measure.png). All values in mm. Fill in the value column and commit, or paste the numbers into chat.

| # | What | Parameter | Value |
|---|---|---|---|
| P | Panel part number (label on the back) | — | |
| 1 | Panel glass width | `panel_w` | |
| 2 | Panel glass height | `panel_h` | |
| 3 | Left border, glass edge to first lit pixel | `active_off[0]` | |
| 4 | Right border | `active_w` (= 1 − 3 − 4) | |
| 5 | Top border | `active_h` (= 2 − 5 − 6) | |
| 6 | Bottom border | `active_off[1]` | |
| 7 | Panel thickness at the edge, touch layer included | `panel_t` | |
| 8 | Flex cable: distance from corner ● (back view) | `edp_pos` | |
| 9 | Flex cable width, plus which edge it leaves from | `edp_cut` | |
| 10 | Tallest bump on the panel back | — | |
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
