extends Node2D

var starty = 0
var play_bool = false

func _ready():
	hide()
	starty = position.y
	#play(5,'gold',-3,'energy')

func play(num,resource,num2=null,resource2=null):
	play_bool = true
	if num > 0:
		$Text.text = '[right]+' + str(num) + '[/right]'
	elif num < 0:
		$Text.text = '[right]' + str(num) + '[/right]'
	$Icon.play(resource)
	position.y = starty
	show()
	$Timer.start(.7)
	await $Timer.timeout
	if num2!= null:
		hide()
		if num2 > 0:
			$Text.text = '[right]+' + str(num2) + '[/right]'
		elif num2 < 0:
			$Text.text = '[right]' + str(num2) + '[/right]'
		$Icon.play(resource2)
		$Timer.start(.1)
		await $Timer.timeout
		show()
		position.y = starty
		$Timer.start(.7)
		await $Timer.timeout
	play_bool = false
	position.y = starty
	hide()
		

func playText(text):
	play_bool = true
	$Text.text = '[right]' + text + '[/right]'
	$Icon.hide()
	position.y = starty
	show()
	$Timer.start(.7)
	await $Timer.timeout
	play_bool = false
	position.y = starty
	hide()

func _process(delta):
	if play_bool:
		position.y -= delta *15
	
