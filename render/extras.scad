// Stand-in parts for the photo render: lid, screen, board, blowers, fin stacks, heatpipe, chips, fans. Simplified shapes at the modelled positions.
include <../x1case.scad>
part = "none_x";
which = "lid";
if (which == "lid") translate([0, 0, lip_t]) linear_extrude(lid_t) lid2d();
if (which == "screen") translate([lx0 + bezel[0], ly0 + bezel[3], lip_t - 0.05]) cube([lid_w - bezel[0] - bezel[1], lid_h - bezel[2] - bezel[3], 0.1]);
if (which == "board") translate([board_pos[0], board_pos[1], z_board]) cube([board_w, board_h, board_t]);
if (which == "blowers") for (b = blowers_g) translate([b[0], b[1], z_board_back]) difference() { cylinder(d = 62, h = heatsink_h, $fn = 96); translate([0, 0, 1]) cylinder(d = b[2], h = heatsink_h, $fn = 96); }
if (which == "fins") for (f = fins_g) translate([f[0], board_pos[1], z_board_back]) cube([f[1], 12, heatsink_h]);
if (which == "pipe") translate([board_pos[0] + 75, board_pos[1] + 42, z_board_back]) cube([200, 14, 5]);
if (which == "chips") for (p = [[120, 20, 60, 30, 3], [200, 25, 40, 40, 2], [150, 100, 30, 25, 2], [20, 20, 28, 40, 4]]) translate([board_pos[0] + board_w - p[0] - p[2], board_pos[1] + board_h - p[1] - p[3], z_board_back]) cube([p[2], p[3], p[4]]);
if (which == "fans") for (c = fan_cs) translate([c[0], c[1], z_in - fan_t]) {
  difference() { translate([-60, -60, 0]) cube([120, 120, fan_t]); translate([0, 0, -1]) cylinder(d = 116, h = fan_t + 2, $fn = 96); }
  cylinder(d = 40, h = fan_t, $fn = 64);
}
if (which == "blades") for (c = fan_cs) translate([c[0], c[1], z_in - fan_t + 5]) for (a = [0 : 51.4 : 359]) rotate(a) translate([20, -2, 0]) rotate([20, 0, 0]) cube([36, 18, 1.5]);
