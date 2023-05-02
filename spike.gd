extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_spike_timer_timeout():
	get_node('/root/Controller').player_hit.emit()
	print('Spiked!')


func _on_spike_area_area_entered(area):
	if area.name == 'PlayerDetect':
		get_node('/root/Controller').player_hit.emit()
		print('Spiked!')
		$SpikeTimer.start()
		$SpikeSprite.animation = 'blood'


func _on_spike_area_area_exited(area):
	if area.name == 'PlayerDetect':
		$SpikeTimer.stop()
