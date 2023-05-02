extends Node2D

var destination
var is_inactive = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$Cooldown.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func set_destination(level):
	destination = level

func _on_down_area_area_entered(area):
	if not is_inactive and area.name == 'PlayerDetect':
		print('Going down')
		get_node('/root/Controller').change_level.emit(destination, 'down')
	print('Patience...')


func _on_cooldown_timeout():
	print('Down stair is active')
	$Cooldown.stop()
	is_inactive = false
