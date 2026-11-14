// x1case.scad: all-in-one case for a Lenovo ThinkPad X1 Extreme Gen 1.
// The original display lid stays intact (panel, bezel, back cover); only the laptop base goes.
// A printed clamp wraps the lid's edges. A tray on the lid's back carries the mainboard, and the
// back shell carries a 120 mm assist fan (ESP32-controlled) and a VESA 100 mount.
//
// Coordinates: X = width (left to right, seen from the front), Y = height (bottom to top),
// Z = depth (z = 0 is the front face, +Z goes toward the back).
//
// Every value marked PLACEHOLDER is a guess. Measure the real part and replace it.
//
// Set `part`, render (F6) and export STL. Printable parts come out oriented for printing.

part = "assembly"; // [assembly, frame_l, frame_m, frame_r, tray_l, tray_m, tray_r, shell_l, shell_m, shell_r, test_corner, test_seam]

/* [Print] */
bed = 256;          // Bambu Lab P2S bed (mm)
bed_margin = 3;     // keep-out at the bed edge

/* [Display lid: PLACEHOLDERS, measure with the hinges removed] */
lid_w = 361.8;      // PLACEHOLDER outline width
lid_h = 236;        // PLACEHOLDER outline height
lid_t = 6;          // PLACEHOLDER thickness, glass to back cover, at the thickest point
lid_t_edge = 6;     // PLACEHOLDER thickness 3 mm in from the outline; the clamp grips here
lid_r = 6;          // PLACEHOLDER corner radius (seen from the front)
// Panel (from EDID on the 20MF000TGE): AUO B156ZAN03.2, 3840x2160, active area 344 x 193 mm.
bezel = [8.8, 8.8, 10, 22]; // PLACEHOLDER lid edge to first lit pixel: [left, right, top, bottom]; L/R = (lid_w - 344.2) / 2
lip_w = 3;          // how far the clamp lip reaches over the lid's front edge
fit = 0.3;          // lid clearance per side
// Old hinge screw holes in the lid, used to anchor the board tray.
// [x, y] from the lid's bottom-left corner, seen from the FRONT.
lid_anchors = [[20, 8], [35, 8], [326.8, 8], [341.8, 8]]; // PLACEHOLDER
anchor_clear_d = 2.4;     // M2 clearance in the tray
// Cable bundle (eDP, touch, webcam, Wi-Fi) leaving the lid's bottom edge at the old hinge gap
cable_exit = [300, 40];   // PLACEHOLDER [start x from the lid's left edge, width]
cable_d = 4.5;            // channel depth below the lid edge, inside the bottom clamp wall

/* [Case] */
clamp_wall = 4.5;         // clamp wall left, right and top (thin so the height fits the bed)
clamp_wall_bottom = 7.5;  // bottom clamp wall, holds the cable channel
lip_t = 2;          // front lip thickness
tray_t = 2;         // board tray on the lid back
gap = 5;            // air gap between tray and board (= board standoff height)
shell_wall = 3;     // back shell side walls
back_t = 2.5;       // back shell rear plate
rim_t = 3;          // shell front rim that clamps the lid's back edge
rim_over = 2;       // how far the rim reaches over the lid's back edge
tray_inset = 0.5;   // tray clearance inside the rim
tol = 0.2;          // dovetail glue gap (total)

/* [Split: seams must avoid the fan, VESA bosses and cable channel] */
seams = [158, 280];      // real seams (X positions), glued dovetails
fake_grooves = true;      // mirrored decorative grooves
groove_w = 1.2;           // V-groove width at the surface

