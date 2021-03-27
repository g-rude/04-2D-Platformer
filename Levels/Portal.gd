extends Area2D

func _ready():
	pass



func _on_Portal_body_entered(body):
	if body.name == "Player":
		if name == "Portal_to_2":
			Global.save_data["level"] = 2
			get_tree().change_scene("res://Levels/Level2.tscn")
		if name == "Portal_to_3":
			Global.save_data["level"] = 3
			get_tree().change_scene("res://Levels/Level3.tscn")
		if name == "Portal_to_4":
			Global.save_data["level"] = 4
			get_tree().change_scene("res://Levels/Game_Over.tscn")
