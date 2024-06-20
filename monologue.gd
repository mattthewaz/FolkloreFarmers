extends Node2D

@onready var portrait = $Portrait
@onready var box = $SpeechBox
@onready var cont = $Continue
var line = 0

const start_text = [[
	"Here it is! Gramps's farm!",
	"Still can't believe he's gone. Fit as a fiddle, and just up and dies for no reason. He left this place to me.",
	"Won it in the war, slashed the forest, burned it, and the farm was real good first few years. It got less fertile with time, but he never gave up on it, even with the nightmares.",
	"Bears with glowin’ eyes, he said. Every night. He said it was a curse, but I think it was guilt. I'd feel bad too if I found out some bears accidentally died in the fire I started.",
	"Good animals, bears. Long as you let ‘em be. Wonder if they'll be back in the area so long after the fire…"
	]
	]

const end_text = [[
	"I'm gettin’ on in years, but I'm fitter than I ought to be. I can still take care of the farm, but I'm not sure for how long.",
	"My daughter loves the bears, but her husband's scared of ‘em. They won't take care of the place. Wonder what will happen to the farm and the bears when I'm gone…"
	]
	]

# Called when the node enters the scene tree for the first time.
func _ready():
	line = 0
	if Global.story == 'start':
		Global.current_character = randi_range(1,30)
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
		if line < len(start_text[0])-1:
			line += 1
			box.text = start_text[0][line]
		else:
			Global.story = 'end'
			get_tree().change_scene_to_file('res://Scenes/farm.tscn')

