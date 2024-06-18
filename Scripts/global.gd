extends Node

enum FarmType { Empty, Wheat, Shrine, Vegetable, Pasture, BrokenShrine, TilledSoil }
enum FarmActions { Demolish, Wheat, Vegetable, Shrine, RepairShrine, Bear, Till } 

var gold = 30
var energy = 1
var vegetables = 0

var menu_mode = false

#[ gold_change, vegetable_change, energy_change ]
const daily_upkeep_constants = {
	FarmType.Empty : [0, 0, 0],
	FarmType.Wheat : [10, 0, 0],
	FarmType.Shrine : [0, 0, 1],
	FarmType.Vegetable : [0, 1, 0],
	FarmType.Pasture : [0, -1, 1],
	FarmType.BrokenShrine : [0, 0, 0],
	FarmType.TilledSoil : [0, 0, 0]
	}

#[ gold_cost, vegetable_cost, action_cost]
const cost_constants = {
	FarmActions.Till: [0, 0, 1],
	FarmActions.Shrine: [100, 0, 1],
	FarmActions.RepairShrine: [20, 0, 1],
	FarmActions.Wheat: [5, 0, 0],
	FarmActions.Vegetable: [30, 0, 0],
	FarmActions.Bear: [0, 3, 1],
	FarmActions.Demolish: [0, 0, 1]
	}

const farm_action_names = {
	FarmActions.Demolish: "Demolish",
	FarmActions.Wheat: "Wheat Field",
	FarmActions.Vegetable: "Vegetable Patch",
	FarmActions.Shrine: "Build Shrine",
	FarmActions.RepairShrine: "Repair Shrine",
	FarmActions.Bear: "Bear Habitat",
	FarmActions.Till: "Till Soil"
}

#[ winter_change_to, newgame_change_to ]
const farmtype_changes = {
	FarmType.Empty : [null, null],
	FarmType.Wheat : [FarmType.TilledSoil, FarmType.Empty],
	FarmType.Shrine : [null, FarmType.BrokenShrine],
	FarmType.Vegetable : [FarmType.TilledSoil, FarmType.Empty],
	FarmType.Pasture : [null, FarmType.Empty],
	FarmType.BrokenShrine : [null, null],
	FarmType.TilledSoil : [null, FarmType.Empty]	
	}

func winter_farmtype_changes(farmType):
	return farmtype_changes[farmType][0]

func newgame_farmtype_changes(farmType):
	return farmtype_changes[farmType][1]

# returns [ gold_change, vegetable_change, energy_change ]
func daily_update(farmType):
	return daily_upkeep_constants[farmType]

#returns [ gold_cost, vegetable_cost, action_cost]
func cost(action):
	return cost_constants[action]

func canAfford(action):
	return gold >= cost(action)[0] && vegetables >= cost(action)[1] && energy >= cost(action)[2]
