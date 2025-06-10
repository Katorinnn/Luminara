extends Control

var menu_fadeout = false

func _ready() -> void:
	pass 

func _process(delta: float) -> void:
	pass

func _on_start_btn_pressed() -> void:

	for i in range(15):
		set_modulate(lerp(get_modulate(), Color(1, 1, 1, 0), 0.4))
		await get_tree().create_timer(0.05).timeout

	get_tree().change_scene_to_file("res://scenes/level_1.tscn")

func _on_option_btn_pressed() -> void:
	pass 


func _on_exit_btn_pressed() -> void:
	get_tree().quit()
