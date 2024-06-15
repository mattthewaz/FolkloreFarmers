extends Node2D

var day = 1

func new_day():
	day+=1
	%DayCounter.text = "Day " + str(day)
