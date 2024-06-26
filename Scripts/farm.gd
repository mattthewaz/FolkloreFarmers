extends Node2D

class_name Farm

const EventHandler = preload("res://Scripts/eventhandler.gd")

@onready var tileMenu: PopupMenu = $TileMenu
@onready var farmTiles = $FarmTiles
@onready var endDayButton = $EndDayButton
@onready var town = $Town

var selectedTile = null
var seasons = ['Fall','Winter','Spring','Summer']
var season = 'Winter'
var day = 1
var baseEndDay = 13
var endDay = baseEndDay
var starting_year = 1824
var year = starting_year
var generation = 0

var tileMap: Dictionary
func _initializeTileMap():
	for tile in $FarmTiles.get_children():
		tileMap[Vector2(tile.col,tile.row)] = tile

func get_tile_at(col,row):
	if !tileMap.has(Vector2(col,row)):
		return null
	return tileMap[Vector2(col,row)]

#starts a new day - triggered by NewDayButton
func new_day():
	if not Global.menu_mode:
		day+=1
		EventHandler.runAfterEndOfDayEvent(self)
		season = seasons[day % 4]
		if season == 'Spring':
			year += 1
		for t in farmTiles.get_children():
			t.upkeep(adjacent_shrine_search(t.col,t.row))
			if season == 'Winter' and Global.winter_farmtype_changes(t.farmType) != null:
				t.farmType = Global.winter_farmtype_changes(t.farmType)
				
		#resolve negative veggies
		if Global.vegetables < 0:
			var bears = find_tiles(Global.FarmType.Pasture)
			var removal_number = Global.vegetables*-1
			bears.shuffle()
			
			while Global.vegetables < 0:
				bears[Global.vegetables+removal_number].farmType = Global.FarmType.Empty
				Global.vegetables += 1
		
		
		#Sets the new end day
		var newEndDay = baseEndDay + int(sqrt(Global.energy))
		if newEndDay > endDay:
			$Resources/RemSeas.set("theme_override_colors/default_color", Color(0, 1.0, 0, 1.0))
		endDay = newEndDay
		
		#trigger a new generation if needed - eventually based off energy/vitality instead of a constant?
		if day >= endDay: play_monologue('end')
		
		Global.actionPoints = 1
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
		"day":
			%DayCounter.text = season + ', ' + str(year)
			%RemSeas.text = "Remaining Seasons: " + str(endDay - day)
		"currency": 
			#%currency.text = '$' + str(Global.gold) + ', ' + str(Global.vegetables) + ' veggies, ' + str(Global.actionPoints) + ' actions'
			%Gold.text = str(Global.gold)
			%Veggies.text = str(Global.vegetables)
			%Actions.text = 'Actions: ' + str(Global.actionPoints)
			%Energy.text = str(Global.energy)
			$ActionIcon.play(str(Global.actionPoints))
			if Global.flags.town == Global.FeatureMode.Show && Global.actionPoints > 0:
				$Town.show()
			else:
				$Town.hide()
		"fertility":
			for tile in $FarmTiles.get_children():
				tile.tempFertilityDisplay.text = str(tile.fertility)
		
		#Update Everything if called without a valid argument
		_:
			$Background.play(season)
			%DayCounter.text = season + ', ' + str(year)
			%RemSeas.text = "Remaining Seasons: " + str(endDay - day)
			#%currency.text = '$' + str(Global.gold) + ', ' + str(Global.vegetables) + ' veggies, ' + str(Global.actionPoints) + ' actions'
			%Gold.text = str(Global.gold)
			%Veggies.text = str(Global.vegetables)
			%Actions.text = 'Actions: ' + str(Global.actionPoints)
			%Energy.text = str(Global.energy)
			for tile in $FarmTiles.get_children():
				tile.tempFertilityDisplay.text = str(tile.fertility)
			$ActionIcon.play(str(Global.actionPoints))
			if Global.flags.town == Global.FeatureMode.Show && Global.actionPoints > 0:
				$Town.show()
			else:
				$Town.hide()
	
