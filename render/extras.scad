// Stand-in parts for the photo render: lid, screen, board, blowers, fin stacks, heatpipe, chips, fans, ESP32 + bucks, DC jack, tray tape, standoffs, screws, inserts, cables. Simplified shapes at the modelled positions.
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
// electronics bay in the VESA square (parts face the board) and the stock DC jack + slim-tip plug in the bottom-wall window
if (which == "esp") translate([esp_pos[0], esp_pos[1], z_in - 1.6]) cube([esp_size[0], esp_size[1], 1.6]);
if (which == "bucks") for (b = buck_pos) translate([b[0], b[1], z_in - 1.6]) cube([buck_size[0], buck_size[1], 1.6]);
if (which == "usbc") translate([esp_pos[0] + esp_size[0] - 7.4, vesa_c[1] - 4.5, z_in - 4.8]) cube([7.4, 9, 3.2]);
if (which == "parts") {
  translate([esp_pos[0] + 6, esp_pos[1] + 5, z_in - 2.4]) cube([5, 5, 0.8]);
  for (b = buck_pos) translate([b[0] + 12, b[1] + 5, z_in - 5.6]) cube([6, 6, 4]);
  translate([dc_x - 6, 3, zb + rim_t + 3]) cube([12, 12, 10]);
  translate([dc_x - 6, -14, zb + rim_t + 3.5]) cube([12, 16, 9]);
}
// tray tape inside the board footprint: aluminium, Kapton over it (inset so the foil edge shows)
if (which == "tape") translate([board_pos[0], board_pos[1], z_tray + tray_t]) cube([board_w, board_h, 0.1]);
if (which == "kapton") translate([board_pos[0] + 3, board_pos[1] + 3, z_tray + tray_t + 0.1]) cube([board_w - 6, board_h - 6, tape_t - 0.1]);
// M2 x 5 brass standoffs, glued on the tape (positions are illustrative: they follow the board's own holes)
if (which == "standoffs") for (x = [12, board_w / 2, board_w - 12], y = [12, board_h - 12])
  translate([board_pos[0] + x, board_pos[1] + y, z_tray + tray_t + tape_t]) cylinder(d = 4, h = gap - tape_t, $fn = 6);
// shell screw heads on their counterbore floors, VESA M4 heat-set inserts
if (which == "screws") for (p = screw_pts) translate([p[0], p[1], zb + (p[1] > hseam ? top_screw_floor : screw_floor)]) cylinder(d = 3.8, h = 1.6, $fn = 24);
if (which == "inserts") for (dx = [-1, 1], dy = [-1, 1]) translate([vesa_c[0] + dx * vesa / 2, vesa_c[1] + dy * vesa / 2, D - vesa_insert_depth])
  difference() { cylinder(d = vesa_insert_d, h = vesa_insert_depth - 0.2, $fn = 32); translate([0, 0, -1]) cylinder(d = 3.4, h = vesa_insert_depth + 2, $fn = 24); }
// display cable bundles: out of the lid's bottom edge, along the channel, up onto the board
if (which == "cables") for (c = cable_x) translate([(c[0] + c[1]) / 2, 0, 0]) {
  translate([0, ly0 - fit - cable_d / 2, lip_t]) cylinder(d = 3.5, h = zb + 1 - lip_t, $fn = 16);
  translate([0, ly0 - fit - cable_d / 2, zb + 1]) rotate([-90, 0, 0]) cylinder(d = 3.5, h = board_pos[1] + 20 - ly0 + cable_d, $fn = 16);
  translate([-5, board_pos[1] + 18, z_board_back]) cube([10, 6, 3]);
}
if (which == "blades") for (c = fan_cs) translate([c[0], c[1], z_in - fan_t + 5]) for (a = [0 : 51.4 : 359]) rotate(a) translate([20, -2, 0]) rotate([20, 0, 0]) cube([36, 18, 1.5]);
