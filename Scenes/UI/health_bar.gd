class_name HealthBar extends Node2D

@export var max_health = 6
@export var health = 6

var HeartRacket = load("res://Scenes/UI/HeartRacket.tscn")

var heartsArray = Array()

# Called when the node enters the scene tree for the first time.
func _ready():
	var hearts_number = ceil(max_health / 2)
	health = clamp(health, 0, max_health)
	
	for x in hearts_number:
		var heart := HeartRacket.instantiate() as HeartRacket
		#heart.global_position.x = self.global_position.x + 30 * x
		#heart.global_position.y = self.global_position.y
		heart.position.x = heart.position.x + 30 * x
		add_child(heart)
		heartsArray.push_back(heart)
	
	updateHearts()

func removeHealth(amount):
	health = health - amount
	updateHearts()

func addHealth(amount):
	health = health + amount
	updateHearts()

func updateHearts():
	var hearts_number = ceil(max_health / 2)
	
	for x in hearts_number:
		var heart = heartsArray[x]
		var containerNumber = x + 1
		
		print("health update", health)
		print("container number", containerNumber)
		
		if ceil(health / 2.0) <= (containerNumber - 1):
			heart.change_sprite("empty")
		elif health / 2.0  >= containerNumber:		
			heart.change_sprite("full")
		else:
			heart.change_sprite("half")
