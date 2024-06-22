extends Node

class_name OnGoToTownEvents

class OnGoToTownEvent:
	func canRun(farm):
		return false
	
	func onFire(farm):
		return false

class FirstTownVisit extends OnGoToTownEvent:
	func canRun(farm):
		return farm.day == 1
	
	func onFire(farm: Farm):
		farm.endDayButton.visible = true

static var OnGoToTownEvents: Array[OnGoToTownEvent] = [
	FirstTownVisit.new()
]
