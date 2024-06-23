extends Node2D

signal new_generation_pressed

func set_score(score):
	$Energy.text = str(score)

func _on_main_menu_pressed():
	get_tree().change_scene_to_file('res://title.tscn')


func _on_new_generation_pressed():
	emit_signal('new_generation_pressed')
