extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var r = []
	r.resize(50)
	for i in len(r):
		r[i] = randi()%10
	print(r)
	get_node("Board").init(4, 5, 0.1, r)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
