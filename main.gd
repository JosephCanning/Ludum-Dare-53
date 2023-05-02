extends Node2D

var life = 6
var hearts = ['Life 1', 'Life 2', 'Life 3']
var full_heart_tex
var half_heart_tex
var empty_heart_tex
var down_stair
var last_level
var player_has_gem
var last_gem_pos
var gem_abandoned = 'none'
var curr_level
var curr_level_instance
var levels = {}
var slain = 0
var score = 0
var max_life = 6
var enemies = {
	'start_level': 1,
	'level2': 6,
	'level3': 6,
	'end_level': 1,
}

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node('/root/Controller').player_hit.connect(_on_player_hit)
	get_node('/root/Controller').enemy_slain.connect(_on_enemy_slain)
	get_node('/root/Controller').change_level.connect(_on_change_level)
	get_node('/root/Controller').got_coin.connect(_on_got_coin)
	get_node('/root/Controller').got_red.connect(_on_got_red)
	get_node('/root/Controller').got_blue.connect(_on_got_blue)
	get_node('/root/Controller').got_green.connect(_on_got_green)
	full_heart_tex = preload('res://assets/heart_ui_full.png')
	half_heart_tex = preload('res://assets/heart_ui_half.png')
	empty_heart_tex = preload('res://assets/heart_ui_empty.png')
	down_stair = preload('res://down_area.tscn')
	
	levels['start_level'] = preload('res://start_level.tscn')
	levels['level2'] = preload('res://level_2.tscn')
	levels['end_level'] = preload('res://end_level.tscn')
	levels['level3'] = preload('res://level_3.tscn')
	
	curr_level = 'start_level'
	curr_level_instance = levels[curr_level].instantiate()
	self.add_child(curr_level_instance)
	
	curr_level_instance.get_node('UpStair').visible = false
	get_node('/root/Controller').is_clear = false
	last_gem_pos = Vector2(283, 138)
	
	$UICanvas/Score.text = 'SCORE 0'
	$UICanvas/HUD/StatusCont/POW.text = 'POW ' + str(get_node('/root/Controller').player_min_power)
	$UICanvas/HUD/StatusCont/SPD.text = 'SPD ' + str(get_node('/root/Controller').player_speed)
	$UICanvas/HUD/StatusCont/ACC.text = 'ACC ' + str(get_node('/root/Controller').player_max_spread)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed('next_map'):
		curr_level = 'end_level'
		_on_change_level(curr_level, 'up')


func _on_got_green():
	get_node('/root/Controller').player_min_power += 20
	get_node('/root/Controller').player_max_spread -= 2
	curr_level_instance.get_node('Player').min_power = get_node('/root/Controller').player_min_power
	curr_level_instance.get_node('Player').max_spread = get_node('/root/Controller').player_max_spread
	$UICanvas/HUD/StatusCont/POW.text = 'POW ' + str(get_node('/root/Controller').player_min_power)
	$UICanvas/HUD/StatusCont/ACC.text = 'ACC ' + str(get_node('/root/Controller').player_max_spread)

func _on_got_blue():
	get_node('/root/Controller').player_speed += 12
	curr_level_instance.get_node('Player').speed = get_node('/root/Controller').player_speed
	print(get_node('/root/Controller').player_speed)
	$UICanvas/HUD/StatusCont/SPD.text = 'SPD ' + str(get_node('/root/Controller').player_speed)


func _on_got_coin():
	score += 1
	$UICanvas/Score.text = 'SCORE ' + str(score)


func _on_got_red():
	if life < max_life:
		if life == max_life - 1:
			life += 1
		else:
			life += 2 
		
		var full_hearts = floor(life / 2)
		var half_heart = false
		var n = 0
		
		for i in 3:
			if full_hearts > 0:
				get_node('UICanvas/HUD/HeartsCont/' + hearts[i]).texture = full_heart_tex
				full_hearts -= 1
				print('full heart')
				continue
			if not half_heart and life % 2 > 0:
				get_node('UICanvas/HUD/HeartsCont/' + hearts[i]).texture = half_heart_tex
				half_heart = true
				print('half heart')
				continue
			else:
				get_node('UICanvas/HUD/HeartsCont/' + hearts[i]).texture = empty_heart_tex
				print('empty heart')


func _on_enemy_slain():
	slain += 1
	print('enemies defeated: ', slain)
	if slain >= enemies[curr_level]:
		print('Level cleared!')
		curr_level_instance.get_node('UpStair').visible = true
		get_node('/root/Controller').is_clear = true


func _on_player_hit():
	life -= 1
	var full_hearts = floor(life / 2)
	var half_heart = false
	var n = 0
	
	for i in max_life / 2:
		if full_hearts > 0:
			get_node('UICanvas/HUD/HeartsCont/' + hearts[i]).texture = full_heart_tex
			full_hearts -= 1
			print('full heart')
			continue
		if not half_heart and life % 2 > 0:
			get_node('UICanvas/HUD/HeartsCont/' + hearts[i]).texture = half_heart_tex
			half_heart = true
			print('half heart')
			continue
		else:
			get_node('UICanvas/HUD/HeartsCont/' + hearts[i]).texture = empty_heart_tex
			print('empty heart')
	
	if life <= 0:
		get_node('/root/Controller').game_over.emit()
		print('Game over!')


func _on_change_level(level, dir):
	print('changing levels...')
	slain = 0
	get_node('/root/Controller').is_clear = false
	player_has_gem = curr_level_instance.get_node('Player').holding_gem
	if not player_has_gem and gem_abandoned == 'none':
		last_gem_pos = curr_level_instance.get_node('Gem').position
		gem_abandoned = curr_level
	last_level = curr_level
	curr_level = level
	get_node('/root/Controller').level = curr_level
	curr_level_instance.queue_free()
	curr_level_instance = levels[curr_level].instantiate()
	self.add_child(curr_level_instance)
	
	if player_has_gem:
		curr_level_instance.get_node('Gem')._on_gem_area_body_entered(curr_level_instance.get_node('Player'))
	
	if dir == 'up':
		get_node('/root/Controller').visited[last_level] = true
		var down = down_stair.instantiate()
		curr_level_instance.add_child(down)
		down.position = curr_level_instance.get_node('Player').position
		down.set_destination(last_level)
		
	if dir == 'down':
		curr_level_instance.get_node('Player').position = curr_level_instance.get_node('UpStair').position
		
	if not player_has_gem:
		if curr_level != gem_abandoned:
			curr_level_instance.get_node('Gem').position = Vector2(-10000, -10000)
		else:
			curr_level_instance.get_node('Gem').position = last_gem_pos
			gem_abandoned = 'none'
	
	
