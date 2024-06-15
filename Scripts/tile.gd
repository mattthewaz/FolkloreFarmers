extends Node2D

var _farmType: Global.FarmType = Global.FarmType.Empty
@onready var tileSprite: AnimatedSprite2D = get_node("TileSprite")
@onready var hoverSprite: AnimatedSprite2D = get_node("HoverSprite")
var hovered = false

@export var farmType: Global.FarmType:
	get:
		return _farmType
	set(value):
		_farmType = value
		updateTileImage()

func updateTileImage():
	tileSprite.set_animation(str(_farmType))

# Called when the node enters the scene tree for the first time.
func _ready():
	tileSprite.play()
	hoverSprite.hide()
	updateTileImage()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hovered:
		if Input.is_action_just_released('RightClick'):
			print("right click" + str(_farmType))
		elif Input.is_action_just_released('LeftClick'):
			print("left click" + str(_farmType))


func _on_mouse_entered():
	hovered = true
	hoverSprite.show()
	hoverSprite.play()


func _on_mouse_exited():
	hovered = false
	hoverSprite.hide()
