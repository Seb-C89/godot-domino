extends Spatial


var char_size


func _ready():
	char_size = get_node("Sprite3D").get_region_rect().size.x / get_node("Sprite3D").get_hframes() * 0.01
	print("size", get_node("Sprite3D").get_transformed_aabb().size)
	print("size", get_node("Sprite3D").get_aabb().size)


func set_text(text):
	var string = String(text).to_ascii()
	var diff = string.size() - (get_child_count()-1)
	var update = min(string.size(), (get_child_count()-1))

	#Update existing chars
	for i in update:
		print("update char")
		get_child(i+1).set_frame(string[i]-32)
		get_child(i+1).set_visible(true)
	
	if diff > 0:
		#Add chars
		for i in range(update, string.size()):
			print("add char")
			var node = get_node("Sprite3D").duplicate()
			node.set_frame(string[i]-32)
			node.translate(Vector3(char_size*i, 0, 0))
			node.set_visible(true)
			add_child(node)
	else:
		#Delete / Hide
		for i in range (update+1, get_child_count()):
			print("hide char")
			get_child(i).set_visible(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
