extends Node

enum FarmType { Empty, Wheat, Shrine, Vegetable, Pasture, BrokenShrine, TilledSoil }

var gold = 0
var energy = 0
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
	'till': [0, 0, 1],
	'build_shrine': [100, 0, 1],
	'repair_shrine': [20, 0, 1],
	'plant_wheat': [5, 0, 0],
	'plant_vegetable': [30, 0, 0],
	'attract_bears': [0, 3, 1],
	'demolish': [0, 0, 1]
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
