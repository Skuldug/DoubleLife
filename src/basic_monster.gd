extends CharacterBody2D

class_name basic_monster

signal on_player_hit(damage : int)
var run_speed = 25
var health = 10
var target = null
@export var damage = 500
@onready var melee_component : Area2D = %MeleeComponent
@onready var detect_component : Area2D = %detect_component

func _ready() -> void:
	melee_component.damage = damage

func _physics_process(delta) -> void:
	velocity = Vector2.ZERO
	if target:
		velocity = position.direction_to(target.position) * run_speed * delta 
	move_and_collide(velocity)
	
func player_hit(damage : int) -> void:  
	on_player_hit.emit(damage)

func found_player(player : Node):
	target = player
