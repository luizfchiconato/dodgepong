extends CharacterBase
class_name PlayerMain

@onready var fsm = $FSM as FiniteStateMachine
@onready var moving = $FSM/Moving as State
@onready var animatedSprite = $AnimatedSprite2D as AnimatedSprite2D
@onready var racketPivot = $AnimatedSprite2D/RacketPivot as Node2D
@onready var trail = $AnimatedSprite2D/RacketPivot/Racket/Marker2D/Trail2D as Line2D
@onready var racketParticles = $AnimatedSprite2D/RacketPivot/Racket/Particles as CPUParticles2D
@onready var hitbox = $AnimatedSprite2D/Hitboxes/Racket_Hitbox as Node2D
@onready var hitboxShape = $AnimatedSprite2D/Hitboxes/Racket_Hitbox/hitboxShape as CollisionShape2D
@onready var racketAnimator = $AnimatedSprite2D/RacketPivot/Racket/Animation as AnimatedSprite2D

const DEATH_SCREEN = preload("res://Scenes/DeathScreen.tscn")

var attacking = false
var attackFrame = 0
const attackFrames = 10

var hitInAttack = false
var canAttack = true

func _physics_process(delta: float) -> void:
	turn()

	if (attackFrame > attackFrames):
		deactivateAttack()
		attackFrame = 0
		hitboxShape.disabled = true
	elif (attacking):
		attackFrame += 1
	elif (Input.is_action_just_pressed("Punch")  or Input.is_action_just_pressed("Kick")) and canAttack:
		attack()
	
	if attacking == true:
		racketPivot.rotation += 20 * delta
		#trail.visible = true
		if racketParticles.amount != 1200:
			racketParticles.amount = 1200
			racketParticles.spread = 50
	else:
		hitbox.rotation = getRacketAngle() - 90
		racketPivot.rotation = getRacketAngle()
		#trail.visible = false
		if racketParticles.amount != 30:
			racketParticles.amount = 30
			racketParticles.spread = 23

func turn():
	#var direction = -1 if flipped_horizontal == true else 1
	if(getAngleDegrees() > -90 and getAngleDegrees() < 90):
		sprite.scale.x = 1
	else:
		sprite.scale.x = -1

func getAngle():
	var player_pos = self.global_position
	var mouse_pos = get_global_mouse_position()
	var angle = player_pos.angle_to_point(mouse_pos)
	return angle

func isToLeft():
	return getAngleDegrees() > -90 and getAngleDegrees() < 90

func getAngleDegrees():
	return rad_to_deg(getAngle())

func getRacketAngle():
	if (isToLeft()):
		return getAngle() + 90
	return -(getAngle() + 90)

func attack():
	racketPivot.rotation = getRacketAngle() - 90
	hitbox.rotation = getRacketAngle() - 90
	hitboxShape.disabled = false
	
	attacking = true
	AudioManager.play_sound(AudioManager.PLAYER_ATTACK_SWING, 0.3, 1)
	
func _on_hitbox_body_entered(body):
	if (!attacking):
		return

	if body is Bullet:
		hitInAttack = true
		reflectBullet(body)
	
	if body is BowlingBall:
		hitInAttack = true
		reflectBowlingBall(body)

func reflectBullet(body):
	if (!body.converted):
		body.velocity = -body.velocity * 1.5
		body.converted = true
		frameFeeze(0.05, 0.5)
		AudioManager.play_sound(AudioManager.PLAYER_ATTACK_HIT, 4, 5, 0.7)

func reflectBowlingBall(body):
	if (!body.converted and body.can_deflect):
		body.converted = true
		frameFeeze(0.05, 0.5)
		AudioManager.play_sound(AudioManager.PLAYER_ATTACK_HIT, 4, 5, 0.4)

	#if body.is_in_group("Enemy"):
	#	#frameFeeze(0.05, 0.9)
	#	deal_damage(body)
	#	print("blaa")
		

func _take_damage(amount):
	if(is_dashing() || invincible == true || is_dead == true):
		return
		
	health -= amount
	healthbar.value = health;
	damage_effects()
	
	$HealthBar.removeHealth(amount)
	
	AudioManager.play_sound(AudioManager.PLAYER_HURT, 0, 0)
	
	if(health <= 0):
		_die()

func is_dashing():
	return moving.is_dashing

func deal_damage(enemy : EnemyMain):
	hit_particles.emitting = true
	enemy._take_damage(50)

func _die():
	super() #calls _die() on base-class CharacterBase
	
	fsm.force_change_state("Die")
	var death_scene = DEATH_SCREEN.instantiate()
	add_child(death_scene)

func frameFeeze(timeScale, duration):
	Engine.time_scale = timeScale
	await get_tree().create_timer(duration * timeScale).timeout
	Engine.time_scale = 1

func activateAttack():
	canAttack = true
	racketParticles.visible = true
	trail.visible = true
	racketAnimator.play("Default")
	
func deactivateAttack():
	attacking = false
	if (!hitInAttack):
		canAttack = false
		$AttackTimeout.start()
		racketParticles.visible = false
		racketAnimator.play("Deactivated")
		trail.visible = false
	hitInAttack = false

func _on_attack_timeout_timeout():
	activateAttack()
