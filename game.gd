extends Node

var load_game
var main_game

# Called when the node enters the scene tree for the first time.
func _ready():
	$MainMenu/PlayButton.visible = false
	$MainMenu/PlayButton.disabled = true
	$GameOver.visible = false
	$GameOver/PlayButton.disabled = true
	$GameWon.visible = false
	$GameWon/PlayButton.disabled = true
	get_node('/root/Controller').game_over.connect(_on_game_over)
	get_node('/root/Controller').game_won.connect(_on_game_won)
	load_game = preload('res://main.tscn')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_play_button_button_down():
	if main_game != null:
		main_game.queue_free()
	main_game = load_game.instantiate()
	self.add_child(main_game)
	$MainMenu/PlayButton.disabled = true
	$MainMenu.visible = false
	$GameOver.visible = false
	$GameOver/PlayButton.disabled = true
	$GameWon.visible = false
	$GameWon/PlayButton.disabled = true


func _on_game_over():
	main_game.queue_free()
	$GameOver.visible = true
	$GameOver/PlayButton.disabled = false
	


func _on_game_won():
	print('The end...')
	main_game.queue_free()
	$GameWon.visible = true
	$GameWon/PlayButton.disabled = false


func _on_accept_button_button_down():
	$MainMenu/AcceptButton.visible = false
	$MainMenu/AcceptButton.disabled = true
	$MainMenu/Blurb.visible = false
	$MainMenu/Title.visible = true
	$MainMenu/PlayButton.disabled = false
	$MainMenu/PlayButton.visible = true
