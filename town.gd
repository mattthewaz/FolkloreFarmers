extends Area2D

@onready var arrow = $Arrow
@onready var collision = $Collision
var hovered = false
signal to_town

# Called when the node enters the scene tree for the first time.
func _ready():
	arrow.play("default")


func _on_mouse_entered():
	if !Global.menu_mode:
		arrow.play("hovered")
		hovered = true

func _on_mouse_exited():
	arrow.play("default")
	hovered = false

func _unhandled_input(event):
	if !Global.menu_mode:
		if hovered and Input.is_action_just_pressed('Activated') and Global.actionPoints > 0:
			emit_signal('to_town')
