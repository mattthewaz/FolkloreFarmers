extends Node2D

@onready var tileOptions: ItemList = $TileOptions
@onready var shrineRepair: ItemList = $ShrineRepair
@onready var farmTiles = $FarmTiles
var gold = 30
var selectedTile = null
var seasons = ['Spring','Summer','Fall','Winter']
var season = 'Summer'
var day = 0
var year = 1824

var tileMap: Dictionary
func _initializeTileMap():
	for tile in $FarmTiles.get_children():
		tileMap[Vector2(tile.col,tile.row)] = tile

func new_day():
	day+=1
	season = seasons[day % 4]
	$Background.play(season)
	if season == 'Spring':
		year += 1
	%DayCounter.text = season + ', ' + str(year)

func skip_time(days):
	Global.menu_mode = true
	for d in range(days):
		day+=1
		season = seasons[day % 4]
		$Background.play(season)
		if season == 'Spring':
			year += 1
		%DayCounter.text = season + ', ' + str(year)
		await get_tree().create_timer(1.0).timeout
	Global.menu_mode = false

func _ready():
	new_day()
	_initializeTileMap()
	tileMap[Vector2(5,3)].farmType = Global.FarmType.BrokenShrine
	tileOptions.hide()
	shrineRepair.hide()
	for tile in $FarmTiles.get_children():
		tile.tileActivated.connect(_tile_activated.bind(tile))
		tile.tileSelected.connect(_tile_selected.bind(tile))
		tile.tileUnselected.connect(_tile_unselected.bind(tile))

func _tile_activated(tile):
	Global.menu_mode = true
	if tile.farmType != Global.FarmType.BrokenShrine:
		tileOptions.position = tile.position + Vector2(30,10)
		if tileOptions.position.y > 314:
			tileOptions.position.y = 314
		if tileOptions.position.x > 506:
			tileOptions.position.x = 506
		tileOptions.set_item_disabled(tile.farmType,true)
		tileOptions.show()
	else:
		shrineRepair.position = tile.position + Vector2(30,10)
		if shrineRepair.position.x > 506:
			shrineRepair.position.x = 506
		shrineRepair.show()

func _tile_selected(tile): 
	if selectedTile != tile:
		if selectedTile != null: 
			selectedTile.selected = false
		tile.selected = true
		selectedTile = tile

func _tile_unselected(tile):
	if selectedTile == tile:
		selectedTile = null

func _on_tile_options_item_clicked(index, _at_position, mouse_button_index):
	if mouse_button_index == 1:
		tileOptions.hide()
		tileOptions.set_item_disabled(selectedTile.farmType,false)
		if index != 5:
			selectedTile.farmType = index
			new_day()
		selectedTile.selected = false
		selectedTile = null
		Global.menu_mode = false

func _on_shrine_repair_item_clicked(index, at_position, mouse_button_index):
	if mouse_button_index == 1:
		shrineRepair.hide()
		if index == 0:
			new_day()
			selectedTile.farmType = Global.FarmType.Shrine
		selectedTile.selected = false
		selectedTile = null
		Global.menu_mode = false
