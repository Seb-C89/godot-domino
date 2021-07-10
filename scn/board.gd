extends Spatial


var __rows = 5
var __cols = 9
var __board = []
var __tiles_offset = 0.1


# Called when the node enters the domino_scn tree for the first time.
func _ready():
	var domino_pack = preload("res://scn/domino.tscn")
#	var domino_scn = domino_pack.instance()
	
	#Allocation
	__board.resize(5)
	for rowID in len(__board):
		__board[rowID] = []
		__board[rowID].resize(9)
	
	#Generate all domino
	for rowID in len(__board): # for rowID, row in enumarate(board):
		for colID in len(__board[rowID]):
			__board[rowID][colID] = domino_pack.instance()
			add_child(__board[rowID][colID])
			
	#Measure One
	var mesh_size = __board[0][0].get_node("mesh_domino").get_transformed_aabb().size
	
	#Position all
	for rowID in len(__board): # for rowID, row in enumarate(board):
		for colID in len(__board[rowID]):
			__board[rowID][colID].global_translate(Vector3(colID, rowID, 0) * (mesh_size + Vector3(__tiles_offset, __tiles_offset, __tiles_offset)))
	
#	https://discord.com/channels/667748228212457482/677940032535003136/861790618799702016
#	domino_pack = preload("res://scn/domino.tscn")
#	var domino_scn = domino_pack.instance()
#	#Get size from scene_pack (BAD RESULT)
#	print("mesh size from scene pack", domino_scn.get_node("mesh_domino").get_transformed_aabb().size)
#	#Get size after adding to the scene (GOOD RESULT)
#	add_child(domino_scn)
#	print("mesh size after add", domino_scn.get_node("mesh_domino").get_transformed_aabb().size)
#	NODE MUST BA ADDED TO SCENE TREE BEFORE .get_transformed_aabb()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
