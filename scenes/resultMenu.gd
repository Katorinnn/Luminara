extends CanvasLayer

@onready var timer_label: Label = $ui/GameCompleted/TimerLabel

func _ready() -> void:
	pass

func set_time(final_time: String) -> void:
	timer_label.text = final_time

func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()

func _on_next_pressed() -> void:
	pass 

func _on_home_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
