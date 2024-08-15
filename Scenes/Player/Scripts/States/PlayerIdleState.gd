extends State
class_name PlayerIdle

@export var animator : AnimationPlayer

func Enter():
	animator.play("Idle")
	pass
	
func Update(_delta : float):
	if(Input.get_vector("MoveLeft", "MoveRight", "MoveUp", "MoveDown").normalized()):
		state_transition.emit(self, "Moving")
		
	#if Input.is_action_just_pressed("Punch")  or Input.is_action_just_pressed("Kick"):
	#	state_transition.emit(self, "Attacking")
	
#func _on_hitbox_body_entered(body):
	#print("teste")
	#if (!attacking):
	#	return

	#if body.is_in_group("Enemy"):
	#	deal_damage(body)
	#	AudioManager.play_sound(AudioManager.PLAYER_ATTACK_HIT, 0, 1)

#func deal_damage(enemy : EnemyMain):
	#hit_particles.emitting = true
	#enemy._take_damage(50)
