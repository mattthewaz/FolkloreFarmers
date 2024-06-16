extends Node2D


@onready var tileOptions: ItemList = $TileOptions
@onready var farmTiles = $FarmTiles
var activeTile = null
var seasons = ['Spring','Summer','Fall','Winter']
var day = 1
var year = 1830

func new_day():
	day+=1
	var season = seasons[day % 4]
	$Background.play(season)
	if season == 'Spring':
		year += 1
	%DayCounter.text = season + ' ' + str(year)
	

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
	if not activeTile:
		Global.menu_mode = true
		activeTile = tile
		tile.selected(true)
		tileOptions.position = tile.position + Vector2(30,10)
		if tileOptions.position.y > 314:
			tileOptions.position.y = 314
		if tileOptions.position.x > 506:
			tileOptions.position.x = 506
		tileOptions.set_item_disabled(tile.farmType,true)
		tileOptions.show()

func _left_clicked(tile):
	print(tile.farmType)

func _on_tile_options_item_clicked(index, _at_position, mouse_button_index):
	if mouse_button_index == 1:
		tileOptions.set_item_disabled(activeTile.farmType,false)
		if index != 5:
			activeTile.farmType = index
			new_day()
		activeTile.selected(false)
		activeTile = null
		tileOptions.hide()
		Global.menu_mode = false
