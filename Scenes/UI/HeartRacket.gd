class_name HeartRacket extends Node2D

@onready var anim_sprite = $AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	anim_sprite.play("full")
	pass # Replace with function body.

func change_sprite(anim):
	anim_sprite.play(anim)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
