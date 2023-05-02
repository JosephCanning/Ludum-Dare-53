extends Node2D

@export var destination: String
var is_inactive = true

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	$Cooldown.start()
	if get_node('/root/Controller').visited[get_node('/root/Controller').level] == true:
		show()
		get_node("/root/Controller").is_clear = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_up_area_area_entered(area):
	if not is_inactive and area.name == 'PlayerDetect' and get_node("/root/Controller").is_clear:
		get_node('/root/Controller').change_level.emit(destination, 'up')


func _on_timer_timeout():
	$Cooldown.stop()
	is_inactive = false
