extends Node2D

@export var col: int
@export var row: int

var fertility = 1
var spirituality = 1

@onready var tileSprite: AnimatedSprite2D = get_node("TileSprite")
@onready var selectedSprite: AnimatedSprite2D = get_node("SelectedSprite")
signal tileActivated
signal tileSelected
signal tileUnselected

var _farmType: Global.FarmType = Global.FarmType.Empty
@export var farmType: Global.FarmType:
	get:
		return _farmType
	set(value):
		_farmType = value
		updateTileImage()

var _selected: bool = false
var selected: bool:
	get:
		return _selected
	set(value):
		if _selected == value:
			return
		_selected = value
		if value:
			selectedSprite.show()
			selectedSprite.play()
			emit_signal('tileSelected')
		else:
			selectedSprite.hide()
			emit_signal('tileUnselected')

func updateTileImage():
	tileSprite.set_animation(str(_farmType))

# Called when the node enters the scene tree for the first time.
func _ready():
	tileSprite.play()
	selectedSprite.hide()
	updateTileImage()

func _input(event):
	if _selected && !Global.menu_mode:
		if Input.is_action_just_pressed('Activated'):
			emit_signal('tileActivated')

func _on_mouse_entered():
	if not Global.menu_mode:
		selected = true

func _on_mouse_exited():
	if not Global.menu_mode:
		selected = false
func upkeep():
	pass
