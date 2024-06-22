extends Node

class_name OnTileActionEvents

class OnTileActionEvent:
	func canRun(farm, tile):
		return false
	
	func onFire(farm, tile):
		return false

class PlantFirstWheat extends OnTileActionEvent:
	func canRun(farm, tile: Tile):
		return (!Global.eventFlags.has("PlantFirstWheat") || Global.eventFlags["PlantFirstWheat"] == false) && tile.farmType == Global.FarmType.Wheat
	
	func onFire(farm, tile):
		var EndDayButton: Button = farm.get_node("EndDayButton")
		EndDayButton.visible = true
		Global.eventFlags["PlantFirstWheat"] = true

static var OnTileActionEvents: Array[OnTileActionEvent] = [
	PlantFirstWheat.new()
]
