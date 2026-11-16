import bpy, sys, math, os
from mathutils import Vector

argv = sys.argv[sys.argv.index("--") + 1:]
view, out = argv[0], argv[1]
D = os.path.join(os.path.dirname(os.path.abspath(__file__)), "out")  # meshes from render.sh

bpy.ops.wm.read_factory_settings(use_empty=True)
sc = bpy.context.scene

# root: scad mm (X right, Y up, Z back) -> blender metres, Z up
root = bpy.data.objects.new("root", None)
sc.collection.objects.link(root)
root.scale = (0.001,) * 3
root.rotation_euler = (math.radians(90), 0, 0)

def mat(name, rgb, rough=0.5, metal=0.0, emit=None, alpha=1.0):
    m = bpy.data.materials.new(name)
    m.use_nodes = True
    b = m.node_tree.nodes["Principled BSDF"]
    b.inputs["Base Color"].default_value = (*rgb, 1)
    b.inputs["Roughness"].default_value = rough
    b.inputs["Metallic"].default_value = metal
    if emit:
        b.inputs["Emission Color"].default_value = (*emit, 1)
        b.inputs["Emission Strength"].default_value = 1.2
    if alpha < 1:
        b.inputs["Alpha"].default_value = alpha
    return m

M = {
    "case": mat("case", (0.08, 0.09, 0.1), 0.6),
    "frame": mat("frame", (0.08, 0.09, 0.1), 0.6),
    "tray": mat("tray", (0.55, 0.57, 0.6), 0.6),
    "lid": mat("lid", (0.02, 0.02, 0.02), 0.2),
    "screen": mat("screen", (0.0, 0.0, 0.0), 0.1, emit=(0.15, 0.35, 0.8)),
    "board": mat("board", (0.02, 0.18, 0.06), 0.4),
    "dark": mat("dark", (0.03, 0.03, 0.03), 0.4),
    "alu": mat("alu", (0.75, 0.75, 0.78), 0.3, 0.9),
    "copper": mat("copper", (0.8, 0.4, 0.2), 0.3, 1.0),
    "fan": mat("fan", (0.05, 0.05, 0.05), 0.5),
    "esp": mat("esp", (0.05, 0.12, 0.45), 0.4),
    "buck": mat("buck", (0.03, 0.25, 0.12), 0.4),
    "steel": mat("steel", (0.7, 0.7, 0.72), 0.25, 1.0),
    "brick": mat("brick", (0.02, 0.02, 0.02), 0.55),
}

# name: (material, explode offset along scad +Z in mm)
ex = view == "back"
ee = 130 if ex else 0  # electronics explode offset, mm
parts = {
    "frame": ("frame", 0), "lid": ("lid", 0), "screen": ("screen", 0),
    "tray": ("tray", 40 if ex else 0),
    "board": ("board", 90 if ex else 0), "chips": ("dark", 90 if ex else 0),
    "blowers": ("dark", 90 if ex else 0), "fins": ("alu", 90 if ex else 0), "pipe": ("copper", 90 if ex else 0),
    "fans": ("fan", 150 if ex else 0), "blades": ("fan", 150 if ex else 0),
    "shell": ("case", 210 if ex else 0),
    # electronics bay + DC jack sit in the shell; exploded on their own layer so the shell doesn't hide them
    "esp": ("esp", ee), "bucks": ("buck", ee), "usbc": ("steel", ee), "parts": ("dark", ee),
}
for n, (m, dz) in parts.items():
    bpy.ops.wm.stl_import(filepath=os.path.join(D, n + ".stl"))
    o = bpy.context.selected_objects[0]
    o.parent = root
    o.location = (0, 0, dz)
    o.data.materials.clear()
    o.data.materials.append(M[m])
    if n in ("shell", "frame", "tray"):
        bpy.context.view_layer.objects.active = o
        bpy.ops.object.shade_auto_smooth(angle=math.radians(30))

bpy.context.view_layer.update()
# case centre in world coords
cx, cy, cz = 0.185, -0.03 - (0.1 if ex else 0), 0.06  # low enough to frame the brick on the floor

