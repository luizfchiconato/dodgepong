class_name BowlingBall extends Area2D

@export var speed = 150
var velocity = Vector2.ZERO
var target_pos = Vector2.ZERO

var converted = false
var previousConverted = false
var explodable = true

var explodingBowlingBallsQuantity = 10

var BowlingBall = load("res://Scenes/BowlingBall/BowlingBall.tscn")
var Player = load("res://Scenes/Player/Player.tscn")
@onready var arch_body = $Body

@onready var anim_sprite = $AnimatedSprite2D
@onready var anim_sprite_2 = $Body/AnimatedSprite2D2
@onready var explosion_radius = $ExplosionRadius

@onready var anim_bomb = $ExplosionRadius/AnimatedSprite2D
@onready var radius_bomb = $ExplosionRadius/MeshInstance2D
@export var bomb_animator : AnimationPlayer

@export var fake_gravity = 10
@export var ground_velocity : Vector2
@export var vertical_velocity : float

var arcHeight = RandomNumberGenerator.new().randf_range(175, 225)
var duration = RandomNumberGenerator.new().randf_range(1.50, 2)

var t = 0.0

var isGrounded = false

var initial_position
var end_position

#@export var animator : AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	anim_sprite.play("default")
	anim_sprite_2.play("default")
	
	var player = get_tree().get_first_node_in_group("Player") as CharacterBody2D
	
	
	if (velocity == Vector2.ZERO):
		var target_pos = player.global_position
		self.rotation = target_pos.angle()
		
		var x_entropy = RandomNumberGenerator.new().randf_range(-50, 50)
		var y_entropy = RandomNumberGenerator.new().randf_range(-50, 50)
		
		initial_position = self.global_position
		end_position = Vector2(target_pos.x + x_entropy, target_pos.y + y_entropy)
		speed = initial_position.distance_to(end_position) / duration
		
		velocity = self.global_position.direction_to(end_position)
		
		explosion_radius.global_position = end_position

func initialize(groundVelocity, verticalVelocity):
	self.groundVelocity = groundVelocity
	self.verticalVelocity = verticalVelocity

func _physics_process(delta):
	explosion_radius.global_position = end_position
	vertical_velocity += fake_gravity * delta
	self.global_position += velocity * speed * delta
	#arch_body.position += Vector2(0, vertical_velocity) * delta
	t += delta / duration
	arch_body.global_position = _quadratic_bezier(initial_position, Vector2(initial_position.x, initial_position.y - arcHeight), end_position, t)
	
	check_ground_hit()
	
	if converted and !previousConverted:
		previousConverted = true
		$CPUParticles2D.set_color("#4ed4c2")
		$Sprite2D.texture = load("res://Art/Sprites/ball_converted.png")

func check_ground_hit():
	if (self.global_position.y < arch_body.global_position.y):
		radius_bomb.visible = false
		anim_sprite.visible = false
		anim_sprite_2.visible = false
		#AudioManager.play_sound(AudioManager.BOWLING_FALL, 0, -20)
		bomb_animator.play("exploding")
		await bomb_animator.animation_finished
		queue_free()

func _quadratic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, t: float):
	var q0 = p0.lerp(p1, t)
	var q1 = p1.lerp(p2, t)
	var r = q0.lerp(q1, t)
	return Vector2(self.global_position.x, r.y)

#Connect and deal damage to the player
func deal_damage_to_player(player : PlayerMain):
	if !player.attacking:
		player._take_damage(6)

func deal_damage_to_enemy(enemy : EnemyMain):
	enemy._take_damage(15)

func createBowlingBalls():
	for i in range(explodingBowlingBallsQuantity):
		var angle = i * (360 / explodingBowlingBallsQuantity)
		createBowlingBall(angle)

func createBowlingBall(angle: float):
	angle = deg_to_rad(angle)
	
	var bowlingBall: BowlingBall = duplicate()
	bowlingBall.global_position = global_position
	bowlingBall.velocity = -self.velocity
	bowlingBall.velocity = bowlingBall.velocity.rotated(angle)
	bowlingBall.set_as_top_level(true)
	bowlingBall.explodable = false
	bowlingBall.scale.x = 0.2
	bowlingBall.scale.y = 0.2
	get_tree().root.add_child(bowlingBall)

#func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
#	if !(body is TileMap):
#		return

#	#if (explodable and !converted):
#	#	createBowlingBalls()
#	queue_free()


func _on_explosion_radius_body_entered(body):
	if body.is_in_group("Player") and !converted:
		var player = get_tree().get_first_node_in_group("Player") as PlayerMain
		if player.is_dashing():
			return
		deal_damage_to_player(body)
	if body.is_in_group("Enemy") and converted:
		deal_damage_to_enemy(body)
