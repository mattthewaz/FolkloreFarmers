extends Node2D

var _farmType: Global.FarmType = Global.FarmType.Empty
@export var farmType: Global.FarmType:
	get:
		return _farmType
	set(value):
		_farmType = value
		updateTileImage()


func updateTileImage():
	var rect: ColorRect = get_node("ColorRect")
	if _farmType == Global.FarmType.Empty:
		rect.color = Color(0.5, 0.25, 0, 1.0)
	if _farmType == Global.FarmType.Wheat:
		rect.color = Color(1.0, 1.0, 0, 1.0)
	if _farmType == Global.FarmType.Shrine:
		rect.color = Color(1.0, 1.0, 1.0, 1.0)
	if _farmType == Global.FarmType.Vegetable:
		rect.color = Color(1.0, 0.5, 0, 1.0)
	if _farmType == Global.FarmType.Pasture:
		rect.color = Color(0, 1.0, 0, 1.0)

# Called when the node enters the scene tree for the first time.
func _ready():
	updateTileImage()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
