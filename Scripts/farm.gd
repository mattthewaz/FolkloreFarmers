extends Node2D


@onready var tileOptions: ItemList = $TileOptions
@onready var farmTiles = $FarmTiles
var activeTile = null

var day = 1

func new_day():
	day+=1
	%DayCounter.text = "Day " + str(day)

func testTiles():
	var A1 = get_node("FarmTiles/TileA1")
	A1.farmType = Global.FarmType.Empty
	var A2 = get_node("FarmTiles/TileA2")
	A2.farmType = Global.FarmType.Wheat
	var A3 = get_node("FarmTiles/TileA3")
	A3.farmType = Global.FarmType.Shrine
	var A4 = get_node("FarmTiles/TileA4")
	A4.farmType = Global.FarmType.Vegetable
	var A5 = get_node("FarmTiles/TileA5")
	A5.farmType = Global.FarmType.Pasture

func _ready():
	#pass
	testTiles()
	tileOptions.hide()
	for tile in $FarmTiles.get_children():
		tile.right_click.connect(_right_clicked.bind(tile))
		tile.left_click.connect(_left_clicked.bind(tile))

func _right_clicked(tile):
	activeTile = tile
	tileOptions.position = tile.position + Vector2(30,30)
	tileOptions.show()

func _left_clicked(tile):
	print("lc")


func _on_tile_options_item_clicked(index, at_position, mouse_button_index):
	if index == 5:
		activeTile = null
		tileOptions.hide()
	else:
		activeTile.set_farmtype(index)
		activeTile = null
		tileOptions.hide()
		new_day()
