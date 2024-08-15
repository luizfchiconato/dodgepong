extends CharacterBase
class_name EnemyMain

@onready var fsm = $FSM as FiniteStateMachine
var player_in_range = false

@export var attack_node : Node
@export var chase_node : Node

@export var bullet_interval: float = 2

const Bullet = preload("res://Scenes/Projectiles/Bullet.tscn")

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
	$BulletTimer.start()
	return true

func createBullet():
	var bullet := Bullet.instantiate() as Bullet
	bullet.global_position = global_position
	bullet.set_as_top_level(true)
	get_tree().root.add_child(bullet)
