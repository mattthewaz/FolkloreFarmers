extends Node

class_name OnTileActionEvents

class OnTileActionEvent:
	func canRun(farm, tile, action):
		return false
	
	func onBeforeTileAction(farm, tile, action) -> bool:
		return false
	
	func onAfterTileAction(farm, tile, action):
		return false

class PlantFirstWheat extends OnTileActionEvent:
	func canRun(farm, tile: Tile, action):
		return (!Global.eventFlags.has("PlantFirstWheat") || Global.eventFlags["PlantFirstWheat"] == false) && action == Global.FarmActions.Wheat
	
	func onAfterTileAction(farm, tile, action):
		farm.endDayButton.visible = true
		Global.eventFlags["PlantFirstWheat"] = true
		Global.flags.town = Global.FeatureMode.Show

class DestroyFirstRock extends OnTileActionEvent:
	func canRun(farm, tile: Tile, action):
		return (!Global.eventFlags.has("DestroyFirstRock") || Global.eventFlags["DestroyFirstRock"] == false) && action == Global.FarmActions.Demolish
	
	func onBeforeTileAction(farm, tile: Tile, action):
		if tile.farmType != Global.FarmType.Rubble:
			return true #cancel action
	
	func onAfterTileAction(farm, tile: Tile, action):
		farm.endDayButton.visible = true
		Global.eventFlags["DestroyFirstRock"] = true
		Global.flags.town = Global.FeatureMode.Show
		Global.flags.actions[Global.FarmActions.Till] = Global.FeatureMode.Show
		Global.flags.actions[Global.FarmActions.Wheat] = Global.FeatureMode.Show

class RepairFirstShrine extends OnTileActionEvent:
	func canRun(farm, tile: Tile, action):
		return (!Global.eventFlags.has("RepairFirstShrine") || Global.eventFlags["RepairFirstShrine"] == false) && action == Global.FarmActions.RepairShrine
	
	func onAfterTileAction(farm, tile: Tile, action):
		farm.endDayButton.visible = true
		Global.eventFlags["RepairFirstShrine"] = true
		Global.flags.town = Global.FeatureMode.Show
		Global.flags.actions[Global.FarmActions.Till] = Global.FeatureMode.Show
		Global.flags.actions[Global.FarmActions.Wheat] = Global.FeatureMode.Show
		Global.flags.actions[Global.FarmActions.Demolish] = Global.FeatureMode.Show

class PlantFirstVegetables extends OnTileActionEvent:
	func canRun(farm, tile: Tile, action):
		return (!Global.eventFlags.has("PlantFirstVegetables") || Global.eventFlags["PlantFirstVegetables"] == false) && action == Global.FarmActions.Vegetable
	
	func onAfterTileAction(farm, tile: Tile, action):
		farm.endDayButton.visible = true
		Global.eventFlags["PlantFirstVegetables"] = true
		Global.flags.town = Global.FeatureMode.Show
		Global.flags.actions[Global.FarmActions.Till] = Global.FeatureMode.Show
		Global.flags.actions[Global.FarmActions.Wheat] = Global.FeatureMode.Show
		Global.flags.actions[Global.FarmActions.Demolish] = Global.FeatureMode.Show
		Global.flags.actions[Global.FarmActions.RepairShrine] = Global.FeatureMode.Show

class BuildFirstBears extends OnTileActionEvent:
	func canRun(farm, tile: Tile, action):
		return (!Global.eventFlags.has("BuildFirstBears") || Global.eventFlags["BuildFirstBears"] == false) && action == Global.FarmActions.Bear
	
	func onAfterTileAction(farm, tile: Tile, action):
		farm.endDayButton.visible = true
		Global.eventFlags["BuildFirstBears"] = true
		Global.flags.town = Global.FeatureMode.Show
		Global.flags.actions[Global.FarmActions.Till] = Global.FeatureMode.Show
		Global.flags.actions[Global.FarmActions.Wheat] = Global.FeatureMode.Show
		Global.flags.actions[Global.FarmActions.Demolish] = Global.FeatureMode.Show
		Global.flags.actions[Global.FarmActions.RepairShrine] = Global.FeatureMode.Show
		Global.flags.actions[Global.FarmActions.Vegetable] = Global.FeatureMode.Show
		Global.flags.actions[Global.FarmActions.Shrine] = Global.FeatureMode.Show

class PreventNonRockDestruction extends OnTileActionEvent:
	func canRun(farm, tile: Tile, action):
		return (!Global.eventFlags.has("BuildFirstBears") || Global.eventFlags["BuildFirstBears"] == false) && action == Global.FarmActions.Demolish
		
	func onBeforeTileAction(farm, tile: Tile, action):
		if tile.farmType != Global.FarmType.Rubble:
			return true #cancel action

static var OnTileActionEvents: Array[OnTileActionEvent] = [
	PlantFirstWheat.new(),
	DestroyFirstRock.new(),
	RepairFirstShrine.new(),
	PlantFirstVegetables.new(),
	BuildFirstBears.new(),
	PreventNonRockDestruction.new()
]