/* [Mainboard: PLACEHOLDERS] */
board_w = 280;            // PLACEHOLDER board outline width
board_h = 100;            // PLACEHOLDER board outline height
board_t = 1.2;
board_top_gap = 15;       // board top edge to lid top edge
// PLACEHOLDER mounting holes, relative to the board's bottom-left corner
board_holes = [[5, 5], [275, 5], [5, 95], [275, 95], [140, 95]];
// Stock cooler: one blower at each end of the board, heatpipes between, fin stacks on the board's top edge.
// Blower intake centres [x, y] + intake diameter, relative to the board's bottom-left corner.
blowers = [[45, 50, 60], [235, 50, 60]]; // PLACEHOLDER
// Fin-stack exhausts on the board's top edge: [start x, width]. They blow up into the top vents.
fin_exhausts = [[20, 25], [255, 25]];    // PLACEHOLDER
heatsink_h = 14;          // PLACEHOLDER tallest part on the back side (heatsink + blowers)
comp_h = 5;               // PLACEHOLDER tallest other part on the back side (RAM, SSD)
m2_insert_d = 3.2;        // M2 heat-set insert hole
m2_insert_depth = 4;
// Stock DC-in jack: sits on a cable that plugs into the board, so it mounts in the right wall.
dc_jack = [10, 8, 20];    // PLACEHOLDER jack body [width (along Y), height (along Z), length (into the case)]
dc_jack_y = 30;
// Optional side-wall cutouts (none by default):
// [side "L"/"R", y centre rel. board, z offset from the board's back face, w (along Y), h (along Z), name]
ports = [];
port_clear = 1;           // extra opening around each port

/* [Fan] */
fan_size = 120;
fan_t = 25;               // standard 120 mm = 25, slim (NF-A12x15) = 15
fan_clear = 3;            // gap between the heatsink and the fan
fan_hole_pitch = 105;
fan_hole_d = 4.4;
fan_blower = 0;           // index in `blowers`: the fan sits over this blower and pushes air into it

/* [VESA 100] */
vesa = 100;
vesa_insert_d = 5.7;      // M4 heat-set insert hole
vesa_insert_depth = 8.5;
vesa_boss_d = 14;
vesa_boss_h = 7;          // inside the shell, from the back plate
rib_t = 3;
rib_h = 6;

/* [Shell screws: M2 x 12 self-tapping (plastite) into the clamp wall] */
screw_inset = 15;         // from each piece's edges
side_screw_y_rel = [0.2]; // side-wall screws as a fraction of H
boss_d = 7;
screw_floor = 6;          // material under the counterbore
screw_clear = 2.4;
screw_head = 4.4;
screw_pilot_d = 1.8;      // pilot hole in the frame wall
screw_pilot_depth = 6.5;

/* [Electronics bay, right piece] */
esp_size = [23.5, 18.5];  // ESP32-C3 SuperMini, USB-C toward the right wall
esp_y = 40;
buck_size = [22, 17];     // MP1584-style buck, x2 (12 V fan, 5 V ESP32)
buck_y = [70, 95];
cradle_wall = 1.6;
cradle_h = 4;

/* [Vents] */
vent_w = 3;
vent_pitch = 7;
vent_end = 20;            // keep vents this far from the side walls

/* [Assembly view] */
explode = 0;
show_ghosts = true;

$fn = 48;

// ---------------------------------------------------------------- derived
W = lid_w + 2 * (fit + clamp_wall);
H = lid_h + 2 * fit + clamp_wall + clamp_wall_bottom;
lx0 = clamp_wall + fit;             // lid origin (bottom-left, front view)
ly0 = clamp_wall_bottom + fit;
zb = lip_t + lid_t_edge;            // lid back edge = frame back face = shell front face
z_tray = lip_t + lid_t;             // tray rests on the lid back's thickest point
z_board = z_tray + tray_t + gap;    // board front face
z_board_back = z_board + board_t;
inner_d = tray_t + gap + board_t + max(heatsink_h + fan_clear + fan_t, comp_h); // fan sits on top of a blower
D = z_tray + inner_d + back_t;      // total depth
z_in = D - back_t;                  // inside face of the back plate
dc_jack_z = (zb + rim_t + z_in) / 2;
dc_sleeve = shell_wall + dc_jack[2] * 0.6; // sleeve holds the front 60 % of the jack body

board_pos = [(W - board_w) / 2, ly0 + lid_h - board_top_gap - board_h];
cable_x = [lx0 + cable_exit[0], lx0 + cable_exit[0] + cable_exit[1]]; // global X range

