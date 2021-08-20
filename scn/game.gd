extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	#Player 2
	#var rng2 = RandomNumberGenerator.new()
	#rng2.seed = rng.seed

	get_node("Board").init(4, 5, 0.1, rng)
	
#	get_node("Texte").set_text("Sebastien")
#	get_node("Texte").update_text("AbCd")
#	get_node("Texte").set_text("854263")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
