extends Node2D

var day = 1

func new_day():
	day+=1
	%DayCounter.text = "Day " + str(day)

func testTiles():
	var A1 = get_node("TileA1")
	A1.farmType = Global.FarmType.Empty
	var A2 = get_node("TileA2")
	A2.farmType = Global.FarmType.Wheat
	var A3 = get_node("TileA3")
	A3.farmType = Global.FarmType.Shrine
	var A4 = get_node("TileA4")
	A4.farmType = Global.FarmType.Vegetable
	var A5 = get_node("TileA5")
	A5.farmType = Global.FarmType.Pasture

func _ready():
	#pass
	testTiles()
