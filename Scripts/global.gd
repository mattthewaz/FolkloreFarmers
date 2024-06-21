extends Node

enum FarmType { Empty, Wheat, Shrine, Vegetable, Pasture, BrokenShrine, TilledSoil, Rubble }
enum FarmActions { Demolish, Wheat, Vegetable, Shrine, RepairShrine, Bear, Till } 

var gold_initial = 0
var gold = gold_initial
var energy = 0
var vegetables = 0
var actionPoints = 1
var tiles_ungenned = 38
var current_character
var generation = 0
var rubble_count = 4
var menu_mode = false
var monologue_mode = false

#[ gold_change, vegetable_change, energy_change ]
const daily_upkeep_constants = {
	FarmType.Empty : [0, 0, 0],
	FarmType.Wheat : [10, 0, 0],
	FarmType.Shrine : [0, 0, 1],
	FarmType.Vegetable : [0, 1, 0],
	FarmType.Pasture : [0, -1, 1],
	FarmType.BrokenShrine : [0, 0, 0],
	FarmType.TilledSoil : [0, 0, 0],
	FarmType.Rubble: [0, 0, 0]
	}

const farm_tile_names = {
	FarmType.Empty : "Open Field",
	FarmType.Wheat : "Wheat Field",
	FarmType.Shrine : "Shrine",
	FarmType.Vegetable : "Vegetable Patch",
	FarmType.Pasture : "Bear Habitat",
	FarmType.BrokenShrine : "Broken Shrine",
	FarmType.TilledSoil: "Tilled Soil",
	FarmType.Rubble: "Rubble"
}

const farm_tile_descriptions = {
	FarmType.Empty : "Can build new buildings on this land",
	FarmType.Wheat : "Generates money based on fertility",
	FarmType.Shrine : "Allows bear habitats to be built nearby",
	FarmType.Vegetable : "Generates vegetables based on fertility",
	FarmType.Pasture : "Feed bears vegetables to generate spiritual power",
	FarmType.BrokenShrine : "Can be repaired; cheaper than building a new shrine",
	FarmType.TilledSoil: "Field ready to be planted upon",
	FarmType.Rubble: "Rocks that can be removed to access the rich soil beneath"
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
	FarmActions.Wheat: "Plant Wheat",
	FarmActions.Vegetable: "Plant Vegetables",
	FarmActions.Shrine: "Build Shrine",
	FarmActions.RepairShrine: "Repair Shrine",
	FarmActions.Bear: "Build Bear Habitat",
	FarmActions.Till: "Till Soil"
}

const farm_action_descriptions = {
	FarmActions.Demolish: "Convert tile to open space",
	FarmActions.Wheat: "Plant wheat for steady income",
	FarmActions.Vegetable: "Plant vegetable patch to earn vegetables",
	FarmActions.Shrine: "Build shrine",
	FarmActions.RepairShrine: "Repair broken shrine",
	FarmActions.Bear: "Build Bear Habitat",
	FarmActions.Till: "Till the soil to prepare to plant crops"
}

#[ winter_change_to, newgame_change_to ]
const farmtype_changes = {
	FarmType.Empty : [null, null],
	FarmType.Wheat : [FarmType.TilledSoil, FarmType.Empty],
	FarmType.Shrine : [null, FarmType.BrokenShrine],
	FarmType.Vegetable : [FarmType.TilledSoil, FarmType.Empty],
	FarmType.Pasture : [null, FarmType.Empty],
	FarmType.BrokenShrine : [null, null],
	FarmType.TilledSoil : [null, FarmType.Empty],
	FarmType.Rubble: [null,null]
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
	return gold >= cost(action)[0] && vegetables >= cost(action)[1] && actionPoints >= cost(action)[2]
