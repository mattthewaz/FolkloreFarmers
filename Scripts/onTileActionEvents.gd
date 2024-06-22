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
		var EndDayButton: Button = farm.get_node("EndDayButton")
		EndDayButton.visible = true
		Global.eventFlags["PlantFirstWheat"] = true

class DestroyFirstRock extends OnTileActionEvent:
	func canRun(farm, tile: Tile, action):
		return (!Global.eventFlags.has("DestroyFirstRock") || Global.eventFlags["DestroyFirstRock"] == false) && action == Global.FarmActions.Demolish
	
	func onBeforeTileAction(farm, tile: Tile, action):
		if tile.farmType != Global.FarmType.Rubble:
			return true #cancel action
	
	func onAfterTileAction(farm, tile: Tile, action):
		var EndDayButton: Button = farm.get_node("EndDayButton")
		EndDayButton.visible = true
		Global.eventFlags["DestroyFirstRock"] = true

class RepairFirstShrine extends OnTileActionEvent:
	func canRun(farm, tile: Tile, action):
		return (!Global.eventFlags.has("RepairFirstShrine") || Global.eventFlags["RepairFirstShrine"] == false) && action == Global.FarmActions.RepairShrine
	
	func onAfterTileAction(farm, tile: Tile, action):
		var EndDayButton: Button = farm.get_node("EndDayButton")
		EndDayButton.visible = true
		Global.eventFlags["RepairFirstShrine"] = true

static var OnTileActionEvents: Array[OnTileActionEvent] = [
	PlantFirstWheat.new(),
	DestroyFirstRock.new(),
	RepairFirstShrine.new()
]
