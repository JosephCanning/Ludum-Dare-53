extends CharacterBody2D

var target
var player_overlap = false
var player_in_range = false
var range = 500
var anchor
var speed = 28
var base_radius = 12
var path
var path_step

func _ready():
	anchor = position
	path = []
	path_step = 0
	speed += speed + (randi() % 12)
	base_radius += base_radius + (randi() % 7)
	var radius
	var theta
	for i in 10:
		radius = base_radius * sqrt(randf())
		theta = randf() * TAU
		var px = anchor.x + radius * cos(theta)
		var py = anchor.y + radius * sin(theta)
		path.append(Vector2(px, py))

func _physics_process(delta):
	var vec_to_player = get_parent().get_node('Player').position - position
	player_in_range = false
	
	if vec_to_player.length() < range:
		$OrbSkeletonVision.target_position = vec_to_player
		if $OrbSkeletonVision.is_colliding():
			if $OrbSkeletonVision.get_collider().name == 'Player':
				player_in_range = true
	
	if player_in_range:
		velocity = path[path_step] - position
		velocity = velocity.normalized() * speed
		move_and_slide()
		if abs(position.x - path[path_step].x) < 1 and abs(position.y - path[path_step].y) < 1:
			path_step += 1
		if path_step == len(path):
			path_step = 0

# Start firing at player
func _on_orb_skeleton_range_body_entered(body):
	if body.name == 'Player':
		print('entered range')
		target = body
		$SkeletonOrbTimer.start()

# Stop firing at player only when they leave circle
func _on_orb_skeleton_range_body_exited(body):
	var overlaps = $OrbSkeletonRange.get_overlapping_areas()
	player_overlap = false
	for i in overlaps:
		if i.name == 'PlayerDetect':
			player_overlap = true
	if not player_overlap and body.name == 'Player':
		print('left range')
		$SkeletonOrbTimer.stop()

# Fire orb
func _on_skeleton_orb_timer_timeout():
	if player_in_range and randf() >= 0.5:
		var orb = load('res://orb.tscn').instantiate()
		orb.init(position, target.position)
		get_parent().add_child(orb)
