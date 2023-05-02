extends CharacterBody2D

var pos
var target
var power = 75
var spread = 33
var last_collision = null
var is_ready = false

func init(pos, target):
	self.pos = pos
	self.target = target + Vector2(randi() % spread, randi() % spread)
	self.power = power + (randi() % 21)
	position = pos
	is_ready = true

func _physics_process(delta):
	if is_ready:
		# random values add wiggle/weave effect
		velocity = (target - pos) * Vector2(1 + randf(), 1 + randf())
		velocity = velocity.normalized() * power * (1 + randf())
		last_collision = move_and_collide(velocity * delta)
		if last_collision != null:
			if last_collision.get_collider().name == 'Player':
				print('Hit player!')
				get_node('/root/Controller').player_hit.emit()
			self.queue_free()