# floor below the case (it hangs on its VESA mount), so the plug and the brick fit underneath
fz = -0.16
bpy.ops.mesh.primitive_plane_add(size=10, location=(cx, cy, fz))
bpy.context.object.data.materials.append(mat("floor", (0.8, 0.8, 0.82), 0.9))

# power brick on the floor (PLACEHOLDER ~156 x 75 x 25 mm, Lenovo 135 W slim tip) + cable to the DC plug
by = -0.05 - ee / 1000
bpy.ops.mesh.primitive_cube_add(size=1, location=(0.17, by, fz + 0.0125))
b = bpy.context.object
b.scale = (0.156, 0.075, 0.025)
b.data.materials.append(M["brick"])
bv = b.modifiers.new("bevel", "BEVEL")
bv.width, bv.segments = 0.004, 4
cu = bpy.data.curves.new("cable", "CURVE")
cu.dimensions, cu.bevel_depth = "3D", 0.0018
sp = cu.splines.new("BEZIER")
sp.bezier_points.add(2)
plug_y = -0.022 - ee / 1000  # plug end, world coords (dc_x = 37.8 mm)
for p, co in zip(sp.bezier_points, [(0.0378, plug_y, -0.014), (0.06, plug_y + 0.022, -0.13), (0.092, by, fz + 0.0125)]):
    p.co = co
    p.handle_left_type = p.handle_right_type = "AUTO"
cable = bpy.data.objects.new("cable", cu)
sc.collection.objects.link(cable)
cable.data.materials.append(mat("cable", (0.015, 0.015, 0.015), 0.5))

tgt = bpy.data.objects.new("tgt", None)
tgt.location = (cx, cy, cz)
sc.collection.objects.link(tgt)
cam = bpy.data.objects.new("cam", bpy.data.cameras.new("cam"))
sc.collection.objects.link(cam)
cam.data.lens = 62
if view == "front":
    cam.location = (cx - 0.35, cy + 1.05, cz + 0.25)
else:
    cam.location = (cx + 1.1, cy - 0.6, cz + 0.3)
c = cam.constraints.new("TRACK_TO")
c.target = tgt
c.track_axis = "TRACK_NEGATIVE_Z"
c.up_axis = "UP_Y"
sc.camera = cam

def light(kind, loc, energy, size=1.0):
    l = bpy.data.objects.new(kind, bpy.data.lights.new(kind, kind))
    l.data.energy = energy
    if kind == "AREA":
        l.data.size = size
    l.location = loc
    t = l.constraints.new("TRACK_TO")
    t.target = tgt
    t.track_axis = "TRACK_NEGATIVE_Z"
    t.up_axis = "UP_Y"
    sc.collection.objects.link(l)

sy = 1 if view == "front" else -1
light("AREA", (cx - 0.8, cy + sy * 0.8, cz + 1.0), 40, 1.5)
light("AREA", (cx + 0.9, cy + sy * 0.4, cz + 0.5), 50, 1.0)
light("AREA", (cx, cy - sy * 0.9, cz + 0.8), 40, 1.5)

w = bpy.data.worlds.new("w")
w.use_nodes = True
w.node_tree.nodes["Background"].inputs[0].default_value = (0.9, 0.9, 0.92, 1)
w.node_tree.nodes["Background"].inputs[1].default_value = 0.12
sc.world = w

sc.render.engine = "CYCLES"
sc.cycles.samples = 96
sc.cycles.use_denoising = True
try:
    prefs = bpy.context.preferences.addons["cycles"].preferences
    for t in ("OPTIX", "CUDA", "HIP", "ONEAPI"):
        try:
            prefs.compute_device_type = t
            prefs.get_devices()
            if any(d.type == t for d in prefs.devices):
                for d in prefs.devices:
                    d.use = True
                sc.cycles.device = "GPU"
                break
        except Exception:
            pass
except Exception:
    pass
sc.view_settings.view_transform = "AgX"
sc.view_settings.look = "AgX - Medium High Contrast"
sc.render.resolution_x, sc.render.resolution_y = 1600, 1100
sc.render.filepath = out
bpy.ops.render.render(write_still=True)
