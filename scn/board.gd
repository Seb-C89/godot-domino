extends Spatial

var __rows = 0
var __cols = 0
var __board = []
var __tiles_offset = 0
var __alea = null
var __board_size = 0
var __domino_size = 0

var _chain


func init(rows, cols, tile_offset, alea):
	__rows = rows
	__cols = cols
	__tiles_offset = tile_offset
	__alea = alea
	generate()
	
	_chain = Chain.new(get_node("Timer"))
	_chain.connect("chain_lost", self, "on_chain_lost")
	_chain.connect("chain_valid", self, "on_chain_valid")

	get_node("Timer").set_one_shot(true)
	get_node("Timer").connect("timeout", _chain, "on_timeout")


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
			get_domino_index_from_position(domino)
			domino.flip()
			_chain.add(domino)


func on_chain_lost(chain):
	for i in chain:
		i.flip()
	pass


func on_chain_valid(chain):
	for i in chain:
		i.flip()
		i.set_face(__alea.randi_range(0, 9))
	pass


func get_domino_index_from_position(domino):
	var x = domino.get_translation().x / (__domino_size.x + __tiles_offset)
	var y = domino.get_translation().y / (__domino_size.y + __tiles_offset)
	return[round(x), round(y)]


class Chain:

	signal chain_grow(chain)
	signal chain_lost(chain)
	signal chain_valid(chain)
	signal chain_discover(chain)
	signal chain_discover_end(chain)

	var _chain = []
	var _timer

	func _init(timer):
		_timer = timer # Getting timer from board, because Timer class only work with node.

	func add(domino):
		if _chain.empty():
			on_discover(domino)
		else:
			if _chain.back().__face == domino.__face:
				on_grow(domino)
			else:
				on_broke()

	func on_grow(domino):
		_chain.append(domino)
		_timer.start(2)
		emit_signal("chain_grow", _chain)
		print("on_grow()")
		
	func on_discover(domino):
		_chain.append(domino)
		_timer.start(2)
		emit_signal("chain_discover", _chain)
		print("on_discover()")

	func on_timeout():
		print("on_timeout()")
		if _chain.size() == 1:
			on_discover_end()
		else:
			if check():
				on_valid()
			else:
				on_broke()

	func check():
		for i in _chain:
			if _chain[0].__face != i.__face:
				print("check() fail")
				return false
		print("check() pass")
		return true

	func on_broke():
		emit_signal("chain_lost", _chain)
		_chain.clear()
		_timer.stop()
		print("on_broke()")
		
	func on_discover_end():
		emit_signal("chain_discover_end", _chain) # Emit signal before clear for #Compteur receive the chain not cleared
		_chain.clear()
		_timer.stop()
		print("on_discover_end()")

	func on_valid():
		emit_signal("chain_valid", _chain) # Emit signal before clear for #Compteur receive the chain not cleared
		_chain.clear()
		_timer.stop()
		print("on_valid()")


#	https://discord.com/channels/667748228212457482/677940032535003136/861790618799702016
#	domino_pack = preload("res://scn/domino.tscn")
#	var domino_scn = domino_pack.instance()
#	#Get size from scene_pack (BAD RESULT)
#	print("mesh size from scene pack", domino_scn.get_node("mesh_domino").get_transformed_aabb().size)
#	#Get size after adding to the scene (GOOD RESULT)
#	add_child(domino_scn)
#	print("mesh size after add", domino_scn.get_node("mesh_domino").get_transformed_aabb().size)
#	NODE MUST BA ADDED TO SCENE TREE BEFORE .get_transformed_aabb()
