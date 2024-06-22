extends Node2D

@onready var portrait = $Portrait
@onready var box = $SpeechBox
@onready var cont = $Continue
var line = 0
signal monologue_over
var story

const wheat_text = [
	"Time to get to work! I'll have to till the land before I plant anything. Probably start with some wheat."
	]

const rubble_text = [
	"Been havin' the same nightmares as Gramps. Every night. I wake up sweating, breathing heavily. Chased by bears. And the eyes… Those intense, glowing eyes…",
	"Anyway, those big rocks are in the way. I heard once that the soil underneath rocks is more fertile. Maybe I'll take a pickaxe to one of those."
	]

const shrine_text = [
	"Gettin' cold again already, huh? I guess it's been a whole year. Ground's too cold to till, and all the crops have died.",
	"Maybe I'll go sit by that weird ol' rock in the field.",
	"Huh?",
	"I wonder what'd happen if I repaired this shrine. Seems'ta have some sorta power."
	]

const veggie_text = [
	"Found some seeds by the old shrine after the ground thawed. Not sure what they'll grow, but I ain't too picky. Might plant some wheat or somethin' as well."
	]

const bear_text = [
	"The bears ain't chasin’ me no more in my dreams. They're just watchin’. Waitin’. Expectin’ something.",
	"What was I doin’ in that dream? Plantin’ veggies? … Do bears even like veggies?",
	"Guess I can leave some out by the shrine."
	]

const start_text = [[
	"Here it is! Gramps's farm!",
	"Still can't believe he's gone. Fit as a fiddle, and just up and dies for no reason. He left this place to me.",
	"Won it in the war. Slashed the forest, burned it, and the farm was real good first few years. It got less fertile with time, but he never gave up on it, even with the nightmares.",
	"Bears with glowin’ eyes, he said. Every night. He said it was a curse, but I think it was guilt. I'd feel bad too if I found out some bears accidentally died in the fire I started.",
	"Good animals, bears. Long as you let ‘em be. Wonder if they'll be back in the area so long after the fire…",
	"Problem is, I don't have the money for seeds yet. I guess I should go to town and do some odd jobs while the ground's too cold to till!",
	"Just gotta go down the path towards town."
	],
	["Ma told stories of this place. Said it was beautiful, with tons of friendly bears that she'd play with.",
	"It don't look like that now though. Place is run down. It's spooky… But that stuff she said about a curse can't be real, right?",
	"She said she loved it here, said it made her feel alive. Her biggest regret was always not coming back to this place my great-great-grandpa built.",
	"So I'm gonna give it my best shot."
	]
	]

const end_text = [[
	"I'm gettin’ on in years, but I'm fitter than I ought to be. I can still take care of the farm, but I'm not sure for how long.",
	"My daughter loves the bears, but her husband's scared of ‘em. They won't take care of the place. Wonder what will happen to the farm and the bears when I'm gone…"
	]
	]

# Called when the node enters the scene tree for the first time.
func _ready():
	$cutscene.hide()
	play('start')

func play(dialogue):
	story = dialogue
	Global.menu_mode = true
	Global.monologue_mode = true
	line = 0
	if dialogue == 'start':
		Global.current_character = randi_range(1,34)
		if Global.generation < len(start_text):
			box.text = start_text[Global.generation][line]
	elif dialogue == 'end':
		if Global.generation < len(end_text):
			box.text = end_text[Global.generation][line]
	elif dialogue == 'wheat':
		box.text = wheat_text[0]
		story = 'wheat'
	elif dialogue == 'rubble':
		box.text = rubble_text[0]
		story = 'rubble'
	elif dialogue == 'bear':
		box.text = bear_text[0]
		story = 'bear'
	elif dialogue == 'veggies':
		box.text = veggie_text[0]
		story = 'veggie'
	elif dialogue == 'shrine':
		box.text = shrine_text[0]
		story = 'shrine'
	var image = Image.load_from_file("res://sprites/Portraits/farmer_maybe" + str(Global.current_character) + ".png")
	portrait.texture = ImageTexture.create_from_image(image)

func _on_continue_pressed():
	if story == 'start':
		if line < len(start_text[Global.generation])-1:
			line += 1
			box.text = start_text[Global.generation][line]
		else:
			Global.menu_mode = false
			hide()
			Global.monologue_mode = false
	elif story == 'end':
		if line < len(end_text[Global.generation])-1:
			line += 1
			box.text = end_text[Global.generation][line]
		else:
			Global.generation += 1
			hide()
			emit_signal("monologue_over")
			Global.monologue_mode = false
	elif story == 'wheat' or story == 'veggie':
		hide()
		Global.monologue_mode = false
		Global.menu_mode = false
	elif story == 'rubble':
		if line < (len(rubble_text)-1):
			line += 1
			box.text = rubble_text[line]
		else:
			hide()
			Global.monologue_mode = false
			Global.menu_mode = false
	elif story == 'bear':
		if line < (len(bear_text)-1):
			line += 1
			box.text = bear_text[line]
		else:
			hide()
			Global.monologue_mode = false
			Global.menu_mode = false
	elif story == 'shrine':
		if line < 2:
			line += 1
			box.text = shrine_text[line]
		elif line == 2:
			$cutscene.show()
			box.text = shrine_text[3]
		else:
			hide()
			Global.monologue_mode = false
			Global.menu_mode = false
		
		
