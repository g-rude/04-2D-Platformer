extends Node

var save_data = {
	"level":1,
	"score":0,
}

var score = 0
var lives = 5
var max_lives = 5
var health = 100
var max_health = 100
var level = 1

var save_file = "user://save.dat"
var key = "C220 is the best!"

var levels = [
	"res://Levels/Level1.tscn"
	,"res://Levels/Level2.tscn"
	,"res://Levels/Level3.tscn"
]

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS

func _unhandled_input(_event):
	if Input.is_action_just_pressed("quit"):
		var menu = get_node_or_null("/root/Game/UI/Menu")
		if menu != null:
			if not menu.visible:
				menu.show()
				get_tree().paused = true
			else:
				menu.hide()
				get_tree().paused = false

func increase_score(s):
	score += s

func decrease_health(h):
	health -= h
	
func decrease_lives(l):
	lives -= 1
	health = max_health
	if lives <= 0:
		get_tree().change_scene("res://Levels/Game_Over.tscn")

func save_game():
	var save_game = File.new()
	save_game.open_encrypted_with_pass(save_file, File.WRITE, key)
	
	var save_nodes = get_tree().get_nodes_in_group("persist")
	for node in save_nodes:
		if node.filename.empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue
		var node_data = node.call("save")
		save_game.store_line(to_json(node_data))
	save_game.close()
	
func load_game():
	var save_game = File.new()
	if not save_game.file_exists(save_file):
		return
	
	
	save_game.open_encrypted_with_pass(save_file, File.READ, key)
	var save_nodes = get_tree().get_nodes_in_group("persist")
	for node in save_nodes:
		node.queue_free()
	while save_game.get_position() < save_game.get_len():
		var node_data = parse_json(save_game.get_line()) 
		
		var new_object = load(node_data["filename"]).instance()
		get_node(node_data["parent"]).add_child(new_object)
		new_object.position = Vector2(node_data["pos_x"], node_data["pos_y"])
		
		for i in node_data.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
				continue
			new_object.set(i, node_data[i])
			
	save_game.close()
	
	
	
	
	
	
