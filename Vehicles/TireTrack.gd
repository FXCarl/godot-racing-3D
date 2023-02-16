extends Node3D


#############################
# EXPORT PARAMS
#############################
# width
@export var width: float = 0.5
@export var width_curve: Curve
# length
@export var max_points := 100
@export var material: Material
# show or hide
@export var render: bool = true


#############################
# PARAMS
#############################
@onready var half_width = width * 0.5
var points := []

func _ready():
	$Node.set_as_top_level(true)
	$Node.set_position(Vector3.ZERO)
	$Node.set_rotation(Vector3.ZERO)

#############################
# OVERRIDE FUNCTIONS
#############################
func _process(_delta: float) -> void:
	if render:
		# add new point and render
		add_point()
		_draw_trail()
	else:
		# slowly hide the trail
		if points.size() > 0:
			var last_point = points.pop_back()
			last_point.queue_free()


#############################
# API
#############################
func add_point() -> void:
	var new_point = Marker3D.new()
	new_point.position = self.global_transform.origin
	new_point.rotation = self.global_transform.basis.get_euler()
	points.insert(0, new_point)
	if points.size() > max_points:
		var last_point = points.pop_back()
		last_point.queue_free()


func _draw_trail() -> void:
	if points.size() < 2:
		return
	# create surface tool
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)
	# draw triangles
	for i in range(points.size()):
		_point_to_rect_strip(st, points[i], i)
	# commit
#	st.generate_normals()
#	st.generate_tangents()
	$Node/Render.mesh = st.commit()
	$Node/Render.set_surface_override_material(0, material)

func _point_to_rect_strip(st: SurfaceTool, p: Marker3D, idx: float) -> void:
	var num_points = points.size() - 1
	
	var offset1 = idx / num_points
	var mod1 = half_width * width_curve.sample(offset1)
	
	var v1 = p.position + p.transform.basis.x * mod1
	var uv1 = Vector2(0, offset1)
	
	var v2 = p.position - p.transform.basis.x * mod1
	var uv2 = Vector2(1, offset1)
	
	st.set_uv(uv1)
	st.set_normal(Vector3.UP)
	st.add_vertex(v1)
	st.set_uv(uv2)
	st.set_normal(Vector3.UP)
	st.add_vertex(v2)
	
	
	
func _points_to_rect(st: SurfaceTool, p1: Marker3D, p2: Marker3D, idx: float) -> void:
	var num_points = points.size() - 1
	
	var offset1 = idx / num_points
	var mod1 = half_width * width_curve.sample(offset1)
	
	var v1 = p1.position + p1.transform.basis.x * mod1
	var uv1 = Vector2(0, offset1)
	
	var v2 = p1.position - p1.transform.basis.x * mod1
	var uv2 = Vector2(1, offset1)
	
	var offset2 = (idx + 1) / num_points
	var mod2 = half_width * width_curve.sample(offset2)
	
	var v3 = p2.position + p2.transform.basis.x * mod2
	var uv3 = Vector2(0, offset2)
	
	var v4 = p2.position - p2.transform.basis.x * mod2
	var uv4 = Vector2(1, offset2)
	
	st.set_uv(uv1)
	st.add_vertex(v1)
	st.set_uv(uv2)
	st.add_vertex(v2)
	st.set_uv(uv3)
	st.add_vertex(v3)
	
	st.set_uv(uv3)
	st.add_vertex(v3)
	st.set_uv(uv2)
	st.add_vertex(v2)
	st.set_uv(uv1)
	st.add_vertex(v1)
	
	st.set_uv(uv3)
	st.add_vertex(v3)
	st.set_uv(uv4)
	st.add_vertex(v4)
	st.set_uv(uv2)
	st.add_vertex(v2)
	
	st.set_uv(uv2)
	st.add_vertex(v2)
	st.set_uv(uv4)
	st.add_vertex(v4)
	st.set_uv(uv3)
	st.add_vertex(v3)




