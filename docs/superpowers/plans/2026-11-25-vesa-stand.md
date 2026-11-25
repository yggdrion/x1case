# One-piece VESA stand Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** One printed part: v2's two shoes joined by a leaning VESA 100 plate that an arm can bolt to.

**Architecture:** v2's profile is an XY polyline extruded along Z. v3 keeps the lid and board slots exactly, replaces the rear buttress with a web up to the plate, and adds the plate as a second profile extruded the full 140 mm. The gap between the shoes is cut from the shoe extrusion before the plate is added.

**Tech Stack:** SolidCraft (MCP tools `batch`, `measure`, `export`), PETG-HF, Bambu P2S bed 256 mm.

**Spec:** `docs/superpowers/specs/2026-11-25-vesa-stand-design.md`

## Global Constraints

- Lean 12°, slot 7.6 mm, channel 21 mm, board slot 8.6 mm, walls 4 mm: unchanged from v2 (`interim_stand_shoe/solidcraft_v2.json`).
- Shoes 30 mm wide, 80 mm inner gap, 140 mm outer.
- Plate 10 mm thick, front face 52 mm behind the board's lean origin line, back face 62 mm. Heatsink clearance 7.2 mm.
- VESA 100: four M4 heat-set holes, d 5.7, depth 8.5, from the back face, at ±50 mm across and ±50 mm along the lean from the pattern centre (v = 90).
- Printed standing on its base. No supports.
- Commit messages `type(scope): summary`, no attribution lines. Re-export STL and re-render `profile_*.png` and update `interim_stand_shoe/README.md` in the same commit.

## Review Focus

- Insert holes: at least 3 mm of material around each hole, none breaking through the 10 mm plate.
- Back face: nothing proud of it, so an arm's plate sits flat (the base strip behind the plate stays at 3 mm).
- Heatsink: the 7.2 mm clearance holds for the board at its lean.
- Slots: lid and board slot coordinates match v2 exactly.
- Bed: footprint within 256 mm after the 3 mm keep-out.

## Geometry (lean frame u across, v up the lean; world x = 0.97815u + 0.20791v, y = -0.20791u + 0.97815v)

Shoe profile v3 is the v2 polyline with `[101.9678,3],[58.459,56.666]` replaced by `[64.03,3],[74.71,53.23],[58.459,56.666]`. All other points as v2.

Plate profile (closed polyline, extruded 140): `[53.16,0],[63.39,0],[91.84,133.83],[82.05,135.91]`.

## Task 1: Model in SolidCraft

**Files:**
- Create: `interim_stand_shoe/solidcraft_v3.json`, `interim_stand_shoe/stand_shoe_v3.stl`

**Interfaces:**
- Produces: body `StandVesa`, bbox x −25…185.57, y 0…135.91, z 0…140.

- [ ] **Step 1:** In one `batch`: sketch `ShoeProfile` (XY), the shoe polyline above, `solid.extrude` 140 named `Shoe`. Expected after the stage: bbox x −25…185.57, y 0…61, z 0…140.
- [ ] **Step 2:** Cut a box x −30…190, y −1…100, z 30…110 (name `Gap`), leaving two 30 mm shoes.
- [ ] **Step 3:** Sketch `PlateProfile`, the plate polyline above, `solid.extrude` 140 joined to `Shoe`. Expected: one body, bbox y max 135.91.
- [ ] **Step 4:** Four holes d 5.7, depth 8.5 into the back face at world positions computed from (u 62, v 90 ± 50 along the lean, z 70 ± 50). `measure` to confirm each removes π·2.85²·8.5 = 216.8 mm³ (total 867 mm³).
- [ ] **Step 5:** `batch` with `path` from `interim_stand_shoe/solidcraft_v3.json`; `export` the STL; `save`.

## Task 2: Verify strength and fit

- [ ] **Step 1:** `measure` against the numbers above; `body_topology faces: "cylinders"` shows four cylinders of radius 2.85 with the right axes and positions.
- [ ] **Step 2:** Hand check, written into the README: design load 5 kg at the plate, moment about 5 N·m, per shoe 2.5 N·m at the 10 × 30 mm plate section above the web gives about 8 MPa without the web and under 4 MPa with it. Require a safety factor of at least 4 on 20 MPa interlayer strength.
- [ ] **Step 3:** Confirm the bbox fits the bed (210.6 × 140 footprint) and re-render `profile_v3.png` and an iso preview.

## Task 3: Document and commit

**Files:**
- Modify: `interim_stand_shoe/README.md`

- [ ] **Step 1:** Add a v2 → v3 section (plate numbers, load assumption, print orientation, PETG-HF advice: 5 walls, 40% gyroid, 0.2 mm layers) and the new file rows.
- [ ] **Step 2:** `git add` the spec, plan, README, v3 files and previews; commit `feat(stand_shoe): v3 one-piece stand with a VESA 100 plate`, then `git push`.