bounds = concat([0], seams, [W]);
fan_c = [board_pos[0] + blowers[fan_blower][0], board_pos[1] + blowers[fan_blower][1]];
vesa_c = [(seams[0] + seams[len(seams) - 1]) / 2, H / 2];
groove_x = fake_grooves ? concat(seams, [for (s = seams) W - s]) : seams;

screw_x = [for (i = [0 : len(bounds) - 2]) each [bounds[i] + screw_inset, bounds[i + 1] - screw_inset]];
screw_pts = concat(
  [for (x = screw_x) if (x < cable_x[0] - boss_d || x > cable_x[1] + boss_d) [x, clamp_wall_bottom / 2]],
  [for (x = screw_x) [x, H - clamp_wall / 2]],
  [for (f = side_screw_y_rel) [clamp_wall / 2, H * f]],
  [for (f = side_screw_y_rel) [W - clamp_wall / 2, H * f]]);

// Dovetail tabs per part: [y, neck, head, length]
frame_tabs = [[clamp_wall_bottom / 2, 2.5, 4, 3], [H - clamp_wall / 2, 2, 3.5, 3]];
shell_tabs = [[clamp_wall_bottom / 2, 2.5, 4, 3], [H - clamp_wall / 2, 2, 3.5, 3],
              [H * 0.25, 6, 10, 5], [H * 0.5, 6, 10, 5], [H * 0.75, 6, 10, 5]];
tray_tabs = [[ly0 + lid_h * 0.2, 6, 10, 5], [ly0 + lid_h * 0.5, 6, 10, 5],
             [ly0 + lid_h * 0.8, 6, 10, 5]];

// ---------------------------------------------------------------- checks
function rects_overlap(a, b) = a[0] < b[0] + b[2] && b[0] < a[0] + a[2] && a[1] < b[1] + b[3] && b[1] < a[1] + a[3];
fan_rect = [fan_c[0] - fan_size / 2, fan_c[1] - fan_size / 2, fan_size, fan_size];
vesa_rect = [vesa_c[0] - vesa / 2 - vesa_boss_d / 2, vesa_c[1] - vesa / 2 - vesa_boss_d / 2, vesa + vesa_boss_d, vesa + vesa_boss_d];

echo(str("Case outer W x H x D = ", W, " x ", H, " x ", D, " mm"));
for (i = [0 : len(bounds) - 2]) {
  w = bounds[i + 1] - bounds[i];
  if (w > bed - 2 * bed_margin || H > bed - 2 * bed_margin)
    echo(str("WARNING: piece ", i, " (", w, " x ", H, ") does not fit the bed"));
}
if (fan_rect[0] < shell_wall || fan_rect[1] < shell_wall || fan_rect[0] + fan_size > W - shell_wall || fan_rect[1] + fan_size > H - shell_wall)
  echo("WARNING: fan over the blower does not fit inside the shell walls");
if (rects_overlap(fan_rect, vesa_rect)) echo("WARNING: fan overlaps the VESA bosses");
for (s = seams) {
  if (s > fan_rect[0] - 3 && s < fan_rect[0] + fan_rect[2] + 3) echo(str("WARNING: seam ", s, " cuts the fan"));
  if (s > vesa_rect[0] - 3 && s < vesa_rect[0] + vesa_rect[2] + 3) echo(str("WARNING: seam ", s, " cuts the VESA pad"));
}
for (s = seams) if (s > cable_x[0] - 5 && s < cable_x[1] + 5) echo(str("WARNING: seam ", s, " cuts the cable channel"));
for (s = seams, f = fin_exhausts) if (s > board_pos[0] + f[0] - 3 && s < board_pos[0] + f[0] + f[1] + 3) echo(str("WARNING: seam ", s, " blocks a fin-stack exhaust"));
if (min(bezel) <= lip_w) echo("WARNING: clamp lip covers lit pixels (lip_w >= a bezel value)");

// ---------------------------------------------------------------- helpers
module rrect(w, h, r) {
  r2 = min(r, w / 2, h / 2);
  offset(r = r2) square([w - 2 * r2, h - 2 * r2], center = true);
}

