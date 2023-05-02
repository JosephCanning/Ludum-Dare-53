extends Node2D

var is_disabled = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_node('/root/Controller').visited[get_node('/root/Controller').level] == true:
		hide()
		is_disabled = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_bp_area_area_entered(area):
	if not is_disabled and area.name == 'PlayerDetect':
		get_node('/root/Controller').got_blue.emit()
		print('blue')
		hide()
		is_disabled = true
