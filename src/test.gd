extends Node2D

const title_screen_resource : String = "res://assets/scenes/Titlescreen.tscn"
const player_resource : String = "res://assets/scenes/Player.tscn"
const healthbar_resource : String = "res://assets/scenes/healthbar.tscn"

const cutscenes : Array = ["res://assets/scenes/Startscene.tscn",
						   "res://assets/scenes/Cutscene_1.tscn",
						   "res://assets/scenes/Cutscene_2.tscn",
						   "res://assets/scenes/Cutscene_3.tscn",
						   "res://assets/scenes/Endscene.tscn"]

const level_resource_array : Array = ["res://assets/scenes/Rome.tscn",
							  		  "res://assets/scenes/Persia.tscn",
							  		  "res://assets/scenes/WildWest.tscn",
							  		  "res://assets/scenes/Future.tscn"]
@onready var shader_controller : CanvasLayer = $CanvasLayer
var in_cutscene : bool = false
var is_grey : bool = false
var level_counter : int = 0
var cutscene_counter : int = 0
var enter_counter : int = 0
var player : CharacterBody2D
var healthbar : CanvasLayer
var level_node : Node2D
var cutscene_node : Node2D
var corpse : StaticBody2D
var endpoint : StaticBody2D
var current_level : Node2D
var title_screen : CanvasLayer


func _ready() -> void:
	title_screen = load(title_screen_resource).instantiate()
	add_child(title_screen)
	title_screen.load_cutscene.connect(self._load_cutscene)
	shader_controller.shader_effect_finished.connect(self._on_shader_effect_finished)
#	shader_controller.shader_effect_finished.connect(self._on_shader_effect_finished)


func _on_player_death():
	get_tree().paused = true  # Pause the game
	var death_pos : Vector2 = player.position
	if !player.ghost:
		is_grey = true
		# Instantiate corpse scene
		corpse = load("res://assets/scenes/corpse.tscn").instantiate()
		current_level.add_child(corpse)
		
		corpse.on_ghost_entered.connect(self._on_ghost_entered)
		
		player.player_death()
		corpse.position = death_pos
		corpse.set_visible(false)
		
	else:
		is_grey = false
		player.player_reset(true)
		
		

func _death_finished():
	shader_controller.fade_to_black_ghost()


func _ghost_death_finished():
	player.get_node("CanvasLayer").layer = 1
	shader_controller.fade_to_black_ghost()


func _on_ghost_entered():
	get_tree().paused = true
	is_grey = false
	var spawnpos = corpse.position
	player.player_ressurection(spawnpos)
	shader_controller.transition_greyscale(false)
	self.add_child(level_node, true)
	await player.anim_sprite.animation_finished


func _ressurection_finished():
	get_tree().paused = false
	player.can_move = true
	player.health_reset.emit()


func _player_reached_end():
	is_grey = false
	endpoint.player_reached_end.disconnect(self._player_reached_end)
	shader_controller.fade_to_black()


func _load_level(first_load : bool, death : bool = false):
	in_cutscene = false
	if cutscene_node:
		cutscene_node.queue_free()
		cutscene_node = null

	if current_level:
		current_level.queue_free()
		current_level = null
	
	level_node = load(level_resource_array[level_counter]).instantiate()
	current_level = level_node
	level_node.set_meta("_resource_path", level_resource_array[level_counter])
	level_node.z_index = -4096	
	self.add_child(level_node, true)
	endpoint = level_node.get_node("endpoint")
	endpoint.player_reached_end.connect(self._player_reached_end)
	load_healthbar()
	load_player()
	if cutscene_counter:
		shader_controller.unfade_from_black()
		return
	shader_controller.unfade_from_black()
	


func find_direct_child_by_resource(resource_path: String) -> Node:
	for child in get_children():
		if child.has_meta("_resource_path") and child.get_meta("_resource_path") == resource_path:
			return child  # Found the matching child
	return null  # No match found

func _load_cutscene():
	in_cutscene = true
	if current_level:
		current_level.queue_free()
		current_level = null
	else:
		title_screen.queue_free()
	if player:
		player.queue_free()
		player = null
	if healthbar:
		healthbar.queue_free()
		healthbar = null
	cutscene_node = load(cutscenes[cutscene_counter]).instantiate()
	self.add_child(cutscene_node)
	if cutscene_counter == len(cutscenes) - 1:
		get_tree().paused = true
		var cam = cutscene_node.get_node("Camera2D")
		cam.make_current()
		return
	cutscene_node.on_any_key_in_cutscene.connect(self._on_any_key_in_cutscene)
	cutscene_counter += 1
	shader_controller.unfade_from_black()


func load_healthbar():
	if healthbar:
		return
	healthbar = load(healthbar_resource).instantiate()
	add_child(healthbar)


func load_player():
	if !player:  
		player = load(player_resource).instantiate()
		add_child(player)
		player.z_index = 4095
		var player_health_component : Node = player.get_node("PlayerHealthComponent")
		var player_anim : AnimatedSprite2D = player.get_node("CanvasLayer/Control/AnimatedSprite2D")
		player.take_damage.connect(player_health_component._take_damage)
		player.health_reset.connect(player_health_component._health_reset)
		player_anim.death_finished.connect(_death_finished)
		player_anim.ghost_death_finished.connect(_ghost_death_finished)
		player_anim.ressurection_finished.connect(_ressurection_finished)
		player_health_component.play_animation.connect(healthbar._play_animation)
		player_health_component.on_player_death.connect(self._on_player_death)
		var player_cam : Camera2D = player.get_node("Camera2D")
		player_cam.make_current()
	player.position = level_node.get_node("Spawnpoint").position
	player.current_spawn = level_node.get_node("Spawnpoint").position


func _on_shader_effect_finished(anim_name : StringName):
	match anim_name:
		"fade_to_black_ghost":
			player.respawn_player()
			if is_grey:
				shader_controller.unfade_from_black_ghost()
				return
			_load_level(false, true)
			var level_children = current_level.get_children()
			for child in level_children:
				if child.is_in_group("corpse"):
					self.remove_child(child)
			shader_controller.unfade_from_black()
		"unfade_from_black_ghost":
			corpse.set_visible(true)
			get_tree().paused = false
		"fade_to_black":
			if in_cutscene:
				_load_level(false)
				return
			player.player_reset(false)
			level_counter += 1
			_load_cutscene()
		"unfade_from_black":
			get_tree().paused = false

func _on_any_key_in_cutscene():
	shader_controller.fade_to_black()
