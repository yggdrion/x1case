// x1case.scad: all-in-one case for a Lenovo ThinkPad X1 Extreme Gen 1.
// The original display lid stays intact (panel, bezel, back cover); only the laptop base goes.
// A printed clamp wraps the lid's edges. A tray on the lid's back carries the mainboard, and the
// back shell carries two 120 mm assist fans (ESP32-controlled) with a VESA 100 mount between them.
//
// Coordinates: X = width (left to right, seen from the front), Y = height (bottom to top),
// Z = depth (z = 0 is the front face, +Z goes toward the back).
//
// Every value marked PLACEHOLDER is a guess. Measure the real part and replace it.
//
// Set `part`, render (F6) and export STL. Printable parts come out oriented for printing.

part = "assembly"; // [assembly, frame_lb, frame_lt, frame_rb, frame_rt, tray_lb, tray_lt, tray_rb, tray_rt, shell_lb, shell_lt, shell_rb, shell_rt, test_corner, test_seam, test_vesa, test_step, test_fan, stand]

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
lip_w = 2;          // how far the clamp lip reaches over the lid's front edge (left, right, top): narrow front border
lip_w_bottom = 14;  // bottom lip: covers the open strip with the antennas and cables along the hinge edge
// Hinge stubs: fixed to the lid (no screw), stick out on the glass side inside the bottom strip.
// [x from the lid's left edge, width, height up from the bottom edge]; the right one mirrors at 44 mm from the right edge.
stubs = [[44, 6, 8], [361 - 44 - 6, 6, 8]];
stub_clear = 0.5;   // gap around a stub, per side
fit = 0.3;          // lid clearance per side
// Cable bundle (eDP, touch, webcam, Wi-Fi) leaving the lid's bottom edge at the old hinge gap
// x = 0 is the lid edge that sits on the right when you look at the glass (test_corner fit check: the cable sits ~70 mm from that corner)
cable_exits = [[63.5, 15], [253.5, 15]]; // [start x, width]: centred ~70 mm and ~100 mm from the x = 0 edge (measured); round cables only, no ribbon
cable_d = 4.5;            // channel depth below the lid edge, inside the bottom clamp wall

/* [Case] */
clamp_wall = 6;           // clamp wall left, right and top: thick enough for an M2 heat-set insert (1.4 mm around the hole)
clamp_wall_bottom = 7.5;  // bottom clamp wall, holds the cable channel
lip_t = 1.2;        // front lip thickness: 6 layers at 0.2 mm; thin so the glass sits close to the front
tray_t = 2;         // board tray on the lid back
gap = 5;            // air gap between tray and board: M2 x 5 brass standoffs (female-female), screwed to the board and glued to the tray
shell_wall = 3;     // back shell side walls
back_t = 2.5;       // back shell rear plate
rim_t = 5;          // shell front rim; its underside is recessed tray_t deep where the tray edge sits
rim_over = 6;       // how far the rim reaches over the lid's back edge: presses the tray edge onto the lid
tray_inset = 0.5;   // tray outline inside the lid outline
tray_press = 0.3;   // shell recess this much shallower than the tray: the shell squeezes the tray onto the lid (lid measured 6.7-7)
top_t = 5;          // thin upper shell: depth behind the lid back (tray recess + 3 mm plate); above hseam only the lid is behind it
top_screw_floor = 2; // counterbore floor in the thin upper shell: M2 x 6 there (M2 x 10 in the deep part)
// Tray tape, board side, inside the board footprint only (no clamp surface there): aluminium tape (~0.1) with Kapton (~0.06) over it so the board can't short on the foil
tape_t = 0.2;
tol = 0.2;          // dovetail glue gap (total)

