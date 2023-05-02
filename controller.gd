extends Node

signal player_hit
signal change_level
signal game_over
signal game_won
signal enemy_slain
signal map_ready
signal got_coin
signal got_red
signal got_blue
signal got_green
signal got_heart

var is_clear = false
var player_max_spread = 35
var player_min_power = 200
var player_speed = 145
var level = 'start_level'
var visited = {
	'start_level': false,
	'level2': false,
	'level3': false,
	'end_level': false,
}
