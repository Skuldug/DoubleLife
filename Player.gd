extends CharacterBody2D


const SPEED = 300.0
const DEFAULT_FRAMES = 60

var player_health_component = null 

func _physics_process(delta: float) -> void:
	
	# gets input from user on x axis, where A is the negative direction, D is the positive direction, and is 0 otherwise
	var x_direction := Input.get_axis("player_left", "player_right")
	# gets input from user on y axis, where W is the negative direction, S is the positive direction, and is 0 otherwise
	var y_direction := Input.get_axis("player_up", "player_down")
	if x_direction or y_direction:
		velocity.x = x_direction * SPEED * DEFAULT_FRAMES * delta 
		velocity.y = y_direction * SPEED * DEFAULT_FRAMES * delta
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	
	move_and_slide()
	player_health_component.check_health(delta)

	
func set_component(component : Node) -> void:
	player_health_component = component
	
