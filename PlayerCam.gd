extends Camera2D

var bounds
var view

# Called when the node enters the scene tree for the first time.
func _ready():
	self.make_current()
	bounds = get_parent().get_used_rect()
	print(get_parent().name, ': ', bounds)
	limit_left = bounds.position.x * 24
	limit_top = bounds.position.y * 24
	limit_bottom = bounds.size.y * 24
	limit_right = (bounds.size.x + bounds.position.x) * 24
	
	self.position = get_parent().get_node('Player').position
	position_smoothing_enabled = true
	position_smoothing_speed = 14.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position = get_parent().get_node('Player').position


func _on_world_map_ready():
	pass
#	bounds = get_parent().get_used_rect()
#	print('WorldMap ready')
#	print(bounds)
#	limit_left = bounds.position.x
#	limit_top = bounds.position.y
#	limit_bottom = bounds.size.y * 24
#	limit_right = bounds.size.x * 24
