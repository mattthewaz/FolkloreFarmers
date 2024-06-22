extends Node

class_name EventHandler

const AfterEndOfDayEvents = preload("res://Scripts/afterEndOfDayEvents.gd")
const OnGoToTownEvents = preload("res://Scripts/onGoToTownEvents.gd")
const OnTileActionEvents = preload("res://Scripts/onTileActionEvents.gd")

static func runAfterEndOfDayEvent(farm: Farm):
	for afterEndOfDayEvent in AfterEndOfDayEvents.AfterEndOfDayEvents:
		if afterEndOfDayEvent.canRun(farm):
			afterEndOfDayEvent.onFire(farm)

static func runOnGoToTownEvent(farm: Farm):
	for onGoToTownEvent in OnGoToTownEvents.OnGoToTownEvents:
		if onGoToTownEvent.canRun(farm):
			onGoToTownEvent.onFire(farm)

static func runOnBeforeTileActionEvent(farm: Farm, tile: Tile, action):
	for onTileActionEvent in OnTileActionEvents.OnTileActionEvents:
		if onTileActionEvent.canRun(farm, tile, action):
			var result = onTileActionEvent.onBeforeTileAction(farm, tile, action)
			if result == true:
				return true

static func runOnAfterTileActionEvent(farm: Farm, tile: Tile, action):
	for onTileActionEvent in OnTileActionEvents.OnTileActionEvents:
		if onTileActionEvent.canRun(farm, tile, action):
			onTileActionEvent.onAfterTileAction(farm, tile, action)
