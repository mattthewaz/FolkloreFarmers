extends Node2D

var times_clicked = 0
@onready var animation = $cutscene_animation
# Called when the node enters the scene tree for the first time.
func _ready():
	animation.play('rock_1')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	times_clicked += 1
	if times_clicked == 1:
		animation.play("rock_2")
	else:
		queue_free()
