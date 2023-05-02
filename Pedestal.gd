extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pedestal_area_area_entered(area):
	if area.name == 'PlayerDetect' and area.get_parent().holding_gem:
		print('You win!')
		$PedestalSprite.animation = 'win'
		get_parent().get_node('Gem').position = Vector2(-10000, -10000)
		get_parent().get_node('Player').holding_gem = false
		$WinTimer.start()



func _on_pedestal_area_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.name == 'Gem':
		print('You win in style!')
		$PedestalSprite.animation = 'win'
		get_parent().get_node('Gem').position = Vector2(-10000, -10000)
		$WinTimer.start()


func _on_win_timer_timeout():
	get_node('/root/Controller').game_won.emit()
