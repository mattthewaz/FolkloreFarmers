extends Node2D

@export var col: int
@export var row: int

var fertility = 1

@onready var popup = $ResourcePopup
@onready var tileSprite: AnimatedSprite2D = get_node("TileSprite")
@onready var selectedSprite: AnimatedSprite2D = get_node("SelectedSprite")
@onready var tempFertilityDisplay = $TempFertilityDisplay
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
	if Global.rubble_count > 0:
		var rubble_check = randi_range(1,Global.tiles_ungenned)
		if rubble_check <= 2:
			farmType = Global.FarmType.Rubble
			Global.rubble_count -= 1
			fertility = 2
		Global.tiles_ungenned -= 1
	tileSprite.play()
	selectedSprite.hide()
	updateTileImage()
	

func _unhandled_input(event):
	if _selected && !Global.menu_mode:
		if Input.is_action_just_pressed('Activated'):
			emit_signal('tileActivated')

func _on_mouse_entered():
	if not Global.menu_mode:
		selected = true

func _on_mouse_exited():
	if not Global.menu_mode:
		selected = false
		
func upkeep(adjacent_shrines):
	var daily = Global.daily_update(farmType)
	Global.gold += fertility * daily[0]
	if farmType != Global.FarmType.Vegetable:
		Global.vegetables += daily[1]
	else:
		Global.vegetables += daily[1] + fertility
		await popup.play(daily[1] + fertility,'vegetable')
	if farmType == Global.FarmType.Pasture and adjacent_shrines > 0:
		Global.energy += (2 ** adjacent_shrines * daily[2])
		await popup.play(daily[1],'vegetable',(2 ** adjacent_shrines * daily[2]),'energy')
	else:
		Global.energy += daily[2]
	if farmType == Global.FarmType.Wheat:
		await popup.play(fertility * daily[0],'gold')
	elif farmType == Global.FarmType.Shrine:
		await popup.play(fertility * daily[0],'gold')
	elif farmType == Global.FarmType.Pasture and adjacent_shrines == 0:
		await popup.play(daily[1],'vegetable',daily[2],'energy')