#returns number of adjacent shrines
func adjacent_shrine_search(col,row):
	var shrines = 0
	var northTile = get_tile_at(col,row-1)
	if northTile != null && northTile.farmType==Global.FarmType.Shrine:
		shrines += 1
	var southTile = get_tile_at(col,row+1)
	if southTile != null && southTile.farmType==Global.FarmType.Shrine:
		shrines += 1
	var eastTile = get_tile_at(col+1,row)
	if eastTile != null && eastTile.farmType==Global.FarmType.Shrine:
		shrines += 1
	var westTile = get_tile_at(col-1,row)
	if westTile != null && westTile.farmType==Global.FarmType.Shrine:
		shrines += 1
	return shrines

#returns a list of all the tiles of the given type
func find_tiles(type):
	var results = []
	for tile in farmTiles.get_children():
		if tile.farmType == type:results.append(tile)
	return results

func _ready():
	$music.play()
	$music.set_volume_db(linear_to_db(Global.volume_percent))
	_initializeTileMap()
	update_display()
	tileMap[Vector2(5,3)].farmType = Global.FarmType.BrokenShrine
	tileMenu.hide()
	tileMenu.popup_hide.connect(_on_tile_menu_close)
	tileMenu.id_pressed.connect(_on_tile_menu_item_pressed)
	tileMenu.window_input.connect(_on_tile_menu_item_focused)
	$Score.new_generation_pressed.connect(_on_new_generation_click)
	for tile in $FarmTiles.get_children():
		tile.tileActivated.connect(_tile_activated.bind(tile))
		tile.tileSelected.connect(_tile_selected.bind(tile))
		tile.tileUnselected.connect(_tile_unselected.bind(tile))
	$Town.to_town.connect(_to_town.bind())


func _to_town():
	Global.actionPoints -= 1
	Global.gold += 5
	EventHandler.runOnGoToTownEvent(self)
	update_display()

func _on_tile_menu_close():
	Global.menu_mode = false
	selectedTile.selected = false
	var mousePos = get_viewport().get_mouse_position()
	for tile in $FarmTiles.get_children():
		var rect = Rect2(tile.position, Vector2(64, 64))
		if rect.has_point(mousePos):
			tile.selected = true
			break

func _on_tile_menu_item_pressed(id):
	if selectedTile != null && !EventHandler.runOnBeforeTileActionEvent(self, selectedTile, id):
		var action_name = ''
		match id:
			Global.FarmActions.Demolish:
				selectedTile.farmType = Global.FarmType.Empty
			Global.FarmActions.Wheat:
				selectedTile.farmType = Global.FarmType.Wheat
			Global.FarmActions.Vegetable:
				selectedTile.farmType = Global.FarmType.Vegetable
			Global.FarmActions.Shrine:
				selectedTile.farmType = Global.FarmType.Shrine
			Global.FarmActions.RepairShrine:
				selectedTile.farmType = Global.FarmType.Shrine
			Global.FarmActions.Bear:
				selectedTile.farmType = Global.FarmType.Pasture
			Global.FarmActions.Till:
				selectedTile.farmType = Global.FarmType.TilledSoil
		var costs = Global.cost(id)
		Global.gold -= costs[0]
		Global.vegetables -= costs[1]
		Global.actionPoints -= costs[2]
		EventHandler.runOnAfterTileActionEvent(self, selectedTile, id)
	update_display("currency")
	tileMenu.hide()

func _on_tile_menu_item_focused(event):
	var focusedIndex = tileMenu.get_focused_item()
	if focusedIndex == -1:
		%ContextInfo.text = ""
		return
	_show_action_context_info(tileMenu.get_item_id(focusedIndex))

func _addFarmAction(action):
	if (Global.flags.actions[action] == Global.FeatureMode.Hide):
		return
	
	tileMenu.add_item(Global.farm_action_names[action], action)
	
	if !Global.canAfford(action) || Global.flags.actions[action] == Global.FeatureMode.Disable:
		tileMenu.set_item_disabled(tileMenu.get_item_index(action), true)
	#if the action is afforable, disable if it is not apporpriate for the season
	elif season == 'Winter': 
		if action == Global.FarmActions.Wheat || action == Global.FarmActions.Vegetable || action == Global.FarmActions.Till:
			tileMenu.set_item_disabled(tileMenu.get_item_index(action), true)
			

