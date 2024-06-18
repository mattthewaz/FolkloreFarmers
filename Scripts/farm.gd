extends Node2D

@onready var tileMenu: PopupMenu = $TileMenu
@onready var farmTiles = $FarmTiles
var gold = 30
var selectedTile = null
var seasons = ['Spring','Summer','Fall','Winter']
var season = 'Summer'
var day = 0
var endDay = 60 #should get replaced
var year = 1824
var starting_year = 1824
var generation = 0

var tileMap: Dictionary
func _initializeTileMap():
	for tile in $FarmTiles.get_children():
		tileMap[Vector2(tile.col,tile.row)] = tile

#starts a new day - triggered by NewDayButton
func new_day():
	day+=1
	#print(day)
	season = seasons[day % 4]
	if season == 'Spring':
		year += 1
	for t in farmTiles.get_children():
		t.upkeep(adjacent_shrine_search(t.row,t.col))
		if season == 'Winter' and Global.winter_farmtype_changes(t.farmType) != null:
			t.farmType = Global.winter_farmtype_changes(t.farmType)
			
	#trigger a new generation if needed - eventually based off energy/vitality instead of a constant?
	if day >= endDay: new_life()
	
	update_display()

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
	
#updates displayed information - optionally, use a string to update one thing only
func update_display(target = "all"):
	match target:
		"background": $Background.play(season)
		"day": %DayCounter.text = season + ', ' + str(year)
		"currency": %currency.text = '$' + str(Global.gold) + ', ' + str(Global.vegetables) + ' veggies, ' + str(Global.energy) + ' energy'
		"fertility":
			for tile in $FarmTiles.get_children():
				tile.tempFertilityDisplay.text = str(tile.fertility)
				
		"all":
			$Background.play(season)
			%DayCounter.text = season + ', ' + str(year)
			%currency.text = '$' + str(Global.gold) + ', ' + str(Global.vegetables) + ' veggies, ' + str(Global.energy) + ' energy'
			for tile in $FarmTiles.get_children():
				tile.tempFertilityDisplay.text = str(tile.fertility)
	
#returns number of adjacent shrines
func adjacent_shrine_search(row,col):
	var shrines = 0
	for t in farmTiles.get_children():
		if t.farmType==Global.FarmType.Shrine and ((((t.row==row+1) or (t.row==row-1)) and t.col==col) or (((t.col==col+1) or (t.col==col-1)) and t.row==row)):
			shrines += 1
	return shrines

func _ready():
	new_day()
	_initializeTileMap()
	tileMap[Vector2(5,3)].farmType = Global.FarmType.BrokenShrine
	tileMenu.hide()
	tileMenu.popup_hide.connect(_on_tile_menu_close)
	tileMenu.id_pressed.connect(_on_tile_menu_item)
	for tile in $FarmTiles.get_children():
		tile.tileActivated.connect(_tile_activated.bind(tile))
		tile.tileSelected.connect(_tile_selected.bind(tile))
		tile.tileUnselected.connect(_tile_unselected.bind(tile))

enum MenuOption { Demolish, Wheat, Vegetable, Shrine, RepairShrine, Bear, Till } 

func _on_tile_menu_close():
	Global.menu_mode = false
	selectedTile.selected = false

func _on_tile_menu_item(id):
	if selectedTile != null:
		var action_name = ''
		match id:
			MenuOption.Demolish:
				selectedTile.farmType = Global.FarmType.Empty
				action_name = 'demolish'
			MenuOption.Wheat:
				selectedTile.farmType = Global.FarmType.Wheat
				action_name = 'plant_wheat'
			MenuOption.Vegetable:
				selectedTile.farmType = Global.FarmType.Vegetable
				action_name = 'plant_vegetable'
			MenuOption.Shrine:
				selectedTile.farmType = Global.FarmType.Shrine
				action_name = 'build_shrine'
			MenuOption.RepairShrine:
				selectedTile.farmType = Global.FarmType.Shrine
				action_name = 'repair_shrine'
			MenuOption.Bear:
				selectedTile.farmType = Global.FarmType.Pasture
				action_name = 'bear'
			MenuOption.Till:
				selectedTile.farmType = Global.FarmType.TilledSoil
				action_name = 'till'
		var costs = Global.cost(action_name)
		Global.gold -= costs[0]
		Global.vegetables -= costs[1]
	update_display("currency")
	tileMenu.hide()

func _update_tile_menu(tile):
	tileMenu.clear()
	if tile.farmType == Global.FarmType.TilledSoil:
		tileMenu.add_item("Wheat Field", MenuOption.Wheat)
		tileMenu.add_item("Vegetable Patch", MenuOption.Vegetable)
	if tile.farmType == Global.FarmType.Empty:
		tileMenu.add_item("Till Soil", MenuOption.Till)		
		tileMenu.add_item("Shrine", MenuOption.Shrine)
		tileMenu.add_item("Bear Habitat", MenuOption.Bear)
	if tile.farmType == Global.FarmType.BrokenShrine:
		tileMenu.add_item("Repair Shrine", MenuOption.RepairShrine)
	if tile.farmType != Global.FarmType.Empty:
		tileMenu.add_item("Demolish", MenuOption.Demolish)

func _show_tile_menu(tile):
	Global.menu_mode = true
	tileMenu.position = tile.position + Vector2(64,0)
	if tileMenu.position.y + tileMenu.size.y > get_viewport().get_visible_rect().size.y:
		tileMenu.position.y = tile.position.y - tileMenu.size.y + 64
	if tileMenu.position.x + tileMenu.size.x > get_viewport().get_visible_rect().size.x:
		tileMenu.position.x = tile.position.x - tileMenu.size.x
	_update_tile_menu(tile)
	tileMenu.show()
	
func _tile_activated(tile):
	_show_tile_menu(tile)

func _tile_selected(tile): 
	if selectedTile != tile:
		if selectedTile != null: 
			selectedTile.selected = false
		tile.selected = true
		selectedTile = tile

func _tile_unselected(tile):
	if selectedTile == tile:
		selectedTile = null

#resets stats and sets up the game for a replay
func new_life():
	#set time data for a new game
	day = 0
	generation+=1
	year = starting_year + 50 * generation
	
	#address tiles
	for tile in $FarmTiles.get_children():
		var oldType = tile.farmType
		var newType = Global.newgame_farmtype_changes(oldType)
		
		#handle value changes
		if oldType == Global.FarmType.Pasture: tile.fertility += 1
			
		#change the tile if it needs to
		if newType != null: tile.farmType = newType
	
	new_day()