/* [Split: seams must avoid the fans, VESA bosses and cable channel] */
seams = [125.65];          // one real seam (X position), glued dovetails: in the gap between the left fan and the VESA pad
seam_clear = 2;            // min. distance from a seam to a fan frame or the VESA pad
hseam = 156;             // horizontal seam (Y position) = the shell step: deep box below (board, cooler, fans, VESA), thin plate above
fake_grooves = true;      // mirrored decorative groove on the right, between the VESA pad and the right fan
groove_w = 1.2;           // V-groove width at the surface

/* [Mainboard: PLACEHOLDERS] */
board_w = 355;            // board outline width (measured)
board_h = 138;            // board outline height (measured)
board_t = 1;              // measured
board_bottom_gap = 4;     // board bottom edge above the lid's bottom edge: board sits low, short cables
// No mounting holes in the model: the standoffs are glued to the flat tray wherever the board puts them.
// Board-relative values below are as measured: fin-stack edge on top, from the board's bottom-left corner.
// board_flip turns the board 180° in its plane: fin stacks at the bottom edge, next to the lid's cable exits.
board_flip = true;
// Stock cooler: one blower at each end of the board, heatpipes between, fin stacks on one long edge.
// Blower intake centres [x, y] + intake diameter.
blowers = [[56, 88, 41], [290, 90, 41]]; // measured
// Fin-stack exhausts on the fin edge: [start x, width]. Flipped, they blow down into the bottom vents.
fin_exhausts = [[34, 72], [250, 66]];    // measured
heatsink_h = 10;          // tallest part on the back side: blowers, ~10 mm (measured)
comp_h = 5;               // tallest other part on the back side (RAM, SSD): lower than the blowers (checked)
// Stock DC-in jack: on a short cable next to a fin stack, so with the board flipped it sits at the bottom edge.
// It points down through an oversized window in the shell's bottom wall (brick stays outside the case);
// fix the jack in the window with hot glue.
dc_jack_x = 325;          // jack centre x, board-relative as measured (fin edge on top)
dc_cut = [27, 16];        // bottom-wall window [width along X, height along Z], from the rim up
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
fan_y = 68;               // fan centre height (global): low, over the blower intakes (y ~60), clear of the bottom screw bosses

/* [VESA 100] */
vesa = 100;
vesa_insert_d = 5.7;      // M4 heat-set insert hole
vesa_insert_depth = 8.5;
vesa_boss_d = 14;
vesa_boss_h = 7;          // inside the shell, from the back plate
// VESA pad sits low, between the fans, in the same row as the heavy parts
rib_t = 3;
rib_h = 6;

/* [Shell screws: M2 machine screws (socket or button head) into M2 heat-set inserts in the frame wall] */
screw_inset = 15;         // from each piece's edges
side_screw_y_rel = [0.65]; // side-wall screws as a fraction of H: above the fans, which sit against the side walls
boss_d = 7;
screw_floor = 6;          // material under the counterbore
screw_clear = 2.4;
screw_head = 4.4;
insert_d = 3.2;           // M2 x 4 heat-set insert hole, melted in from the frame's back face
insert_depth = 4.5;

/* [Electronics bay: inside the VESA square, one row: ESP32, buck, buck] */
esp_size = [23.5, 18.5];  // ESP32-C3 SuperMini, flashed over the air (no wall port: the VESA plate covers it)
buck_size = [22, 17];     // MP1584-style buck, x2 (12 V fan, 5 V ESP32)
elec_gap = 5;             // between the cradles
cradle_wall = 1.6;
cradle_h = 4;

/* [Vents] */
vent_w = 3;
vent_w_fin = 5;           // bottom slots in front of the fin-stack exhausts: 5 mm open, 2 mm bars
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
inner_d = tray_t + gap + board_t + max(heatsink_h + fan_clear + fan_t, comp_h); // fans sit over the blowers
D = z_tray + inner_d + back_t;      // total depth
z_in = D - back_t;                  // inside face of the back plate

