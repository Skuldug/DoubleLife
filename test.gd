extends Node2D



const level_resource_array = ["res://Rome.tscn",
							  "res://Persia.tscn",
							  "res://WildWest.tscn",
							  "res://Future.tscn"]
var player : CharacterBody2D
var healthbar : CanvasLayer
var level_node : Node2D
var enter_counter : int = 0
var corpse : StaticBody2D
var endpoint : StaticBody2D
var level_counter : int = 0

func _ready() -> void:
	# Load and instantiate healthbar
	load_level(true, false)
	healthbar = get_node("Healthbar")

	# Fetch health_display as a child of the instantiated healthbar
	var health_display : AnimatedSprite2D = healthbar.get_node("Control/MarginContainer/HBoxContainer/health_display")
	if health_display == null:
		return  # Prevent further errors

	# Fetch other nodes
	player = $Player
	var player_health_component : Node = get_node("Player/PlayerHealthComponent")

	# Connect signals with checks
	for basic_monster in get_tree().get_nodes_in_group("basic_monster"):
		if !basic_monster.on_player_hit.is_connected(player._on_player_hit): 
			basic_monster.on_player_hit.connect(player._on_player_hit)

	if !player.take_damage.is_connected(player_health_component._take_damage): 
		player.take_damage.connect(player_health_component._take_damage)
		
	if !player.health_reset.is_connected(player_health_component._health_reset): 
		player.health_reset.connect(player_health_component._health_reset)

	if !player_health_component.play_animation.is_connected(healthbar._play_animation):
		player_health_component.play_animation.connect(healthbar._play_animation)
		
	if !player_health_component.on_player_death.is_connected(self._on_player_death):
		player_health_component.on_player_death.connect(self._on_player_death)
	
	player.position = level_node.get_node("Spawnpoint").position
	player.current_spawn = level_node.get_node("Spawnpoint").position
	
func _on_player_death():
	get_tree().paused = true  # Pause the game

	var death_pos : Vector2 = player.position

	if !player.ghost:
		# Instantiate corpse scene
		corpse = load("res://corpse.tscn").instantiate()
		self.add_child(corpse)
		
		corpse.on_ghost_entered.connect(self._on_ghost_entered)
		
		player.player_death()
		# Set the corpse position to where the player died
		corpse.position = death_pos
		corpse.set_visible(false)  # Hide the corpse initially

		# Call player death logic (maybe play an animation or other logic)
		

		# Wait until the death animation finishes
		healthbar.grey_blackout()
		await player.anim_sprite.animation_finished  # This listens for the animation to finish
		
		# Show the corpse after animation is finished
		corpse.set_visible(true)
	else:
		if player.ghost:
			healthbar.ungrey_blackout()
		player.player_reset()
		load_level(false, true)
		var nodes = self.get_children()
		for node in nodes:
			if node.is_in_group("corpse"):
				self.remove_child(node)
	# Resume the game after animation is done
	get_tree().paused = false  # Unpause the game

func _on_ghost_entered():
	var spawnpos = corpse.position
	player.player_ressurection(spawnpos)
	healthbar.set_greyscale(false)
	self.add_child(level_node, true)
	await player.anim_sprite.animation_finished

func _player_reached_end():
	endpoint.player_reached_end.disconnect(self._player_reached_end)
	if player.ghost:
		healthbar.ungrey_blackout()
	else:
		healthbar.fade_black()
	player.player_reset()
	level_counter += 1
	load_level(false, false)
	if level_counter != 4:
		endpoint.player_reached_end.connect(self._player_reached_end)
	
func load_level(first_load : bool, death : bool,):
	if level_counter == 4:
		var end = load("res://Endscene.tscn").instantiate()
		end.z_index = -10000
		self.add_child(end, true)
		var cam = end.get_node("Camera2D")
		cam.make_current()
		return
	if !first_load and level_counter or death:
		var current_level = find_direct_child_by_resource(level_resource_array[level_counter if death else level_counter - 1])
		current_level.queue_free()
		print("removed current level from scene tree")
	level_node = load(level_resource_array[level_counter]).instantiate()
	level_node.set_meta("_resource_path", level_resource_array[level_counter])
	level_node.z_index = -999	
	self.add_child(level_node, true)
	endpoint = level_node.get_node("endpoint")
	endpoint.player_reached_end.connect(self._player_reached_end)
	if !first_load and level_counter or death:
		healthbar.fade_black()
		healthbar.fade_black_ghost()
		player.position = level_node.get_node("Spawnpoint").position
		player.current_spawn = level_node.get_node("Spawnpoint").position
	
func find_direct_child_by_resource(resource_path: String) -> Node:
	for child in get_children():
		if child.has_meta("_resource_path") and child.get_meta("_resource_path") == resource_path:
			return child  # Found the matching child
	return null  # No match found
