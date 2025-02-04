extends Control
@export var first_scene : PackedScene
@onready var anim_sprite = $CenterContainer/VBoxContainer/Skeleton

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_new_game_pressed():
	GameManager.load_next_level(first_scene)
	pass # Replace with function body.


func _on_load_game_pressed():
	GameManager.load_next_level(first_scene)
	pass # Replace with function body.


func _on_quit_pressed():
	get_tree().quit()
	pass # Replace with function body.


func _on_splash_screen_finished():
	$MusicTitleScreen.playing = true
	anim_sprite.play("default")
	pass # Replace with function body.
