extends CharacterBody2D

signal has_been_grabbed

var is_carried = false
var is_thrown = false
var move_dir
var power
var last_collision = null

func _ready():
	get_parent().get_node('Player').has_thrown_gem.connect(_on_player_has_thrown_gem)


func _physics_process(delta):
	if is_thrown:
		velocity = move_dir.normalized() * power
		last_collision = move_and_collide(velocity * delta)
		if last_collision != null:
			print('Gem collided')
			if 'OrbSkeleton' in last_collision.get_collider().name:
				print('Hit skeleton!')
				last_collision.get_collider().queue_free()
				get_node('/root/Controller').enemy_slain.emit()
			last_collision = null
			is_thrown = false


func _on_player_has_thrown_gem(player_pos, throw_dir, throw_power, throw_spread):
	print('Gem thrown! Power = ', throw_power)
	position = player_pos
	print(roundi(throw_spread))
	move_dir = throw_dir + Vector2(randi() % roundi(throw_spread), randi() % roundi(throw_spread))
	power = throw_power
	show()
	is_thrown = true
	is_carried = false


func _on_gem_area_body_entered(body):
	if not is_thrown:
		if not is_carried and body.name == 'Player':
			hide()
			is_carried = true
			has_been_grabbed.emit()
