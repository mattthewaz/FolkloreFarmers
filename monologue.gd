extends Node2D

@onready var portrait = $Portrait
@onready var box = $SpeechBox
@onready var cont = $Continue
var line = 0
signal monologue_over
var story

const lifegain_text = [
	"That shrine really makes the farm feel special. I can't tell what it is, but it sure looks nice.",
	"Actually, makes me feel stronger too, like my spirit is at peace. 'most like I'm a few months younger.",
	"If I kept improving the sprititual aspects of this place, I might live forever."
]

const fertility_text = [
	"The soil under that rubble looks like a great place to plant wheat. I should till the soil and plant there."
]

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
	],
	["I always loved visiting the weird old farm. My parents hated it though—the word in the town where I grew up was that the place was haunted.",
	"The other kids were all too scared to go near, but when I showed up as a dare the old farmer there was real nice to me, and I started visiting regularly.",
	"Now they're gone, rest in peace, and they left the place to me. This chance is once in a lifetime, so I’d be a fool to not show up because of some weird rumors."
	],
	["I’ve never really fit in, catch my drift? The big city life is way too fast-paced for me, and the world’s been modernizing way too quick.",
	"That’s why I decided to move to this nifty little pad I found not far from town. It’s got this groovy plot of land for farming too, though the rocks everywhere are pretty freaky-deaky.",
	"But I’ll give you the skinny: the place was extra cheap ‘cause there’s an old local story that there’s some kinda spiritual disturbance on the property.",
	"Weird stories of spirits and monsters in the form of bears. But honestly I’m down with that stuff. So let’s take this to the max!"
	],
	["Found this old farm up for sale, REAL cheap. Internet was chock-full of scary rumors and stuff. Nightmares, curses, and ghosts with glowing eyes!",
	"That's all bogus, but how cool would that be?"
	]
	]

const end_text = [[
	"I'm gettin’ on in years, but I'm fitter than I ought to be. I can still take care of the farm, but I'm not sure for how long.",
	"My daughter loves the bears, but her husband's scared of ‘em. They won't take care of the place. Wonder what will happen to the farm and the bears when I'm gone…"
	],
	["Well, I've sure learned a whole lot since comin’ here. Ma’s stories was real all along, but the shrines bring a lot of peace.",
	 "I sure hope the next person who lives here gives it the care it deserves. I never did have children, but there's a kid from town who's stopped by a few times who I might try’n leave the place to.",
	"Still pretty young, but I think that kid's got what it takes."
	],
	["The town I grew up in has gotten a lot bigger. People still say the place is haunted, and even though I've tried to convince my friends that it’s a nice place, I don’t know if they quite believe it.", 
	"But now, after being on this farm practically my whole life, I'm going to sell the place.",
	"It breaks my heart a bit, but with the world seeming on the brink of war these days I know I have to do something out there. Help other people, you know? Anyway, maybe I'll buy it back someday. But for now, goodbye."
	],
	["Farming’s been radical, but I’m ready to chill out and put that down. Maybe I’ll move to a big city."
	],
	["Time to move on to bigger and better things!"]
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
		else:
			box.text = start_text[4][line]
	elif dialogue == 'end':
		if Global.generation < len(end_text):
			box.text = end_text[Global.generation][line]
		else:
			box.text = end_text[4][line]
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
	elif dialogue == 'fertility':
		box.text = fertility_text[0]
		story = 'fertility'
	elif dialogue == 'lifegain':
		box.text = lifegain_text[0]
		story = 'lifegain'
	portrait.play(str(Global.current_character))

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
			if Global.generation < 4: Global.generation += 1
			hide()
			emit_signal("monologue_over")
			Global.monologue_mode = false
	elif story == 'wheat' or story == 'veggie' or story == 'fertility':
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
			line += 1
			$cutscene.show()
			box.text = shrine_text[3]
		else:
			hide()
			Global.monologue_mode = false
			Global.menu_mode = false
	elif story == 'lifegain':
		if line < (len(lifegain_text)-1):
			line += 1
			box.text = lifegain_text[line]
		else:
			hide()
			Global.monologue_mode = false
			Global.menu_mode = false
		
