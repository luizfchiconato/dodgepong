extends State
class_name PlayerWalking

@onready var dashParticles = $DashParticles as CPUParticles2D
@onready var sprite = $Player/AnimatedSprite2D as AnimatedSprite2D

@export var movespeed := int(350)
@export var dash_max := int(400)
var dashspeed := int(100)
var can_dash := bool(true)
var dash_direction := Vector2(0,0)
var is_dashing = false

var player : CharacterBody2D
@export var animator : AnimationPlayer


func Enter():
	player = get_tree().get_nodes_in_group("Player")[0] 
	animator.play("Walk")

func Update(delta : float):
	var input_dir = Input.get_vector("MoveLeft", "MoveRight", "MoveUp", "MoveDown").normalized()

	Move(input_dir)
	#LessenDash(delta)
	

	if(Input.is_action_just_pressed("Dash") && can_dash):
		start_dash(input_dir)
		AudioManager.play_sound(AudioManager.DASH, 0, -20)
		
	#if Input.is_action_just_pressed("Punch") or Input.is_action_just_pressed("Kick"):
	#	Transition("Attacking")
	
func Move(input_dir):
	#Suddenly turning mid dash
	#if(dash_direction != Vector2.ZERO and dash_direction != input_dir):
		#dashspeed = 0
		#endDash()

	player.velocity = input_dir * movespeed + dash_direction * dashspeed 
	player.move_and_slide()
	dashParticles.global_position = player.global_position

	if(input_dir.length() <= 0):
		Transition("Idle")

func start_dash(input_dir):
	dash_direction = input_dir.normalized()
	dashspeed = dash_max
	animator.play("Dash")
	can_dash = false
	is_dashing = true
	dashParticles.emitting = true
	$DashTimer.start()
	#sprite.set_self_modulate(Color.DARK_BLUE)

#We cannot allow a transition before the dash is complete and the animation has stopped playing
func Transition(newstate):
	if(is_dashing == false):
		state_transition.emit(self, newstate)


func _on_dash_timer_timeout():
	$DashTimer.stop()
	endDash()



func endDash():
	dashParticles.emitting = false
	is_dashing = false
	$DashTimeout.start()
	dash_direction = Vector2.ZERO
	
	if(animator.current_animation == "Dash"):
		await animator.animation_finished
		animator.play("Walk")


func _on_dash_timeout_timeout():
	$DashTimeout.stop()
	can_dash = true
