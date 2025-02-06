extends Node2D

@export var next_scene : PackedScene

var death_number = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_enemy_died():
	for child in get_children():
		for grandson in child.get_children():
			if grandson is EnemyMain:
				grandson.increment_death_number()
	
	var allDied = true
	for child in get_children():
		for grandson in child.get_children():
			if grandson is EnemyMain:
				allDied = false
	
	if (allDied == true):
		GameManager.load_next_level(next_scene)
		
