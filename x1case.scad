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

part = "assembly"; // [assembly, frame_lb, frame_lt, frame_mb, frame_mt, frame_rb, frame_rt, tray_lb, tray_lt, tray_mb, tray_mt, tray_rb, tray_rt, shell_lb, shell_lt, shell_mb, shell_mt, shell_rb, shell_rt, hood, test_corner, test_seam, test_holes_l, test_holes_r]

/* [Print] */
bed = 256;          // Bambu Lab P2S bed (mm)
bed_margin = 3;     // keep-out at the bed edge

/* [Display lid: measured with the hinges removed, PLACEHOLDER where marked] */
lid_w = 361;        // outline width (measured)
lid_h = 245;        // outline height, hinge stubs not included (measured)
lid_t = 7;          // thickness, glass to back cover, at the thickest point (measured: lid is flat, 6.7-7)
lid_t_edge = 7;     // thickness 3 mm in from the outline; the clamp grips here (measured)
lid_r = 3;          // corner radius (seen from the front), guessed small on purpose: too small only leaves a gap at the corner, too big stops the lid from seating
// Panel (from EDID on the 20MF000TGE): AUO B156ZAN03.2, 3840x2160, active area 344 x 193 mm.
bezel = [8.8, 8, 14, 37]; // measured: lid edge to first lit pixel: [left, right, top, bottom]; 8.8 + 344.2 + 8 = lid_w, 14 + 193 + 37 = lid_h ±1
lip_w = 3;          // how far the clamp lip reaches over the lid's front edge (left, right, top): narrow front border
lip_w_bottom = 14;  // bottom lip: covers the open strip with the antennas and cables along the hinge edge
// Hinge stubs: fixed to the lid (no screw), stick out on the glass side inside the bottom strip.
// [x from the lid's left edge, width, height up from the bottom edge]; the right one mirrors at 44 mm from the right edge.
stubs = [[44, 6, 8], [361 - 44 - 6, 6, 8]];
stub_out = 12;      // how far a stub sticks out past the glass (measured)
stub_clear = 0.5;   // gap around a stub, per side
hood_wall = 1.6;    // stub hood: printed separately, glued on the front over the hole in the lip
fit = 0.3;          // lid clearance per side
// Cable bundle (eDP, touch, webcam, Wi-Fi) leaving the lid's bottom edge at the old hinge gap
cable_exits = [[92.5, 15], [282.5, 15]]; // [start x from the lid's left edge, width]: centred ~100 mm from the left, ~60 mm from the right (measured); round cables only, no ribbon
cable_d = 4.5;            // channel depth below the lid edge, inside the bottom clamp wall

/* [Case] */
clamp_wall = 4.5;         // clamp wall left, right and top (thin so the height fits the bed)
clamp_wall_bottom = 7.5;  // bottom clamp wall, holds the cable channel
lip_t = 2;          // front lip thickness
tray_t = 2;         // board tray on the lid back
gap = 5;            // air gap between tray and board (= board standoff height)
shell_wall = 3;     // back shell side walls
back_t = 2.5;       // back shell rear plate
rim_t = 5;          // shell front rim; its underside is recessed tray_t deep where the tray edge sits
rim_over = 6;       // how far the rim reaches over the lid's back edge: presses the tray edge onto the lid
tray_inset = 0.5;   // tray outline inside the lid outline
tol = 0.2;          // dovetail glue gap (total)

/* [Split: seams must avoid the fan, VESA bosses and cable channel] */
seams = [61.5, 309];       // real seams (X positions), glued dovetails: just outside the two fans, symmetric
hseam = 137;             // horizontal seam (Y position): between the fans and the VESA pad
fake_grooves = false;     // mirrored decorative grooves (the seams are already symmetric)
groove_w = 1.2;           // V-groove width at the surface

/* [Mainboard: PLACEHOLDERS] */
board_w = 355;            // board outline width (measured)
board_h = 138;            // board outline height (measured)
board_t = 1.2;
board_bottom_gap = 4;     // board bottom edge above the lid's bottom edge: board sits low, short cables
// PLACEHOLDER mounting holes, relative to the board's bottom-left corner
board_holes = [[28, 4], [41.5, 34], [109.5, 132], [245, 132], [175, 18], [242, 3.5], [127, 3.5],
               [349, 15], [352, 47], [350, 75], [353, 94], [343, 103]]; // H1-H12, measured; M2 (silkscreen M2XL3.5). Right-edge x approximate (edge not straight)
