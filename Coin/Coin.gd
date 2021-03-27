extends Area2D

export var score = 100

func save():
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x,
		"pos_y" : position.y,
		"score" : score
	}
	return save_dict


func _on_Coin_body_entered(body):
	if body.name == "Player":
		Global.increase_score(score)
		queue_free()
