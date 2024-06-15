extends Node2D

var _farmType: Global.FarmType = Global.FarmType.Empty
@export var farmType: Global.FarmType:
	get:
		return _farmType
	set(value):
		_farmType = value
		updateTileImage()

func updateTileImage():
	var tileSprite: AnimatedSprite2D = get_node("TileSprite")
	tileSprite.frame = _farmType

# Called when the node enters the scene tree for the first time.
func _ready():
	updateTileImage()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