// Stock cooler: one blower at each end of the board, heatpipes between, fin stacks on the board's top edge.
// Blower intake centres [x, y] + intake diameter, relative to the board's bottom-left corner.
blowers = [[56, 88, 41], [290, 90, 41]]; // measured
// Fin-stack exhausts on the board's top edge: [start x, width]. They blow up into the top vents.
fin_exhausts = [[34, 72], [250, 66]];    // measured
heatsink_h = 10;          // tallest part on the back side: blowers, ~10 mm (measured)
comp_h = 5;               // PLACEHOLDER tallest other part on the back side (RAM, SSD)
m2_insert_d = 3.2;        // M2 heat-set insert hole
m2_insert_depth = 4;
// Stock DC-in jack: on a short cable next to the right fin stack. It points out through the back plate,
// so the charger (brick stays outside the case) plugs in from behind.
// The jack barely moves, so instead of a fitted sleeve the back plate gets an oversized window around it;
// fix the jack in the window with hot glue.
dc_window = [316, 120, 27, 28]; // [x, y, w, h] from the board's bottom-left corner (jack at ~x 325, at the top edge)
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
fan_gap = 1;              // between the two fans
fan_y = 72;               // fan centre height (global): low, over the heatpipe, below the VESA pad

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
buck_y = [72, 97];        // clear of the horizontal seam tabs
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
inner_d = tray_t + gap + board_t + max(heatsink_h + fan_clear + fan_t, comp_h); // fans sit over the heatpipe and blowers
D = z_tray + inner_d + back_t;      // total depth
z_in = D - back_t;                  // inside face of the back plate

board_pos = [(W - board_w) / 2, ly0 + board_bottom_gap];
cable_x = [for (c = cable_exits) [lx0 + c[0], lx0 + c[0] + c[1]]]; // global X ranges

bounds = concat([0], seams, [W]);
// two 120 mm fans side by side, centred, over the heatpipe
fan_cs = [for (k = [-1, 1]) [W / 2 + k * (fan_size + fan_gap) / 2, fan_y]];
// VESA pad as high as it goes, above the fans
vesa_c = [W / 2, H - shell_wall - vesa / 2 - vesa_boss_d / 2 + 1]; // +1: top bosses merge into the wall (tangent = non-manifold)
groove_x = fake_grooves ? concat(seams, [for (s = seams) W - s]) : seams;

screw_x = [for (i = [0 : len(bounds) - 2]) each [bounds[i] + screw_inset, bounds[i + 1] - screw_inset]];
screw_pts = concat(
  [for (x = screw_x) if (len([for (c = cable_x) if (x > c[0] - boss_d && x < c[1] + boss_d) 1]) == 0) [x, clamp_wall_bottom / 2]],
  [for (x = screw_x) [x, H - clamp_wall / 2]],
  [for (f = side_screw_y_rel) [clamp_wall / 2, H * f]],
  [for (f = side_screw_y_rel) [W - clamp_wall / 2, H * f]]);

// Dovetail tabs per part: [y, neck, head, length]
frame_tabs = [[clamp_wall_bottom / 2, 2.5, 4, 3], [H - clamp_wall / 2, 2, 3.5, 3]];
shell_tabs = [[clamp_wall_bottom / 2, 2.5, 4, 3], [H - clamp_wall / 2, 2, 3.5, 3],
              [H * 0.12, 6, 10, 5], [H * 0.5, 6, 10, 5], [H * 0.75, 6, 10, 5]];
tray_tabs = [[ly0 + lid_h * 0.12, 6, 10, 5], [ly0 + lid_h * 0.5, 6, 10, 5],
             [ly0 + lid_h * 0.8, 6, 10, 5]];
// Horizontal seam tabs: [x, neck, head, length]. Frame: in the side walls. Shell + tray: two per column, in the plate.
rows = [0, hseam, H];
frame_htabs = [[clamp_wall / 2, 2, 3.5, 3], [W - clamp_wall / 2, 2, 3.5, 3]];
plate_htabs = [for (i = [0 : len(bounds) - 2]) let(c = (bounds[i] + bounds[i + 1]) / 2) each [[c - 25, 6, 10, 5], [c + 25, 6, 10, 5]]];

