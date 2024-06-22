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

static func runOnTileActionEvent(farm: Farm, tile: Tile):
	for onTileActionEvent in OnTileActionEvents.OnTileActionEvents:
		if onTileActionEvent.canRun(farm, tile):
			onTileActionEvent.onFire(farm, tile)
