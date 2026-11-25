# One-piece VESA stand (stand_shoe v3)

## Intent
The two loose v2 shoes work, but they are separate parts taped to the desk. Join them into one rigid part with a VESA 100 plate at the back, so the lid + board assembly can be bolted to a VESA arm or mount and still stands on the desk by itself.

## Goals
- One printed part: both shoes, a shared base, and a VESA 100 plate behind the board slot.
- Holds the assembly with a safety factor of 4 or more on the printed material (PETG-HF).
- Lid and board slots keep the v2 geometry (12° lean, 21 mm channel, 50 mm board walls, 80 mm inner gap, 140 mm outer width). The slots are proven on the printed pair.

## Non-goals
- No change to `x1case.scad` or the case VESA pad.
- No adjustable tilt. The arm handles that.

## Anti-goals
- Not a part that only works taped down: it must stand on its own and take the arm's leverage without peeling off the desk.
- No plate that flexes when the arm loads it.

## Constraints (my calls, marked)
- Load (my call): assembly weight assumed about 1.5 kg (lid, board, heatsink, fans). Design load is 5 kg static at the plate, centre of mass about 100 mm in front of the plate. That gives a moment of about 5 N·m.
- Printing (my call): print standing on the base (not lying on the profile like v2), so layers run horizontally and the plate, ribs and bridge are loaded along layers, not across them. Leaning walls stay under 45°, so no supports are needed except under the bridge.
- VESA plate: 100 × 100 mm M4 pattern, heat-set inserts (same 5.7 mm hole and 8.5 mm depth as the case), pressed in from the back face. The plate is 10 mm thick (8.5 mm inserts need more than the 8 mm I first wrote). It leans 12° like the board and stands 52 mm behind the board's lean line, which leaves 7.2 mm of clearance to the 10 mm heatsink. The back face is flat and clear, so an arm's VESA plate sits flat on it.
- Hole columns sit at ±50 mm from the centre, which is above the shoes (they cover ±40 to ±70), so the bolts land where the web backs the plate.
- Bed fit: the print must fit on the printer bed. The existing v2 bbox is 210 x 60 x 30 mm, so I will check the new footprint against the bed in the model.

## Approaches
- A. One-piece stand (chosen): shoes, bridge and plate in one part. Rigid, printed once.
- B. Separate bracket on the existing shoes: reuses prints but needs flat bolt pads and the joint is the weak point. Rejected.
- C. Strap or rail: not rigid. Rejected.

## Design (summary)
- Keep the v2 shoe profile for the lid and board slots.
- Replace each shoe's rear buttress with a solid web that fills the space between the board's rear wall and the VESA plate. The web goes up to the rear wall top. Nothing sits behind the plate, so the back face stays clear for the arm.
- The plate is one 140 mm wide slab down to the desk. It joins the two shoes, so no separate crossbar is needed.
- Check strength by hand (bending at the plate-to-gusset joint and insert pull-out), and optionally by changing parameters in SolidCraft to see the volume and stiffness.

## Left to the builder
Exact plate height and gusset layout, rib count, fillet radii, infill and wall-count advice for the README.
