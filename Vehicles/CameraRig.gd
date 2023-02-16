extends Marker3D

@onready var parent = get_parent()

func _ready():
	set_as_top_level(true)
	
func _physics_process(_delta):
	global_transform.origin = parent.global_transform.origin
	var current_angle = global_transform.basis.get_euler()
	var parent_angle = parent.global_transform.basis.get_euler()
	parent_angle.x = 0
	parent_angle.z = 0
	parent_angle.y = lerp_angle(current_angle.y, parent_angle.y, _delta * 10)
	# var angle = current_angle.lerp(parent_angle, _delta * 10)
	# var parent_basis = parent.global_transform.basis
	# var angle = parent.get_transform().basis.z.angle_to(Vector3(0,0,1)) #Vector2(parent_basis.x, parent_basis.x).angle()
	set_rotation(parent_angle)