board_pos = [(W - board_w) / 2, ly0 + board_bottom_gap];
cable_x = [for (c = cable_exits) [lx0 + c[0], lx0 + c[0] + c[1]]]; // global X ranges
// board-relative point (as measured) -> global X/Y, honouring board_flip
function bp(q) = board_pos + (board_flip ? [board_w - q[0], board_h - q[1]] : [q[0], q[1]]);
blowers_g = [for (b = blowers) concat(bp(b), [b[2]])];                                            // [x, y, d] global
fins_g = [for (f = fin_exhausts) [bp([f[0] + (board_flip ? f[1] : 0), 0])[0], f[1]]];                  // [start x, width] global
dc_x = bp([dc_jack_x, 0])[0];                                                            // jack centre, global X

bounds = concat([0], seams, [W]);
// two 120 mm fans against the side walls, each over a blower intake
fan_cs = [for (k = [-1, 1]) [W / 2 + k * (W / 2 - shell_wall - fan_size / 2), fan_y]];
// VESA pad between the fans, same height
vesa_c = [W / 2, fan_y];
// electronics row centred in the VESA square: [x, y] of each cradle's inner corner
elec_w = esp_size[0] + 2 * buck_size[0] + 2 * elec_gap;
esp_pos = [vesa_c[0] - elec_w / 2, vesa_c[1] - esp_size[1] / 2];
buck_pos = [for (k = [0, 1]) [esp_pos[0] + esp_size[0] + elec_gap + k * (buck_size[0] + elec_gap), vesa_c[1] - buck_size[1] / 2]];
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
              [H * 0.12, 6, 10, 5], [H * 0.3, 6, 10, 5], [H * 0.75, 6, 10, 5]]; // 0.12 and 0.3: between the VESA bosses
tray_tabs = [[ly0 + lid_h * 0.12, 6, 10, 5], [ly0 + lid_h * 0.5, 6, 10, 5],
             [ly0 + lid_h * 0.8, 6, 10, 5]];
// Horizontal seam tabs: [x, neck, head, length]. Frame: in the side walls. Shell + tray: two per column, in the plate.
rows = [0, hseam, H];
frame_htabs = [[clamp_wall / 2, 2, 3.5, 3], [W - clamp_wall / 2, 2, 3.5, 3]];
plate_htabs = [for (i = [0 : len(bounds) - 2]) let(c = (bounds[i] + bounds[i + 1]) / 2) each [[c - 25, 6, 10, 5], [c + 25, 6, 10, 5]]];
shell_htabs = []; // shell: butt joint at the step, glued; the thin top pieces are held by their own screws into the frame

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
if (hseam - shell_wall < board_pos[1] + board_h + 2) echo("WARNING: shell step (hseam) is too low for the board");
if (elec_w + 2 * cradle_wall > vesa - rib_t - 2 || max(esp_size[1], buck_size[1]) + 2 * cradle_wall > vesa - rib_t - 2) echo("WARNING: electronics row does not fit inside the VESA square");
if (tape_t > gap - 1) echo("WARNING: tray tape eats the air gap under the board");
echo(str("Board air gap over the taped tray = ", gap - tape_t, " mm; tray squeeze = ", tray_press, " mm (", round(100 * (tray_press - (lid_t_edge - 6.7))) / 100, " mm on a 6.7 mm lid)"));
for (f = fan_rects) {
  if (f[0] < shell_wall || f[1] < shell_wall || f[0] + fan_size > W - shell_wall || f[1] + fan_size > H - shell_wall)
    echo("WARNING: a fan does not fit inside the shell walls");
  if (rects_overlap(f, vesa_rect)) echo("WARNING: a fan overlaps the VESA bosses");
  for (p = screw_pts) if (rects_overlap(f, [p[0] - boss_d / 2, p[1] - boss_d / 2, boss_d, boss_d])) echo("WARNING: a fan hits a shell screw boss");
}
for (s = seams) {
  for (f = fan_rects) if (s > f[0] - seam_clear && s < f[0] + f[2] + seam_clear) echo(str("WARNING: seam ", s, " cuts a fan"));
  if (s > vesa_rect[0] - seam_clear && s < vesa_rect[0] + vesa_rect[2] + seam_clear) echo(str("WARNING: seam ", s, " cuts the VESA pad"));
}
for (s = seams, c = cable_x) if (s > c[0] - 5 && s < c[1] + 5) echo(str("WARNING: seam ", s, " cuts a cable channel"));
for (s = seams) if (abs(s - dc_x) < dc_cut[0] / 2 + 3) echo(str("WARNING: seam ", s, " cuts the DC jack window"));
for (x = screw_x) if (abs(x - dc_x) < dc_cut[0] / 2 + boss_d / 2) echo(str("WARNING: shell screw at x ", x, " hits the DC jack window"));
for (c = cable_x) if (dc_x + dc_cut[0] / 2 > c[0] && dc_x - dc_cut[0] / 2 < c[1]) echo("WARNING: DC jack window overlaps a cable channel");
if (min([bezel[0], bezel[1], bezel[2]]) <= lip_w || bezel[3] <= lip_w_bottom) echo("WARNING: clamp lip covers lit pixels (lip_w or lip_w_bottom >= a bezel value)");

