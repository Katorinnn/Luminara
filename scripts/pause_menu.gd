extends CanvasLayer
@onready var pause: CanvasLayer = $pause
@onready var ui: ColorRect = $pause/ui
	

func _input(event: InputEvent) -> void:
	if event.is_action_released("pause_game"):
		get_tree().paused = true
		$pause/ui.show()

func _on_continue_pressed(): 
	get_tree().paused = false
	$pause/ui.hide()

func _on_restart_pressed():
	get_tree().paused = false 
	get_tree().reload_current_scene()

func _on_howtoplay_pressed() -> void:
	pass

func _on_quit_pressed() -> void:
	get_tree().paused = false  
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
