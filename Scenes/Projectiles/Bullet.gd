class_name Bullet extends Area2D

@export var speed = 150
var velocity = Vector2.ZERO
var target_pos = Vector2.ZERO

var converted = false
var previousConverted = false
var explodable = true

var explodingBulletsQuantity = 15

const Bullet = preload("res://Scenes/Projectiles/Bullet.tscn")
var Player = preload("res://Scenes/Player/Player.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var player = get_tree().get_first_node_in_group("Player") as CharacterBody2D
	
	if (velocity == Vector2.ZERO):
		var target_pos = player.global_position
		self.rotation = target_pos.angle()
		velocity = self.global_position.direction_to(target_pos)

func _physics_process(delta):
	self.global_position += velocity * speed * delta
	
	if converted and !previousConverted:
		previousConverted = true
		$CPUParticles2D.set_color("#4ed4c2")
		$Sprite2D.texture = load("res://Art/Sprites/ball_converted.png")

func _on_body_entered(body):
	if body.is_in_group("Player") and !converted:
		var player = get_tree().get_first_node_in_group("Player") as CharacterBody2D
		if player.is_dashing():
			return
		deal_damage_to_player(body)
		queue_free()		
	if body.is_in_group("Enemy") and converted:
		deal_damage_to_enemy(body)
		queue_free()

#Connect and deal damage to the player
func deal_damage_to_player(player : PlayerMain):
	if !player.attacking:
		player._take_damage(6)

func deal_damage_to_enemy(enemy : EnemyMain):
	enemy._take_damage(15)

func createBullets():
	for i in range(explodingBulletsQuantity):
		var angle = i * (360 / explodingBulletsQuantity)
		createBullet(angle)

func createBullet(angle: float):
	angle = deg_to_rad(angle)
	
	var bullet: Bullet = duplicate()
	bullet.global_position = global_position
	bullet.velocity = -self.velocity
	bullet.velocity = bullet.velocity.rotated(angle)
	bullet.set_as_top_level(true)
	bullet.explodable = false
	bullet.scale.x = 0.2
	bullet.scale.y = 0.2
	get_tree().root.add_child(bullet)

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if !(body is TileMap):
		return

	if (explodable and !converted):
		createBullets()
	queue_free()
