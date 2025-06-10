extends Node2D

var elapsed_time := 0.0
var game_finished := false

@onready var timer_label: Label = $TimerLabel
@onready var game_timer: Timer = $GameTimer

func _ready():
	game_timer.start()

func _process(delta):
	if not game_finished:
		elapsed_time += delta
		var minutes = int(elapsed_time) / 60
		var seconds = int(elapsed_time) % 60
		if timer_label:
			timer_label.text = "%02d:%02d" % [minutes, seconds]

func finish_game():
	if not game_finished:
		game_finished = true
		game_timer.stop()
		var minutes = int(elapsed_time) / 60
		var seconds = int(elapsed_time) % 60
		if timer_label:
			timer_label.text += ""
		print("Player finished in: %02d:%02d" % [minutes, seconds])

		# Show the completion screen
		show_completion_screen()

func show_completion_screen():
	var completion_scene = preload("res://scenes/completion.tscn") 
	var completion_instance = completion_scene.instantiate()

	add_child(completion_instance)

	# Format time and send it to the screen
	var minutes = int(elapsed_time) / 60
	var seconds = int(elapsed_time) % 60
	var time_string = "%02d:%02d" % [minutes, seconds]

	if completion_instance.has_method("set_time"):
		completion_instance.set_time("Time: " + time_string)
