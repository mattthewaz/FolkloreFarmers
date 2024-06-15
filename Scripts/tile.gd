extends Node2D

var _farmType: Global.FarmType = Global.FarmType.Empty
@onready var tileSprite: AnimatedSprite2D = get_node("TileSprite")
@onready var hoverSprite: AnimatedSprite2D = get_node("HoverSprite")
@onready var selectedSprite: AnimatedSprite2D = get_node("SelectedSprite")
var hovered = false
signal right_click
signal left_click

@export var farmType: Global.FarmType:
	get:
		return _farmType
	set(value):
		_farmType = value
		updateTileImage()

func set_farmtype(value):
	_farmType = value
	updateTileImage()

func updateTileImage():
	tileSprite.set_animation(str(_farmType))

# Called when the node enters the scene tree for the first time.
func _ready():
	tileSprite.play()
	hoverSprite.hide()
	selectedSprite.hide()
	updateTileImage()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hovered:
		if Input.is_action_just_released('RightClick'):
			emit_signal('right_click')
		elif Input.is_action_just_released('LeftClick'):
			emit_signal('left_click')


func _on_mouse_entered():
	hovered = true
	hoverSprite.show()
	hoverSprite.play()


func _on_mouse_exited():
	hovered = false
	hoverSprite.hide()
	
func selected(boo):
	if boo:
		selectedSprite.show()
	else:
		selectedSprite.hide()
