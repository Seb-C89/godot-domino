extends Spatial


var __status = 1 #face visible (1) / face hidden (-1)
var __face = 0 setget set_face
var __face_offset = 0.1


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func set_face(face):
	__face = face
	get_node("mesh_domino/mesh_face").get_surface_material(0).uv1_offset.x = face * __face_offset


func _on_Area_mouse_entered():
	print("entered")
	$Area.connect("input_event", self, "_on_Area_input_event")


func _on_Area_mouse_exited():
	print("exited")
	$Area.disconnect("input_event", self, "_on_Area_input_event")


func _on_Area_input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton:
		if event.doubleclick:
			print("click click")
			flip()
#	if event is InputEventMouseMotion:
#		print("move")


func flip():
	if __status == 1:
		$Tween.interpolate_property($mesh_domino, "rotation_degrees", null, Vector3(0, 0, 180), 0.25)
	elif __status == -1:
		$Tween.interpolate_property($mesh_domino, "rotation_degrees", null, Vector3(0, 0, 0), 0.25) # vers la gauche
#		$Tween.interpolate_property($mesh_domino, "rotation_degrees", Vector3(0, 0, -180), Vector3(0, 0, 0), 0.25) # vers la droite
	$Tween.start()
	__status *= -1