// ---------------------------------------------------------------- helpers
module rrect(w, h, r) {
  r2 = min(r, w / 2, h / 2);
  offset(r = r2) square([w - 2 * r2, h - 2 * r2], center = true);
}

// V-grooves on the front, back, top and bottom faces
module grooves() {
  s = groove_w / sqrt(2);
  zt = zb + top_t; // back face of the thin upper shell
  for (x = groove_x) {
    translate([x, H / 2, 0]) rotate([0, 45, 0]) cube([s, H + 2, s], center = true);
    // back face of the deep part: stop short of the fan grille
    hit = [for (c = fan_cs) if (x > c[0] - fan_size / 2 && x < c[0] + fan_size / 2) c];
    if (len(hit) > 0) {
      for (seg = [[-1, hit[0][1] - fan_size / 2], [hit[0][1] + fan_size / 2, hseam + 1]])
        translate([x, (seg[0] + seg[1]) / 2, D]) rotate([0, 45, 0]) cube([s, seg[1] - seg[0], s], center = true);
    } else translate([x, hseam / 2, D]) rotate([0, 45, 0]) cube([s, hseam + 2, s], center = true);
    translate([x, (hseam + H) / 2, zt]) rotate([0, 45, 0]) cube([s, H - hseam + 2, s], center = true); // thin part's back face
    translate([x, 0, D / 2]) rotate([0, 0, 45]) cube([s, s, D + 2], center = true);
    translate([x, H, zt / 2]) rotate([0, 0, 45]) cube([s, s, zt + 2], center = true);
    translate([x, hseam, (zt + D) / 2]) rotate([0, 0, 45]) cube([s, s, D - zt + 2], center = true); // step's top face
  }
  // horizontal seam: front face, step edge and both side faces (no mirrored fake, it would cross the fan)
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
    // hinge stubs poke through the lip (open hole, cut the stubs off later)
    for (t = stubs) translate([lx0 + t[0] - stub_clear, ly0 - fit, -1]) cube([t[1] + 2 * stub_clear, t[2] + fit + stub_clear, lip_t + 2]);
    for (c = cable_x) translate([c[0], ly0 - fit - cable_d, lip_t]) cube([c[1] - c[0], cable_d + fit + 1, zb]);
    for (p = screw_pts) translate([p[0], p[1], zb - insert_depth]) cylinder(d = insert_d, h = insert_depth + 1);
    grooves();
  }
}

// ---------------------------------------------------------------- tray (on the lid back, flat: board standoffs are glued on)
// full lid outline: the shell rim clamps the tray edge onto the lid, no screws or glue
module tray_full() translate([0, 0, z_tray]) linear_extrude(tray_t) lid2d(-tray_inset);

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

