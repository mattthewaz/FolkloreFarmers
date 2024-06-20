extends Node2D

@onready var portrait = $Portrait
@onready var box = $SpeechBox
@onready var cont = $Continue
var line = 0

const text0 = [
	"Here it is! Gramps's farm!",
	"Still can't believe he's gone. Fit as a fiddle, and just up and dies for no reason. He left this place to me.",
	"Won it in the war, slashed the forest, burned it, and the farm was real good first few years. It got less fertile with time, but he never gave up on it, even with the nightmares.",
	"Bears with glowin’ eyes, he said. Every night. He said it was a curse, but I think it was guilt. I'd feel bad too if I found out some bears accidentally died in the fire I started.",
	"Good animals, bears. Long as you let ‘em be. Wonder if they'll be back in the area so long after the fire…"
	]


# Called when the node enters the scene tree for the first time.
func _ready():
	var image = Image.load_from_file("res://sprites/Portraits/farmer_maybe" + str(randi_range(1,30)) + ".png")
	portrait.texture = ImageTexture.create_from_image(image)
	line = 0
	box.text = text0[line]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_continue_pressed():
	if line < len(text0)-1:
		line += 1
		box.text = text0[line]
	else:
		get_tree().change_scene_to_file('res://Scenes/farm.tscn')
