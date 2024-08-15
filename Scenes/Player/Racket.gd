extends Node2D
@onready var animation_player := $Animation as AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("Default")
	pass # Replace with function body.

#func _process(delta: float) -> void:
	#%Trail2D.length = 5

#func _physics_process(delta: float) -> void:
	#$Marker2D.global_position = self.global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	$Marker2D.global_position = get_global_mouse_position()
