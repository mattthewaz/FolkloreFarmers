extends Node

class_name AfterEndOfDayEvents

class AfterEndOfDayEvent:
	func canRun(farm):
		return false
	
	func onFire(farm):
		return false

class ExplainWheat extends AfterEndOfDayEvent:
	func canRun(farm):
		return farm.day == 2
	
	func onFire(farm):
		farm.play_monologue('wheat')
		Global.flags.actionMenu = Global.FeatureMode.Show
		Global.flags.actions[Global.FarmActions.Till] = Global.FeatureMode.Show
		Global.flags.actions[Global.FarmActions.Wheat] = Global.FeatureMode.Show
		
		var EndDayButton: Button = farm.get_node("EndDayButton")
		EndDayButton.visible = false

class ExplainRubble extends AfterEndOfDayEvent:
	func canRun(farm):
		return farm.day == 3
	
	func onFire(farm):
		farm.play_monologue('rubble')
		Global.flags.actions[Global.FarmActions.Till] = Global.FeatureMode.Hide
		Global.flags.actions[Global.FarmActions.Wheat] = Global.FeatureMode.Hide
		Global.flags.actions[Global.FarmActions.Demolish] = Global.FeatureMode.Show
		
		var EndDayButton: Button = farm.get_node("EndDayButton")
		EndDayButton.visible = false

class IntroduceShrine extends AfterEndOfDayEvent:
	func canRun(farm):
		return farm.day == 5
	
	func onFire(farm):
		farm.play_monologue('shrine')
		Global.flags.actions[Global.FarmActions.RepairShrine] = Global.FeatureMode.Show
		Global.flags.actions[Global.FarmActions.Demolish] = Global.FeatureMode.Hide
		
		var EndDayButton: Button = farm.get_node("EndDayButton")
		EndDayButton.visible = false

class IntroduceVegetables extends AfterEndOfDayEvent:
	func canRun(farm):
		return farm.day == 6
	
	func onFire(farm):
		farm.play_monologue('veggies')

class IntroduceBears extends AfterEndOfDayEvent:
	func canRun(farm):
		return farm.day == 8
	
	func onFire(farm):
		farm.play_monologue('bears')

static var AfterEndOfDayEvents: Array[AfterEndOfDayEvent] = [
	ExplainWheat.new(),
	ExplainRubble.new(),
	IntroduceShrine.new(),
	IntroduceVegetables.new(),
	IntroduceBears.new()
]
