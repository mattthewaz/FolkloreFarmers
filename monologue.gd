extends Node2D

@onready var portrait = $Portrait
@onready var box = $SpeechBox
@onready var cont = $Continue
var line = 0
signal monologue_over

const start_text = [[
	"Here it is! Gramps's farm!",
	"Still can't believe he's gone. Fit as a fiddle, and just up and dies for no reason. He left this place to me.",
	"Won it in the war. Slashed the forest, burned it, and the farm was real good first few years. It got less fertile with time, but he never gave up on it, even with the nightmares.",
	"Bears with glowin’ eyes, he said. Every night. He said it was a curse, but I think it was guilt. I'd feel bad too if I found out some bears accidentally died in the fire I started.",
	"Good animals, bears. Long as you let ‘em be. Wonder if they'll be back in the area so long after the fire…"
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
	play()

func play():
	Global.menu_mode = true
	Global.monologue_mode = true
	line = 0
	if Global.story == 'start':
		Global.current_character = randi_range(1,34)
		if Global.generation < len(start_text):
			box.text = start_text[Global.generation][line]
	elif Global.story == 'end':
		if Global.generation < len(end_text):
			box.text = end_text[Global.generation][line]
	var image = Image.load_from_file("res://sprites/Portraits/farmer_maybe" + str(Global.current_character) + ".png")
	portrait.texture = ImageTexture.create_from_image(image)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_continue_pressed():
	if Global.story == 'start':
		if line < len(start_text[Global.generation])-1:
			line += 1
			box.text = start_text[Global.generation][line]
		else:
			Global.story = 'end'
			Global.menu_mode = false
			hide()
			Global.monologue_mode = false
	elif Global.story == 'end':
		if line < len(end_text[Global.generation])-1:
			line += 1
			box.text = end_text[Global.generation][line]
		else:
			Global.story = 'start'
			Global.generation += 1
			hide()
			emit_signal("monologue_over")
			Global.monologue_mode = false