// ---------------------------------------------------------------- checks
function rects_overlap(a, b) = a[0] < b[0] + b[2] && b[0] < a[0] + a[2] && a[1] < b[1] + b[3] && b[1] < a[1] + a[3];
fan_rects = [for (c = fan_cs) [c[0] - fan_size / 2, c[1] - fan_size / 2, fan_size, fan_size]];
vesa_rect = [vesa_c[0] - vesa / 2 - vesa_boss_d / 2, vesa_c[1] - vesa / 2 - vesa_boss_d / 2, vesa + vesa_boss_d, vesa + vesa_boss_d];

echo(str("Case outer W x H x D = ", W, " x ", H, " x ", D, " mm"));
for (i = [0 : len(bounds) - 2], j = [0, 1]) {
  w = bounds[i + 1] - bounds[i];
  h = rows[j + 1] - rows[j];
  if (w > bed - 2 * bed_margin || h > bed - 2 * bed_margin)
    echo(str("WARNING: piece ", i, "/", j, " (", w, " x ", h, ") does not fit the bed"));
}
for (f = fan_rects) if (hseam > f[1] - 3 && hseam < f[1] + fan_size + 3) echo("WARNING: horizontal seam cuts a fan");
if (hseam > vesa_rect[1] - 3 && hseam < vesa_rect[1] + vesa_rect[3] + 3) echo("WARNING: horizontal seam cuts the VESA pad");
if (hseam < esp_y + esp_size[1] + cradle_wall + 2 && hseam > esp_y - cradle_wall - 2) echo("WARNING: horizontal seam cuts the ESP32 cradle");
for (y = buck_y) if (hseam + 6 > y - cradle_wall && hseam < y + buck_size[1] + cradle_wall) echo("WARNING: horizontal seam tabs hit a buck cradle");
for (f = fan_rects) {
  if (f[0] < shell_wall || f[1] < shell_wall || f[0] + fan_size > W - shell_wall || f[1] + fan_size > H - shell_wall)
    echo("WARNING: a fan does not fit inside the shell walls");
  if (rects_overlap(f, vesa_rect)) echo("WARNING: a fan overlaps the VESA bosses");
}
for (s = seams) {
  for (f = fan_rects) if (s > f[0] - 3 && s < f[0] + f[2] + 3) echo(str("WARNING: seam ", s, " cuts a fan"));
  if (s > vesa_rect[0] - 3 && s < vesa_rect[0] + vesa_rect[2] + 3) echo(str("WARNING: seam ", s, " cuts the VESA pad"));
}
for (s = seams, c = cable_x) if (s > c[0] - 5 && s < c[1] + 5) echo(str("WARNING: seam ", s, " cuts a cable channel"));
for (s = seams) if (s > board_pos[0] + dc_window[0] - 3 && s < board_pos[0] + dc_window[0] + dc_window[2] + 3) echo(str("WARNING: seam ", s, " cuts the DC jack window"));
if (min([bezel[0], bezel[1], bezel[2]]) <= lip_w || bezel[3] <= lip_w_bottom) echo("WARNING: clamp lip covers lit pixels (lip_w or lip_w_bottom >= a bezel value)");

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
    hit = [for (c = fan_cs) if (x > c[0] - fan_size / 2 && x < c[0] + fan_size / 2) c];
    if (len(hit) > 0) {
      for (seg = [[-1, hit[0][1] - fan_size / 2], [hit[0][1] + fan_size / 2, H + 1]])
        translate([x, (seg[0] + seg[1]) / 2, D]) rotate([0, 45, 0]) cube([s, seg[1] - seg[0], s], center = true);
    } else translate([x, H / 2, D]) rotate([0, 45, 0]) cube([s, H + 2, s], center = true);
    for (y = [0, H]) translate([x, y, D / 2]) rotate([0, 0, 45]) cube([s, s, D + 2], center = true);
  }
  // horizontal seam: front, back and both side faces (no mirrored fake, it would cross the fan)
  for (z = [0, D]) translate([W / 2, hseam, z]) rotate([45, 0, 0]) cube([W + 2, s, s], center = true);
  for (x = [0, W]) translate([x, hseam, D / 2]) rotate([0, 0, 45]) cube([s, s, D + 2], center = true);
}

