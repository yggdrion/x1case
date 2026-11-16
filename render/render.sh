#!/usr/bin/env bash
# Photo renders with Blender: exports the case layers and stand-in parts (lid, board, cooler, fans)
# from OpenSCAD, then renders images/render_front.png, render_exploded.png and render_inside.png.
# Usage (from the repo root): bash render/render.sh
set -e
cd "$(dirname "$0")"
OS="${OPENSCAD:-/c/Program Files/OpenSCAD/openscad.exe}"
BL="${BLENDER:-/c/Program Files/Blender Foundation/Blender 5.3/blender.exe}"
mkdir -p out
for l in frame tray shell; do "$OS" -o out/$l.stl -D "layer=\"$l\"" layer.scad 2>&1 | grep -E 'WARN|ERR' || true & done
for w in lid screen board blowers fins pipe chips fans blades esp bucks usbc parts tape kapton standoffs screws inserts cables; do "$OS" -o out/$w.stl -D "which=\"$w\"" extras.scad 2>&1 | grep -E 'WARN|ERR' || true & done
wait
"$BL" -b --factory-startup -P scene.py -- front "$PWD/../images/render_front.png" | grep -E 'Saved|Error'
"$BL" -b --factory-startup -P scene.py -- back "$PWD/../images/render_exploded.png" | grep -E 'Saved|Error'
"$BL" -b --factory-startup -P scene.py -- inside "$PWD/../images/render_inside.png" | grep -E 'Saved|Error'
