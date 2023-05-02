extends CharacterBody2D

signal has_thrown_gem

var speed = 145
var throw_power
var min_power = 200
var max_power = 500
var throw_spread
var max_spread = 35
var power_gain = 2.33
var spread_loss = 0.15
var last_anim = 'down'
var holding_gem = false
var can_attack = true

# Called when the node enters the scene tree for the first time.
func _ready():
#	self.position = Vector2(25, 25)
	$PlayerSprite.animation = last_anim
	get_parent().get_node('Gem').has_been_grabbed.connect(_on_gem_has_been_grabbed)
#	max_spread = get_node('/root/Controller').player_max_spread
#	min_power = get_node('/root/Controller').player_min_power
	throw_power = min_power
	throw_spread = max_spread

func _process(delta):
	if holding_gem:
		if Input.is_action_pressed('throw'):
			throw_power += power_gain
			if throw_spread - spread_loss >= 0:
				throw_spread -= spread_loss
		if Input.is_action_just_released('throw') or throw_power + power_gain > max_power:
			var throw_dir = get_global_mouse_position() - position
			has_thrown_gem.emit(position, throw_dir, throw_power, throw_spread)
			holding_gem = false
			last_anim = last_anim.rsplit('_')[0]
			throw_power = min_power
			throw_spread = max_spread
	if Input.is_action_just_released("activate"):
		print(get_parent().local_to_map(Node2D.new().to_local(position)))

func _physics_process(delta):
	var dir_vector = Vector2.ZERO
	$UpBox.disabled = true
	$DownBox.disabled = true
	$LeftBox.disabled = true
	$RightBox.disabled = true
	
	if 'up' in last_anim:
		$UpBox.disabled = false
	if 'down' in last_anim:
		$DownBox.disabled = false
	if 'left' in last_anim:
		$LeftBox.disabled = false
	if 'right' in last_anim:
		$RightBox.disabled = false
	
	if holding_gem or not Input.is_action_pressed('attack'):
		if Input.is_action_pressed('move_up'):
			dir_vector.y -= 1
			last_anim = 'up'
			$UpBox.disabled = false
		if Input.is_action_pressed('move_down'):
			dir_vector.y += 1
			last_anim = 'down'
			$DownBox.disabled = false
		if Input.is_action_pressed('move_left'):
			dir_vector.x -= 1
			if 'right' in last_anim:
				position.x += 2
			last_anim = 'left'
			$LeftBox.disabled = false
		if Input.is_action_pressed('move_right'):
			dir_vector.x += 1
			if 'left' in last_anim:
				position.x -= 2
			last_anim = 'right'
			$RightBox.disabled = false
		if holding_gem and 'gem' not in last_anim:
			last_anim = last_anim + '_gem'
		$PlayerSprite.animation = last_anim
	
	if not holding_gem:
		if Input.is_action_just_pressed('attack'):
			$PlayerSprite.animation = last_anim + '_attack'
		
		if Input.is_action_just_released('attack'):
			$PlayerSprite.animation = last_anim
	
	velocity = dir_vector.normalized() * speed
	move_and_slide()



func _on_gem_has_been_grabbed():
	holding_gem = true
