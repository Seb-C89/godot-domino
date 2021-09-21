extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func connect_to_board(board:Node): # in future use player to connect the board
	board.connect("chain_grow", self, "chain_grow")
	board.connect("chain_lost", self, "chain_lost")
	board.connect("chain_valid", self, "chain_valid")
	get_node("Texte").set_text(score)
	print("compteur connected")
	

func chain_grow(chain):
	score += 1
	print("score", score)
	get_node("Texte").set_text(score)


func chain_lost(chain):
	score -= 5*chain.size()
	print("score", score)
	get_node("Texte").set_text(score)


func chain_valid(chain):
	score += chain.size() * chain.size()
	print("score", score)
	get_node("Texte").set_text(score)
