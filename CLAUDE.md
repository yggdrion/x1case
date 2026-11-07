# CLAUDE.md

Parametric OpenSCAD case for a Lenovo ThinkPad X1 Extreme Gen 1. See `README.md` for the design, and `x1case.scad` for the parameters.

## Git workflow

- After each finished task, commit and push to `origin` without asking first.
- Every commit is a semantic commit (`type(scope): summary`), following the `semantic-git` skill. One logical change per commit, so a task that touches unrelated areas becomes several commits.
- Re-render the affected STLs (`stl/`) and preview images (`images/`) before committing a change to `x1case.scad`, so they stay in sync with the source.

## Render

```bash
openscad -o stl/shell_m.stl -D 'part="shell_m"' x1case.scad
```

A render must finish with no `WARNING` lines. The file's own echo checks (bed fit, seam vs fan/VESA, fan vs heatsink) print as `WARNING` too.