// V-grooves on the front, back, top and bottom faces
module grooves() {
  s = groove_w / sqrt(2);
  for (x = groove_x) {
    translate([x, H / 2, 0]) rotate([0, 45, 0]) cube([s, H + 2, s], center = true);
    // back face: stop short of the fan grille
    if (x > fan_c[0] - fan_size / 2 && x < fan_c[0] + fan_size / 2) {
      for (seg = [[-1, fan_c[1] - fan_size / 2], [fan_c[1] + fan_size / 2, H + 1]])
        translate([x, (seg[0] + seg[1]) / 2, D]) rotate([0, 45, 0]) cube([s, seg[1] - seg[0], s], center = true);
    } else translate([x, H / 2, D]) rotate([0, 45, 0]) cube([s, H + 2, s], center = true);
    for (y = [0, H]) translate([x, y, D / 2]) rotate([0, 0, 45]) cube([s, s, D + 2], center = true);
  }
}

// 2D region left of seam i, including that seam's dovetail tabs
module seam_region(i, tabs, grow) {
  offset(delta = grow) union() {
    translate([-50, -50]) square([seams[i] + 50, H + 100]);
    for (t = tabs) translate([seams[i], t[0]])
      polygon([[-0.01, -t[1] / 2], [t[3], -t[2] / 2], [t[3], t[2] / 2], [-0.01, t[1] / 2]]);
  }
}

module piece_mask(i, tabs) {
  n = len(seams);
  translate([0, 0, -50]) linear_extrude(D + 100) difference() {
    if (i < n) seam_region(i, tabs, -tol / 2);
    else translate([-50, -50]) square([W + 100, H + 100]);
    if (i > 0) seam_region(i - 1, tabs, tol / 2);
  }
}

module split(i, tabs) intersection() { children(); piece_mask(i, tabs); }

// 2D lid outline, grown by g
module lid2d(g = 0) translate([lx0 + lid_w / 2, ly0 + lid_h / 2]) rrect(lid_w + 2 * g, lid_h + 2 * g, lid_r + g);

// ---------------------------------------------------------------- frame (front clamp ring)
module frame_full() {
  difference() {
    cube([W, H, zb]);
    translate([0, 0, lip_t]) linear_extrude(zb) lid2d(fit);
    translate([0, 0, -1]) linear_extrude(lip_t + 2) lid2d(-lip_w);
    // cable channel below the lid's bottom edge
    translate([cable_x[0], ly0 - fit - cable_d, lip_t]) cube([cable_exit[1], cable_d + fit + 1, zb]);
    for (p = screw_pts) translate([p[0], p[1], zb - screw_pilot_depth]) cylinder(d = screw_pilot_d, h = screw_pilot_depth + 1);
    grooves();
  }
}

// ---------------------------------------------------------------- tray (on the lid back, board standoffs)
module tray_full() {
  difference() {
    union() {
      translate([0, 0, z_tray]) linear_extrude(tray_t) lid2d(-rim_over - tray_inset);
      for (h = board_holes) translate([board_pos[0] + h[0], board_pos[1] + h[1], z_tray + tray_t - 0.01]) cylinder(d = 6, h = gap);
    }
    for (h = board_holes) translate([board_pos[0] + h[0], board_pos[1] + h[1], z_board - m2_insert_depth]) cylinder(d = m2_insert_d, h = m2_insert_depth + 1);
    for (a = lid_anchors) translate([lx0 + a[0], ly0 + a[1], z_tray - 1]) cylinder(d = anchor_clear_d, h = tray_t + 2);
  }
}

// ---------------------------------------------------------------- shell (back cover)
module cradle(size, open_right) {
  w = cradle_wall;
  difference() {
    translate([-w, -w, -cradle_h]) cube([size[0] + 2 * w, size[1] + 2 * w, cradle_h]);
    translate([0, 0, -cradle_h - 1]) cube([size[0] + (open_right ? w + 1 : 0), size[1], cradle_h + 2]);
  }
}

module port_cut(p) {
  y = board_pos[1] + p[1];
  z = z_board_back + p[2];
  x = p[0] == "L" ? -1 : W - shell_wall - 1;
  translate([x, y, z]) rotate([0, 90, 0]) linear_extrude(shell_wall + 2)
    rrect(p[4] + 2 * port_clear, p[3] + 2 * port_clear, 1);
}

