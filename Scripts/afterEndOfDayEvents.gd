extends Node

class_name AfterEndOfDayEvents

class AfterEndOfDayEvent:
	func canRun(farm):
		return false
	
	func onFire(farm):
		return false

class ExplainWheat extends AfterEndOfDayEvent:
	func canRun(farm: Farm):
		return farm.day == 2 && farm.generation == 0
	
	func onFire(farm):
		farm.play_monologue('wheat')
		Global.flags.actionMenu = Global.FeatureMode.Show
		Global.flags.actions[Global.FarmActions.Till] = Global.FeatureMode.Show
		Global.flags.actions[Global.FarmActions.Wheat] = Global.FeatureMode.Show
		Global.flags.town = Global.FeatureMode.Hide
		
		farm.endDayButton.visible = false

class ExplainRubble extends AfterEndOfDayEvent:
	func canRun(farm):
		return farm.day == 3 && farm.generation == 0
	
	func onFire(farm: Farm):
		farm.play_monologue('rubble')
		Global.flags.actions[Global.FarmActions.Till] = Global.FeatureMode.Hide
		Global.flags.actions[Global.FarmActions.Wheat] = Global.FeatureMode.Hide
		Global.flags.actions[Global.FarmActions.Demolish] = Global.FeatureMode.Show
		Global.flags.town = Global.FeatureMode.Hide
		
		farm.endDayButton.visible = false

class IntroduceFertility extends AfterEndOfDayEvent:
	func canRun(farm):
		return farm.day == 4 && farm.generation == 0
	
	func onFire(farm):
		farm.play_monologue('fertility')
		Global.flags.actions[Global.FarmActions.Till] = Global.FeatureMode.Show
		Global.flags.actions[Global.FarmActions.Wheat] = Global.FeatureMode.Show
		Global.flags.actions[Global.FarmActions.Demolish] = Global.FeatureMode.Hide
		Global.flags.town = Global.FeatureMode.Hide
		
		farm.endDayButton.visible = false

class IntroduceShrine extends AfterEndOfDayEvent:
	func canRun(farm):
		return farm.day == 5 && farm.generation == 0
	
	func onFire(farm):
		farm.play_monologue('shrine')
		Global.flags.actions[Global.FarmActions.Till] = Global.FeatureMode.Hide
		Global.flags.actions[Global.FarmActions.Wheat] = Global.FeatureMode.Hide
		Global.flags.actions[Global.FarmActions.Demolish] = Global.FeatureMode.Hide
		Global.flags.actions[Global.FarmActions.RepairShrine] = Global.FeatureMode.Show
		Global.flags.town = Global.FeatureMode.Hide
		
		farm.endDayButton.visible = false

class IntroduceVegetables extends AfterEndOfDayEvent:
	func canRun(farm):
		return farm.day == 6 && farm.generation == 0
	
	func onFire(farm):
		farm.play_monologue('veggies')
		Global.gold += 20
		Global.flags.actions[Global.FarmActions.Till] = Global.FeatureMode.Hide
		Global.flags.actions[Global.FarmActions.Wheat] = Global.FeatureMode.Hide
		Global.flags.actions[Global.FarmActions.Demolish] = Global.FeatureMode.Hide
		Global.flags.actions[Global.FarmActions.RepairShrine] = Global.FeatureMode.Hide
		Global.flags.actions[Global.FarmActions.Vegetable] = Global.FeatureMode.Show
		Global.flags.town = Global.FeatureMode.Hide
		
		farm.endDayButton.visible = false

class IntroduceBears extends AfterEndOfDayEvent:
	func canRun(farm):
		return farm.day == 8 && farm.generation == 0
	
	func onFire(farm):
		farm.play_monologue('bear')
		Global.flags.actions[Global.FarmActions.Till] = Global.FeatureMode.Hide
		Global.flags.actions[Global.FarmActions.Wheat] = Global.FeatureMode.Hide
		Global.flags.actions[Global.FarmActions.Demolish] = Global.FeatureMode.Hide
		Global.flags.actions[Global.FarmActions.RepairShrine] = Global.FeatureMode.Hide
		Global.flags.actions[Global.FarmActions.Vegetable] = Global.FeatureMode.Hide
		Global.flags.actions[Global.FarmActions.Bear] = Global.FeatureMode.Show
		Global.flags.town = Global.FeatureMode.Hide
		
		farm.endDayButton.visible = false

class IntroduceLifeExtension extends AfterEndOfDayEvent:
	func canRun(farm: Farm):
		return (!Global.eventFlags.has("IntroduceLifeExtension") || Global.eventFlags["IntroduceLifeExtension"] == false) && farm.endDay > farm.baseEndDay && farm.generation == 0
	
	func onFire(farm):
		farm.play_monologue('lifegain')
		Global.eventFlags["IntroduceLifeExtension"] = true

static var AfterEndOfDayEvents: Array[AfterEndOfDayEvent] = [
	ExplainWheat.new(),
	ExplainRubble.new(),
	IntroduceFertility.new(),
	IntroduceShrine.new(),
	IntroduceVegetables.new(),
	IntroduceBears.new(),
	IntroduceLifeExtension.new()
]
