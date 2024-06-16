extends Node2D

@onready var animation = $cutscene_animation
# Called when the node enters the scene tree for the first time.
func _ready():
	animation.play('rock_1')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	animation.play("rock_2")
	$button.hide()
