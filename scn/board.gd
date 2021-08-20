extends Spatial


signal chain_grow(chain)
signal chain_lost(chain)


var __rows = 0
var __cols = 0
var __board = []
var __tiles_offset = 0
var __alea = null
var __board_size = 0
var __domino_size = 0

var chain = []


func init(rows, cols, tile_offset, alea):
	__rows = rows
	__cols = cols
	__tiles_offset = tile_offset
	__alea = alea
	generate()


# Called when the node enters the domino_scn tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func generate():
	var domino_pack = preload("res://scn/domino.tscn")
#	var domino_scn = domino_pack.instance()
	
	#Allocation
	__board.resize(__rows)
	for rowID in len(__board):
		__board[rowID] = []
		__board[rowID].resize(__cols)
	
	#Generate all domino
	for rowID in len(__board): # for rowID, row in enumarate(board):
		for colID in len(__board[rowID]):
			__board[rowID][colID] = domino_pack.instance()
			add_child(__board[rowID][colID])
			
	#Measure One (Measure must be done after the instance is added to scene. see comment below)
	__domino_size = __board[0][0].get_node("mesh_domino").get_transformed_aabb().size
	
	#For each domino
	for rowID in len(__board): # for rowID, row in enumarate(board):
		for colID in len(__board[rowID]):
			#Position
			__board[rowID][colID].global_translate(Vector3(colID, rowID, 0) * (__domino_size + Vector3(__tiles_offset, __tiles_offset, __tiles_offset)))
			#Duplique material (else all instance share same params like uv_coord, color, ...)
			__board[rowID][colID].get_node("mesh_domino/mesh_face").set_surface_material(0, __board[0][0].get_node("mesh_domino/mesh_face").get_surface_material(0).duplicate())
			#Set_face()
			__board[rowID][colID].set_face(__alea.randi_range(0, 9))
			#Connect input event
#			__board[rowID][colID].get_node("Area").connect("input_event", self, "on_Domino_input_event", [rowID, colID])
			__board[rowID][colID].get_node("Area").connect("input_event", self, "on_Domino_input_event", [__board[rowID][colID]])
	
	__board_size = __board[__rows-1][__cols-1].get_node("mesh_domino").get_transformed_aabb().end - __board[0][0].get_node("mesh_domino").get_transformed_aabb().position
	print("board", __board_size)
	print("mesh", __domino_size)
	print("cols", __cols, "rows", __rows)


#func on_Domino_input_event(camera, event, click_position, click_normal, shape_idx, rowID, colID):
func on_Domino_input_event(camera, event, click_position, click_normal, shape_idx, domino):
	if event is InputEventMouseButton:
		if event.doubleclick:
#			print("face", __board[rowID][colID].__face)
			get_domino_index_from_position(domino)
#			__board[rowID][colID].flip()
#			chain_add(rowID, colID)


func chain_add(rowID, colID):
	if chain.size() > 0:
		print(chain.front().__face, __board[rowID][colID].__face)
		if chain.front().__face == __board[rowID][colID].__face:
			chain.append(__board[rowID][colID])
			emit_signal("chain_grow", chain)
			print("chain x", chain.size())
		else:
			chain.clear()
			emit_signal("chain_lost", chain)
#			chain.append(__board[rowID][colID]) # When the chain is lost the last domino is hided ? Or it start a new chain ?
#			emit_signal("chain_grow", chain)
			print("chain lost")
	else:
		print("first")
		chain.append(__board[rowID][colID])
		emit_signal("chain_grow", chain)


func chain_timeout():
	chain.clear()
	emit_signal("chain_lost", chain)
	print("chain timeout")


func get_domino_index_from_position(domino):
	var x = domino.get_translation().x / (__domino_size.x + __tiles_offset)
	var y = domino.get_translation().y / (__domino_size.y + __tiles_offset)
	return[round(x), round(y)]


#	TODO chain as class ?


#	https://discord.com/channels/667748228212457482/677940032535003136/861790618799702016
#	domino_pack = preload("res://scn/domino.tscn")
#	var domino_scn = domino_pack.instance()
#	#Get size from scene_pack (BAD RESULT)
#	print("mesh size from scene pack", domino_scn.get_node("mesh_domino").get_transformed_aabb().size)
#	#Get size after adding to the scene (GOOD RESULT)
#	add_child(domino_scn)
#	print("mesh size after add", domino_scn.get_node("mesh_domino").get_transformed_aabb().size)
#	NODE MUST BA ADDED TO SCENE TREE BEFORE .get_transformed_aabb()
