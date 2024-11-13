extends CharacterBase
class_name EnemyMain

@onready var fsm = $FSM as FiniteStateMachine
var player_in_range = false
var rng = RandomNumberGenerator.new()

@export var attack_node : Node
@export var chase_node : Node

@export var bullet_interval: float = 2

@export_enum("Normal:0", "Bowling:1") var enemy_type: int

const TYPE_NORMAL = 0
const TYPE_BOWLING = 1

var Bullet = load("res://Scenes/Projectiles/Bullet.tscn")
var BowlingBall = load("res://Scenes/BowlingBall/BowlingBall.tscn")

#After finishing an attack, we return here to determine our next action based on the players proximity
func finished_attacking():
	if(player_in_range == true):
		fsm.change_state(attack_node, "enemy_chase_state")
	else:
		fsm.change_state(attack_node, "enemy_idle_state")

#Register player proximity, start chasing if we are idling when the player gets close
func _on_detection_area_body_entered(body):
	if body.is_in_group("Player"):
		player_in_range = true
		#We don't want this to happen from the death state, only from idle
		if fsm.current_state.name == "enemy_idle_state": 
			fsm.force_change_state("enemy_chase_state")

#Return to idle when player leaves our proximity
func _on_detection_area_body_exited(body):
	if body.is_in_group("Player"):
		player_in_range = false
		fsm.change_state(chase_node, "enemy_idle_state")
		
func _die():
	super() #calls _die() on base-class CharacterBase
	fsm.force_change_state("enemy_death_state")

func _take_damage(amount):
	if(invincible == true || is_dead == true):
		return
		
	health -= amount
	healthbar.value = health;
	damage_effects()
	
	if(health <= 0):
		_die()
	
func _ready():
	$BulletTimer.wait_time = bullet_interval

func _on_bullet_timer_timeout():
	createBullet()
	var my_random_number

	if (enemy_type == TYPE_BOWLING):
		my_random_number = rng.randf_range(1.5, 2.75)
	else:
		my_random_number = rng.randf_range(1.5, 2)

	$BulletTimer.wait_time = my_random_number
	$BulletTimer.start()
	return true

func createBullet():
	if (enemy_type == TYPE_BOWLING):
		createBowlingBall()
	else:
		createDefaultBall()
	
func createBowlingBall():
	var bullet := BowlingBall.instantiate() as BowlingBall
	bullet.global_position = global_position
	# bullet.ground_velocity = Vector2(100, 120)
	bullet.vertical_velocity = 10
	bullet.set_as_top_level(true)
	get_tree().root.add_child(bullet)
	
func createDefaultBall():
	var bullet := Bullet.instantiate() as Bullet
	bullet.global_position = global_position
	bullet.set_as_top_level(true)
	get_tree().root.add_child(bullet)