func _update_tile_menu(tile):
	tileMenu.clear()
	if tile.farmType == Global.FarmType.TilledSoil:
		_addFarmAction(Global.FarmActions.Wheat)
		_addFarmAction(Global.FarmActions.Vegetable)
	if tile.farmType == Global.FarmType.Empty:
		_addFarmAction(Global.FarmActions.Till)		
		_addFarmAction(Global.FarmActions.Shrine)
		_addFarmAction(Global.FarmActions.Bear)
	if tile.farmType == Global.FarmType.BrokenShrine:
		_addFarmAction(Global.FarmActions.RepairShrine)
	if tile.farmType != Global.FarmType.Empty:
		_addFarmAction(Global.FarmActions.Demolish)

func _show_tile_menu(tile):
	if (Global.flags.actionMenu != Global.FeatureMode.Show):
		return
	
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
		_show_tile_context_info(selectedTile)

func _tile_unselected(tile):
	if selectedTile == tile:
		selectedTile = null
		%ContextInfo.text = ""

func _show_tile_context_info(tile):
	%ContextInfo.text = Global.farm_tile_names[tile.farmType] + ": " + Global.farm_tile_descriptions[tile.farmType] + "\n" + "Fertility: " + str(tile.fertility)

func _show_action_context_info(action):
	%ContextInfo.text = Global.farm_action_names[action] + ": " + Global.farm_action_descriptions[action] + "\n"
	%ContextInfo.text += "Cost: "
	var costs = []
	if Global.cost(action)[2] > 0:
		costs.append(str(Global.cost(action)[2]) + " action")
	if Global.cost(action)[0] > 0:
		costs.append("$" + str(Global.cost(action)[0]))
	if Global.cost(action)[1] > 0:
		costs.append(str(Global.cost(action)[1]) + " vegetables")
	%ContextInfo.text += ", ".join(costs)

func play_monologue(dialogue):
	$Monologue.show()
	$Monologue.play(dialogue)

#resets stats and sets up the game for a replay
func new_life():
	#set time data for a new game
	day = 1
	endDay = baseEndDay
	generation+=1
	year = starting_year + 50 * generation
	
	#address tiles
	for tile in $FarmTiles.get_children():
		var oldType = tile.farmType
		var newType = Global.newgame_farmtype_changes(oldType)
		
		#handle value changes
		if oldType == Global.FarmType.Pasture: tile.fertility += 1
		if oldType == Global.FarmType.Wheat: tile.fertility = max(1, tile.fertility - 1)
		if oldType == Global.FarmType.Vegetable: tile.fertility = max(1, tile.fertility - 1)
		if oldType == Global.FarmType.BrokenShrine: tile.fertility = 2
		
		#25% chance for tilled plots to remain tilled
		if (oldType == Global.FarmType.Wheat || oldType == Global.FarmType.Vegetable || oldType == Global.FarmType.TilledSoil):
			if randi() % 4 == 0:
				tile.farmType = Global.FarmType.TilledSoil
			else:
				tile.farmType = Global.FarmType.Empty
		
		#change the tile if it needs to
		if newType != null: tile.farmType = newType
	
	#reset resources
	Global.gold = Global.gold_initial
	Global.vegetables = 0
	Global.energy = 0
	
	new_day()

func _on_monologue_monologue_over():
	$Score.set_score(Global.energy)
	$Score.show()

func _on_new_generation_click():
	$Score.hide()
	new_life()
	play_monologue('start')
	update_display()

func _on_music_finished():
	$music.play()

func _process(delta):
	var remSeqsColor = $Resources/RemSeas.get("theme_override_colors/default_color")
	if remSeqsColor.r < 1.0:
		var newColor = Color(min(remSeqsColor.r + delta * .5, 1.0), 1.0, min(remSeqsColor.b + delta * .5, 1.0), 1.0)
		$Resources/RemSeas.set("theme_override_colors/default_color", newColor)