// 2D region left of seam i, including that seam's dovetail tabs
module seam_region(i, tabs, grow) {
  offset(delta = grow) union() {
    translate([-50, -50]) square([seams[i] + 50, H + 100]);
    for (t = tabs) translate([seams[i], t[0]])
      polygon([[-0.01, -t[1] / 2], [t[3], -t[2] / 2], [t[3], t[2] / 2], [-0.01, t[1] / 2]]);
  }
}

// 2D region below the horizontal seam, including its dovetail tabs
module row_region(htabs, grow) {
  offset(delta = grow) union() {
    translate([-50, -50]) square([W + 100, hseam + 50]);
    for (t = htabs) translate([t[0], hseam])
      polygon([[-t[1] / 2, -0.01], [-t[2] / 2, t[3]], [t[2] / 2, t[3]], [t[1] / 2, -0.01]]);
  }
}

// column i (left to right), row j (0 = bottom, 1 = top)
module piece_mask(i, j, tabs, htabs) {
  n = len(seams);
  translate([0, 0, -50]) linear_extrude(D + 100) intersection() {
    difference() {
      if (i < n) seam_region(i, tabs, -tol / 2);
      else translate([-50, -50]) square([W + 100, H + 100]);
      if (i > 0) seam_region(i - 1, tabs, tol / 2);
    }
    if (j == 0) row_region(htabs, -tol / 2);
    else difference() { translate([-50, -50]) square([W + 100, H + 100]); row_region(htabs, tol / 2); }
  }
}

module split(i, j, tabs, htabs) intersection() { children(); piece_mask(i, j, tabs, htabs); }

// 2D lid outline, grown by g
module lid2d(g = 0) translate([lx0 + lid_w / 2, ly0 + lid_h / 2]) rrect(lid_w + 2 * g, lid_h + 2 * g, lid_r + g);

// ---------------------------------------------------------------- frame (front clamp ring)
module frame_full() {
  difference() {
    cube([W, H, zb]);
    translate([0, 0, lip_t]) linear_extrude(zb) lid2d(fit);
    // window: lip_w on three sides, lip_w_bottom along the hinge edge
    translate([lx0 + lid_w / 2, ly0 + (lip_w_bottom + lid_h - lip_w) / 2, -1]) linear_extrude(lip_t + 2)
      rrect(lid_w - 2 * lip_w, lid_h - lip_w - lip_w_bottom, max(lid_r - lip_w, 1));
    // hinge stubs poke through the lip; a glued-on hood covers each one
    for (t = stubs) translate([lx0 + t[0] - stub_clear, ly0 - fit, -1]) cube([t[1] + 2 * stub_clear, t[2] + fit + stub_clear, lip_t + 2]);
    for (c = cable_x) translate([c[0], ly0 - fit - cable_d, lip_t]) cube([c[1] - c[0], cable_d + fit + 1, zb]);
    for (p = screw_pts) translate([p[0], p[1], zb - screw_pilot_depth]) cylinder(d = screw_pilot_d, h = screw_pilot_depth + 1);
    grooves();
  }
}

