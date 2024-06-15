extends Node2D

enum FarmType { Empty, Wheat, Shrine }

var _farmType: FarmType = FarmType.Empty
@export var farmType: FarmType:
	get:
		return _farmType
	set(value):
		_farmType = value
		updateTileImage()


func updateTileImage():
	var rect: ColorRect = get_node("ColorRect")
	if _farmType == FarmType.Empty:
		rect.color = Color(0.5, 0.25, 0, 1.0)
	if _farmType == FarmType.Wheat:
		rect.color = Color(1.0, 1.0, 0, 1.0)
	if _farmType == FarmType.Shrine:
		rect.color = Color(1.0, 1.0, 1.0, 1.0)

# Called when the node enters the scene tree for the first time.
func _ready():
	updateTileImage()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
