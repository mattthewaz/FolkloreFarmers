extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$music.play()


func _on_volume_change(percent):
	Global.volume_percent = percent
	#$music.set_volume_db(Global.volume_db)


func _on_start_pressed():
	get_tree().change_scene_to_file('res://Scenes/farm.tscn')


func _on_credits_pressed():
	$Credits.show()
	$bear.hide()


func _on_exit_pressed():
	$Credits.hide()
	$bear.show()


func _on_music_finished():
	$music.play()