module shell_full() {
  esp_x = W - shell_wall - esp_size[0];
  difference() {
    union() {
      difference() {
        translate([0, 0, zb]) cube([W, H, D - zb]);
        translate([shell_wall, shell_wall, zb - 1]) cube([W - 2 * shell_wall, H - 2 * shell_wall, z_in - zb + 1]);
      }
      // front rim, clamps the lid's back edge (cable channel left open)
      translate([0, 0, zb]) difference() {
        cube([W, H, rim_t]);
        translate([0, 0, -1]) linear_extrude(rim_t + 2) lid2d(-rim_over);
        translate([cable_x[0], ly0 - fit - cable_d, -1]) cube([cable_exit[1], cable_d + fit + rim_over + 1, rim_t + 2]);
      }
      for (p = screw_pts) translate([p[0], p[1], zb]) cylinder(d = boss_d, h = D - zb);
      // VESA bosses + ribs
      for (dx = [-1, 1], dy = [-1, 1]) translate([vesa_c[0] + dx * vesa / 2, vesa_c[1] + dy * vesa / 2, z_in - vesa_boss_h]) cylinder(d = vesa_boss_d, h = vesa_boss_h + 0.01);
      for (dx = [-1, 1]) translate([vesa_c[0] + dx * vesa / 2 - rib_t / 2, shell_wall, z_in - rib_h]) cube([rib_t, H - 2 * shell_wall, rib_h + 0.01]);
      for (dy = [-1, 1]) translate([vesa_c[0] - vesa / 2, vesa_c[1] + dy * vesa / 2 - rib_t / 2, z_in - rib_h]) cube([vesa, rib_t, rib_h + 0.01]);
      // electronics cradles
      translate([esp_x, esp_y, z_in + 0.01]) cradle(esp_size, true);
      for (y = buck_y) translate([W - shell_wall - cradle_wall - buck_size[0] - 2, y, z_in + 0.01]) cradle(buck_size, false);
      // DC jack sleeve
      translate([W - dc_sleeve, dc_jack_y - dc_jack[0] / 2 - fit - cradle_wall, dc_jack_z - dc_jack[1] / 2 - fit - cradle_wall])
        cube([dc_sleeve, dc_jack[0] + 2 * (fit + cradle_wall), dc_jack[1] + 2 * (fit + cradle_wall)]);
    }
    // shell screws: clearance + counterbore from the back
    for (p = screw_pts) {
      translate([p[0], p[1], zb - 1]) cylinder(d = screw_clear, h = D);
      translate([p[0], p[1], zb + screw_floor]) cylinder(d = screw_head, h = D);
    }
    // VESA inserts from the back
    for (dx = [-1, 1], dy = [-1, 1]) translate([vesa_c[0] + dx * vesa / 2, vesa_c[1] + dy * vesa / 2, D - vesa_insert_depth]) cylinder(d = vesa_insert_d, h = vesa_insert_depth + 1);
    // fan grille (concentric rings with 4 spokes) + screw holes
    translate([fan_c[0], fan_c[1], z_in - 1]) linear_extrude(back_t + 2) difference() {
      union() for (r = [15 : 9 : fan_size / 2 - 5]) difference() { circle(r = r); circle(r = r - 5); }
      for (a = [0, 90]) rotate(a + 45) square([fan_size, 4], center = true);
    }
    for (dx = [-1, 1], dy = [-1, 1]) translate([fan_c[0] + dx * fan_hole_pitch / 2, fan_c[1] + dy * fan_hole_pitch / 2, z_in - 1]) cylinder(d = fan_hole_d, h = back_t + 2);
    // vents: bottom = intake, top = exhaust (chimney)
    for (x = [vent_end : vent_pitch : W - vent_end])
      if (min([for (s = concat(screw_x, seams)) abs(x - s)]) > boss_d / 2 + 2)
        for (y = [-1, H - shell_wall - 1]) translate([x - vent_w / 2, y, zb + rim_t + 2]) cube([vent_w, shell_wall + 2, z_in - zb - rim_t - 4]);
    // optional side ports, ESP32 USB-C, DC jack
    for (p = ports) port_cut(p);
    translate([W - shell_wall - 1, esp_y + esp_size[1] / 2, z_in - 3.2]) rotate([0, 90, 0]) linear_extrude(shell_wall + 2) rrect(4.5, 10, 1.5);
    // stock DC-in jack: slot through the wall + sleeve pocket, jack slides in from inside
    translate([W - dc_sleeve - 1, dc_jack_y - dc_jack[0] / 2 - fit, dc_jack_z - dc_jack[1] / 2 - fit]) cube([dc_sleeve + 2, dc_jack[0] + 2 * fit, dc_jack[1] + 2 * fit]);
    grooves();
  }
}