// outer envelope: deep box up to the step (hseam), thin plate above it
module shell_env() {
  translate([0, 0, zb]) cube([W, hseam, D - zb]);
  translate([0, hseam - 0.01, zb]) cube([W, H - hseam + 0.01, top_t]);
}

module shell_full() {
  difference() {
    union() {
      difference() {
        shell_env();
        translate([shell_wall, shell_wall, zb - 1]) cube([W - 2 * shell_wall, hseam - 2 * shell_wall, z_in - zb + 1]);
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
      // electronics cradles, inside the VESA square
      translate([esp_pos[0], esp_pos[1], z_in + 0.01]) cradle(esp_size, true);
      for (b = buck_pos) translate([b[0], b[1], z_in + 0.01]) cradle(buck_size, false);
    }
    // shell screws: clearance + counterbore from the back (shallower in the thin upper part)
    for (p = screw_pts) {
      translate([p[0], p[1], zb - 1]) cylinder(d = screw_clear, h = D);
      translate([p[0], p[1], zb + (p[1] > hseam ? top_screw_floor : screw_floor)]) cylinder(d = screw_head, h = D);
    }
    // VESA inserts from the back
    for (dx = [-1, 1], dy = [-1, 1]) translate([vesa_c[0] + dx * vesa / 2, vesa_c[1] + dy * vesa / 2, D - vesa_insert_depth]) cylinder(d = vesa_insert_d, h = vesa_insert_depth + 1);
    // fan grille (concentric rings with 4 spokes) + screw holes
    for (c = fan_cs) translate([c[0], c[1], z_in - 1]) linear_extrude(back_t + 2) difference() {
      union() for (r = [15 : 9 : fan_size / 2 - 5]) difference() { circle(r = r); circle(r = r - 5); }
      for (a = [0, 90]) rotate(a + 45) square([fan_size, 4], center = true);
    }
    for (c = fan_cs, dx = [-1, 1], dy = [-1, 1]) translate([c[0] + dx * fan_hole_pitch / 2, c[1] + dy * fan_hole_pitch / 2, z_in - 1]) cylinder(d = fan_hole_d, h = back_t + 2);
    // vents: bottom = fin-stack exhaust (board flipped), top = chimney through the step
    for (x = [vent_end : vent_pitch : W - vent_end])
      if (min([for (s = concat(screw_x, seams)) abs(x - s)]) > boss_d / 2 + 2)
        for (y = [-1, hseam - shell_wall - 1]) if (y > 0 || abs(x - dc_x) > dc_cut[0] / 2 + vent_w)
          let(vw = y < 0 && len([for (f = fins_g) if (x > f[0] - 2 && x < f[0] + f[1] + 2) 1]) > 0 ? vent_w_fin : vent_w)
            translate([x - vw / 2, y, zb + rim_t + 2]) cube([vw, shell_wall + 2, z_in - zb - rim_t - 4]);
    // optional side ports
    for (p = ports) port_cut(p);
    // stock DC-in jack: oversized window in the bottom wall, jack hot-glued in place
    translate([dc_x, -1, zb + rim_t + dc_cut[1] / 2]) rotate([-90, 0, 0]) linear_extrude(shell_wall + 2) rrect(dc_cut[0], dc_cut[1], 3);
    // recess for the tray: tray_press shallower than the tray, so the rim and the thin upper plate squeeze it onto the lid
    translate([0, 0, zb - 1]) linear_extrude(tray_t - tray_press + 1) lid2d(-tray_inset + 0.3);
    // rim stays out of the board footprint: the glued standoffs can sit anywhere under the board
    translate([board_pos[0], board_pos[1], zb - 1]) cube([board_w, board_h, rim_t + 2]);
    grooves();
  }
}

module shell_clipped() intersection() { shell_full(); shell_env(); }

// ---------------------------------------------------------------- ghosts
module ghosts() {
  %translate([0, 0, lip_t]) linear_extrude(lid_t) lid2d();
  %translate([board_pos[0], board_pos[1], z_board]) cube([board_w, board_h, board_t]);
  for (b = blowers_g) %translate([b[0], b[1], z_board_back]) cylinder(d = b[2] + 10, h = heatsink_h);
  for (f = fan_rects) %translate([f[0], f[1], z_in - fan_t]) cube([fan_size, fan_size, fan_t]);
  %translate([esp_pos[0], esp_pos[1], z_in - 1.6]) cube([esp_size[0], esp_size[1], 1.6]);
  for (b = buck_pos) %translate([b[0], b[1], z_in - 1.6]) cube([buck_size[0], buck_size[1], 1.6]);
}

// ---------------------------------------------------------------- parts
names = len(seams) == 1 ? ["l", "r"] : ["l", "m", "r"];
function idx(s) = [for (k = [0 : len(names) - 1]) if (names[k] == s) k][0];

module print_frame(i, j) translate([-bounds[i], -rows[j], 0]) split(i, j, frame_tabs, frame_htabs) frame_full();
module print_tray(i, j) translate([-bounds[i], -rows[j], -z_tray]) split(i, j, tray_tabs, plate_htabs) tray_full();
module print_shell(i, j) translate([-bounds[i], -rows[j], j == 1 ? zb + top_t : D]) mirror([0, 0, 1]) split(i, j, shell_tabs, shell_htabs) shell_clipped();

module assembly() {
  cols = ["SteelBlue", "LightSteelBlue", "SteelBlue"];
  for (i = [0 : len(bounds) - 2], j = [0, 1]) {
    color(cols[i]) split(i, j, frame_tabs, frame_htabs) frame_full();
    color("Silver") translate([0, 0, explode * 0.5]) split(i, j, tray_tabs, plate_htabs) tray_full();
    color(cols[i], 0.9) translate([0, 0, explode]) split(i, j, shell_tabs, shell_htabs) shell_clipped();
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
    test_cut(b) split(i, 0, frame_tabs, frame_htabs) frame_full();
    translate([0, b[3] + 10, D]) mirror([0, 0, 1]) test_cut(b) split(i, 0, shell_tabs, shell_htabs) shell_clipped();
  }
}

// One VESA boss (bottom right) with its ribs and back plate (back part only), back face down: M4 insert pull-out test.
module test_vesa() {
  b = [vesa_c[0] + vesa / 2 - 20, vesa_c[1] - vesa / 2 - 12, 40, 34];
  translate([-b[0], -b[1], D]) mirror([0, 0, 1]) intersection() {
    shell_clipped();
    translate([b[0], b[1], z_in - vesa_boss_h - 0.01]) cube([b[2], b[3], vesa_boss_h + back_t + 1]);
  }
}

// Left side wall around the step: frame bottom + top (front down), shell deep box + thin plate (back down),
// with the frame's horizontal dovetail, the shell butt joint and the side screw (M2 x 6 into an insert).
module test_step() {
  b = [0, hseam - 20, 35, 40];
  for (j = [0, 1]) translate([-b[0] + j * 45, -b[1], 0]) {
    test_cut(b) split(0, j, frame_tabs, frame_htabs) frame_full();
    translate([90, 0, j == 1 ? zb + top_t : D]) mirror([0, 0, 1]) test_cut(b) split(0, j, shell_tabs, shell_htabs) shell_clipped();
  }
}

// Strip of the left fan's back plate with its two bottom screw holes: hole pitch and grille against the real fan.
module test_fan() {
  c = fan_cs[0];
  b = [c[0] - fan_hole_pitch / 2 - 6, c[1] - fan_hole_pitch / 2 - 7.5, fan_hole_pitch + 12, 13.5]; // stops below the outer grille band, so no loose island
  translate([-b[0], -b[1], D]) mirror([0, 0, 1]) intersection() {
    shell_clipped();
    translate([b[0], b[1], z_in - 0.01]) cube([b[2], b[3], back_t + 1]);
  }
}

// ---------------------------------------------------------------- interim stand
// Two feet that hold the bare lid upright by its side edges until the case is printed.
// The feet sit outside the lid outline, so the board lies flat on the desk between them,
// under the lid (on its standoffs, blowers up). Printed standing on the base, no supports.
// Local coords: x = across (inner face at x = stand_w, lid edge toward +x), y = front to back, z = up.
stand_tilt = 12;      // lid leans back by this much
stand_h = 40;         // lid bottom edge above the desk: board on standoffs + blowers + air over the intakes
stand_grip = 80;      // how far the lid's side edge sits in the slot
stand_slot_d = 7;     // slot depth into the lid's side edge: stays inside the 8 mm side bezel
stand_w = 8;          // foot thickness outside the lid edge
stand_wall = 6;       // slot walls front and back
stand_ledge = 5;      // floor under the lid's bottom edge
stand_base = [-50, 110, 6, 12]; // base bar: [front y, back y, thickness, extra width outward]

if (stand_h - stand_ledge - stand_slot_d < gap + board_t + heatsink_h + 5)
  echo("WARNING: stand_h leaves no air over the blowers");
if (lid_w < board_w + 2) echo("WARNING: board does not fit between the stand feet");

module stand_foot() {
  slot = lid_t + 2 * fit;
  pw = slot + 2 * stand_wall;
  zl = stand_h / cos(stand_tilt);              // lid bottom edge, along the post
  L = zl + stand_grip;
  wf = stand_w + stand_slot_d;                 // full width, where the slot is
  module post(x0, x1, z0, z1) rotate([-stand_tilt, 0, 0]) translate([x0, -pw / 2, z0]) cube([x1 - x0, pw, z1 - z0]);
  intersection() {
    difference() {
      union() {
        translate([-stand_base[3], stand_base[0], 0]) cube([stand_w + stand_base[3], stand_base[1] - stand_base[0], stand_base[2]]);
        hull() { // gusset
          translate([0, -35, 0]) cube([stand_w, 75, stand_base[2]]);
          post(0, stand_w, 0, zl - stand_ledge - stand_slot_d - 10);
        }
        post(0, stand_w, 0, L);
        hull() { // 45° chamfer up to the full-width slot block, so the ledge prints without support
          post(0, stand_w, zl - stand_ledge - stand_slot_d, zl - stand_ledge);
          post(0, wf, zl - stand_ledge, zl - stand_ledge + 0.01);
        }
        post(0, wf, zl - stand_ledge, L);
      }
      rotate([-stand_tilt, 0, 0]) translate([stand_w, -slot / 2, zl]) cube([stand_slot_d + 1, slot, L]);
    }
    translate([-50, -200, 0]) cube([100, 400, 400]);
  }
}

// Left and right foot side by side (mirror pair), as printed.
module stand() {
  translate([stand_base[3], 0, 0]) stand_foot();
  translate([2 * (stand_base[3] + stand_w + stand_slot_d) + 20, 0, 0]) mirror([1, 0, 0]) stand_foot();
}

if (part == "assembly") assembly();
else if (part == "stand") stand();
else if (part == "test_corner") test_corner();
else if (part == "test_seam") test_seam();
else if (part == "test_vesa") test_vesa();
else if (part == "test_step") test_step();
else if (part == "test_fan") test_fan();
else {
  kind = substr(part);
  i = idx(part[len(part) - 2]);
  j = part[len(part) - 1] == "t" ? 1 : 0;
  if (kind == "frame") print_frame(i, j);
  else if (kind == "tray") print_tray(i, j);
  else if (kind == "shell") print_shell(i, j);
}

function substr(s) = let(p = search("_", s)[0]) chr([for (k = [0 : p - 1]) ord(s[k])]);