// ---------------------------------------------------------------- tray (on the lid back, board standoffs)
module tray_full() {
  difference() {
    union() {
      // full lid outline: the shell rim clamps the tray edge onto the lid, no screws or glue
      translate([0, 0, z_tray]) linear_extrude(tray_t) lid2d(-tray_inset);
      for (h = board_holes) translate([board_pos[0] + h[0], board_pos[1] + h[1], z_tray + tray_t - 0.01]) cylinder(d = 6, h = gap);
    }
    for (h = board_holes) translate([board_pos[0] + h[0], board_pos[1] + h[1], z_board - m2_insert_depth]) cylinder(d = m2_insert_d, h = m2_insert_depth + 1);
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
        for (c = cable_x) translate([c[0], ly0 - fit - cable_d, -1]) cube([c[1] - c[0], cable_d + fit + rim_over + 1, rim_t + 2]);
      }
      for (p = screw_pts) translate([p[0], p[1], zb]) cylinder(d = boss_d, h = D - zb);
      // VESA bosses + ribs
      for (dx = [-1, 1], dy = [-1, 1]) translate([vesa_c[0] + dx * vesa / 2, vesa_c[1] + dy * vesa / 2, z_in - vesa_boss_h]) cylinder(d = vesa_boss_d, h = vesa_boss_h + 0.01);
      for (dx = [-1, 1]) translate([vesa_c[0] + dx * vesa / 2 - rib_t / 2, vesa_c[1] - vesa / 2, z_in - rib_h]) cube([rib_t, vesa, rib_h + 0.01]);
      for (dy = [-1, 1]) translate([vesa_c[0] - vesa / 2, vesa_c[1] + dy * vesa / 2 - rib_t / 2, z_in - rib_h]) cube([vesa, rib_t, rib_h + 0.01]);
      // electronics cradles
      translate([esp_x, esp_y, z_in + 0.01]) cradle(esp_size, true);
      for (y = buck_y) translate([W - shell_wall - cradle_wall - buck_size[0] - 2, y, z_in + 0.01]) cradle(buck_size, false);
    }
    // shell screws: clearance + counterbore from the back
    for (p = screw_pts) {
      translate([p[0], p[1], zb - 1]) cylinder(d = screw_clear, h = D);
      translate([p[0], p[1], zb + screw_floor]) cylinder(d = screw_head, h = D);
    }
    // VESA inserts from the back
    for (dx = [-1, 1], dy = [-1, 1]) translate([vesa_c[0] + dx * vesa / 2, vesa_c[1] + dy * vesa / 2, D - vesa_insert_depth]) cylinder(d = vesa_insert_d, h = vesa_insert_depth + 1);
    // fan grille (concentric rings with 4 spokes) + screw holes
    for (c = fan_cs) translate([c[0], c[1], z_in - 1]) linear_extrude(back_t + 2) difference() {
      union() for (r = [15 : 9 : fan_size / 2 - 5]) difference() { circle(r = r); circle(r = r - 5); }
      for (a = [0, 90]) rotate(a + 45) square([fan_size, 4], center = true);
    }
    for (c = fan_cs, dx = [-1, 1], dy = [-1, 1]) translate([c[0] + dx * fan_hole_pitch / 2, c[1] + dy * fan_hole_pitch / 2, z_in - 1]) cylinder(d = fan_hole_d, h = back_t + 2);
    // vents: bottom = intake, top = exhaust (chimney)
    for (x = [vent_end : vent_pitch : W - vent_end])
      if (min([for (s = concat(screw_x, seams)) abs(x - s)]) > boss_d / 2 + 2)
        for (y = [-1, H - shell_wall - 1]) translate([x - vent_w / 2, y, zb + rim_t + 2]) cube([vent_w, shell_wall + 2, z_in - zb - rim_t - 4]);
    // optional side ports, ESP32 USB-C, DC jack
    for (p = ports) port_cut(p);
    translate([W - shell_wall - 1, esp_y + esp_size[1] / 2, z_in - 3.2]) rotate([0, 90, 0]) linear_extrude(shell_wall + 2) rrect(4.5, 10, 1.5);
    // stock DC-in jack: oversized window in the back plate, jack hot-glued in place
    translate([board_pos[0] + dc_window[0], board_pos[1] + dc_window[1], z_in - 1]) linear_extrude(back_t + 2) translate([dc_window[2] / 2, dc_window[3] / 2]) rrect(dc_window[2], dc_window[3], 3);
    // recess for the tray edge: the rim presses the tray onto the lid
    translate([0, 0, zb - 1]) linear_extrude(tray_t + 1) lid2d(-tray_inset + 0.3);
    // clearance around board standoffs near the edge
    for (h = board_holes) translate([board_pos[0] + h[0], board_pos[1] + h[1], zb - 1]) cylinder(d = 7, h = rim_t + 2);
    grooves();
  }
}

module shell_clipped() intersection() { shell_full(); cube([W, H, D]); }

// ---------------------------------------------------------------- ghosts
module ghosts() {
  %translate([0, 0, lip_t]) linear_extrude(lid_t) lid2d();
  %translate([board_pos[0], board_pos[1], z_board]) cube([board_w, board_h, board_t]);
  for (b = blowers) %translate([board_pos[0] + b[0], board_pos[1] + b[1], z_board_back]) cylinder(d = b[2] + 10, h = heatsink_h);
  for (f = fan_rects) %translate([f[0], f[1], z_in - fan_t]) cube([fan_size, fan_size, fan_t]);
  %translate([W - shell_wall - esp_size[0], esp_y, z_in - 1.6]) cube([esp_size[0], esp_size[1], 1.6]);
}