module shell_clipped() intersection() { shell_full(); cube([W, H, D]); }

// ---------------------------------------------------------------- ghosts
module ghosts() {
  %translate([0, 0, lip_t]) linear_extrude(lid_t) lid2d();
  %translate([board_pos[0], board_pos[1], z_board]) cube([board_w, board_h, board_t]);
  for (b = blowers) %translate([board_pos[0] + b[0], board_pos[1] + b[1], z_board_back]) cylinder(d = b[2] + 10, h = heatsink_h);
  %translate([fan_rect[0], fan_rect[1], z_in - fan_t]) cube([fan_size, fan_size, fan_t]);
  %translate([W - shell_wall - esp_size[0], esp_y, z_in - 1.6]) cube([esp_size[0], esp_size[1], 1.6]);
  %translate([W - shell_wall - dc_jack[2], dc_jack_y - dc_jack[0] / 2, dc_jack_z - dc_jack[1] / 2]) cube([dc_jack[2], dc_jack[0], dc_jack[1]]);
}

// ---------------------------------------------------------------- parts
names = ["l", "m", "r"];
function idx(s) = [for (k = [0 : len(names) - 1]) if (names[k] == s) k][0];

module print_frame(i) translate([-bounds[i], 0, 0]) split(i, frame_tabs) frame_full();
module print_tray(i) translate([-bounds[i], 0, -z_tray]) split(i, tray_tabs) tray_full();
module print_shell(i) translate([-bounds[i], 0, D]) mirror([0, 0, 1]) split(i, shell_tabs) shell_clipped();

module assembly() {
  cols = ["SteelBlue", "LightSteelBlue", "SteelBlue"];
  for (i = [0 : len(bounds) - 2]) {
    color(cols[i]) split(i, frame_tabs) frame_full();
    color("Silver") translate([0, 0, explode * 0.5]) split(i, tray_tabs) tray_full();
    color(cols[i], 0.9) translate([0, 0, explode]) split(i, shell_tabs) shell_clipped();
  }
  if (show_ghosts) ghosts();
}

// ---------------------------------------------------------------- test prints
// Small slices of the real parts, to check fit before printing full pieces.
module test_cut(b) intersection() { children(); translate([b[0], b[1], -1]) cube([b[2], b[3], D + 2]); }

// Bottom-left frame corner: lid fit, corner radius, lip over the bezel, pocket depth.
module test_corner() test_cut([0, 0, 70, 50]) frame_full();

// Frame + shell around the left seam, bottom wall: dovetails, groove, one shell screw.
// Front row = frame halves, back row = shell halves (print orientation), 10 mm apart.
module test_seam() {
  b = [seams[0] - 20, 0, 40, 40];
  for (i = [0, 1]) translate([-b[0] + i * 10, 0, 0]) {
    test_cut(b) split(i, frame_tabs) frame_full();
    translate([0, b[3] + 10, D]) mirror([0, 0, 1]) test_cut(b) split(i, shell_tabs) shell_clipped();
  }
}

if (part == "assembly") assembly();
else if (part == "test_corner") test_corner();
else if (part == "test_seam") test_seam();
else {
  kind = substr(part);
  i = idx(part[len(part) - 1]);
  if (kind == "frame") print_frame(i);
  else if (kind == "tray") print_tray(i);
  else if (kind == "shell") print_shell(i);
}

function substr(s) = let(p = search("_", s)[0]) chr([for (k = [0 : p - 1]) ord(s[k])]);
