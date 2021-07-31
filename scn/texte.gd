extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var size

# Called when the node enters the scene tree for the first time.
func _ready():
	size = get_node("Sprite3D").get_region_rect().size.x / get_node("Sprite3D").get_hframes() * 0.01
	print("size", get_node("Sprite3D").get_transformed_aabb().size)
	print("size", get_node("Sprite3D").get_aabb().size)
	pass # Replace with function body.


func set_text(text):
	erase() # TODO recycle child instead of delete them
	var string = text.to_ascii()
	for i in len(string):
		var node = get_node("Sprite3D").duplicate()
		add_child(node)
		node.set_visible(true)
		node.translate(Vector3(size*i, 0, 0))
		node.set_frame(string[i]-32)


func update_text(text):
	var string = text.to_ascii()
	for i in len(string):
		get_child(i+1).set_frame(string[i]-32)
	pass


func erase():
	var childs = get_children()
	childs.pop_front() # Do not delete the first child which is the original Srpite3D
	for node in childs:
		remove_child(node)
		node.queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