// ---------------------------------------------------------------- parts
names = ["l", "m", "r"];
function idx(s) = [for (k = [0 : len(names) - 1]) if (names[k] == s) k][0];

module print_frame(i, j) translate([-bounds[i], -rows[j], 0]) split(i, j, frame_tabs, frame_htabs) frame_full();
module print_tray(i, j) translate([-bounds[i], -rows[j], -z_tray]) split(i, j, tray_tabs, plate_htabs) tray_full();
module print_shell(i, j) translate([-bounds[i], -rows[j], D]) mirror([0, 0, 1]) split(i, j, shell_tabs, plate_htabs) shell_clipped();

module assembly() {
  cols = ["SteelBlue", "LightSteelBlue", "SteelBlue"];
  for (i = [0 : len(bounds) - 2], j = [0, 1]) {
    color(cols[i]) split(i, j, frame_tabs, frame_htabs) frame_full();
    color("Silver") translate([0, 0, explode * 0.5]) split(i, j, tray_tabs, plate_htabs) tray_full();
    color(cols[i], 0.9) translate([0, 0, explode]) split(i, j, shell_tabs, plate_htabs) shell_clipped();
  }
  for (t = stubs) color(cols[0]) translate([lx0 + t[0] - stub_clear - hood_wall, ly0 - fit - hood_wall, 0]) mirror([0, 0, 1]) hood(t);
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
    test_cut(b) split(i, 0, frame_tabs, frame_htabs) frame_full();
    translate([0, b[3] + 10, D]) mirror([0, 0, 1]) test_cut(b) split(i, 0, shell_tabs, plate_htabs) shell_clipped();
  }
}

// Board hole check: thin skeleton of the board outline with a pin at every mounting hole.
// Two halves (the board is wider than the bed); butt them together on a flat table, lay the board on top.
test_holes_split = 205;   // between H5 (x 175) and H6 (x 242)
test_pin_d = 1.8;         // fits an M2 board hole loosely
module test_holes(k) {
  t = 1.2;
  ring = 6;
  translate([k == 0 ? 0 : -test_holes_split, 0, 0]) intersection() {
    union() {
      linear_extrude(t) {
        difference() { square([board_w, board_h]); translate([ring, ring]) square([board_w - 2 * ring, board_h - 2 * ring]); }
        // strap from each hole to the nearer long edge
        for (h = board_holes) {
          translate([h[0] - ring / 2, h[1] < board_h / 2 ? 0 : h[1]]) square([ring, h[1] < board_h / 2 ? h[1] : board_h - h[1]]);
          translate(h) circle(d = 7);
        }
      }
      for (h = board_holes) translate([h[0], h[1], 0]) cylinder(d = test_pin_d, h = t + 4);
    }
    translate([k == 0 ? -1 : test_holes_split, -1, -1]) cube([k == 0 ? test_holes_split + 1 : board_w, board_h + 2, 20]);
  }
}

// ---------------------------------------------------------------- stub hood
// Box over a hinge stub, open toward the frame; print open side down, glue on the front of the bottom lip.
module hood(t) {
  iw = t[1] + 2 * stub_clear;
  ih = t[2] + fit + stub_clear;
  d = stub_out - lip_t + stub_clear;
  difference() {
    cube([iw + 2 * hood_wall, ih + 2 * hood_wall, d + hood_wall]);
    translate([hood_wall, hood_wall, -1]) cube([iw, ih, d + 1]);
  }
}

if (part == "assembly") assembly();
else if (part == "hood") hood(stubs[0]); // print 2
else if (part == "test_holes_l") test_holes(0);
else if (part == "test_holes_r") test_holes(1);
else if (part == "test_corner") test_corner();
else if (part == "test_seam") test_seam();
else {
  kind = substr(part);
  i = idx(part[len(part) - 2]);
  j = part[len(part) - 1] == "t" ? 1 : 0;
  if (kind == "frame") print_frame(i, j);
  else if (kind == "tray") print_tray(i, j);
  else if (kind == "shell") print_shell(i, j);
}

function substr(s) = let(p = search("_", s)[0]) chr([for (k = [0 : p - 1]) ord(s[k])]);
