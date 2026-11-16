// Case layers (frame, tray, shell) as one mesh each, split pieces in place. Used by render.sh.
include <../x1case.scad>
part = "none_x";
layer = "frame";
for (i = [0 : len(bounds) - 2], j = [0, 1]) {
  if (layer == "frame") split(i, j, frame_tabs, frame_htabs) frame_full();
  if (layer == "tray") split(i, j, tray_tabs, plate_htabs) tray_full();
  if (layer == "shell") split(i, j, shell_tabs, shell_htabs) shell_clipped();
}
