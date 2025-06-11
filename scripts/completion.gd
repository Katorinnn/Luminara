extends CanvasLayer

@export var next_level_scene: String
@onready var click_sfx: AudioStreamPlayer2D = $SFX/clickSFX
@onready var hover_sfx: AudioStreamPlayer2D = $SFX/hoverSFX

@onready var timer_label: Label = $ui/GameCompleted/TimerLabel
@onready var ui_root: Control = $ui  

var menu_fadeout := false

func _ready() -> void:
	pass

func set_time(final_time: String) -> void:
	timer_label.text = final_time

func _on_restart_pressed() -> void:
	click_sfx.play()
	get_tree().reload_current_scene()

func _on_next_pressed() -> void:
	click_sfx.play()

	var current_scene = get_tree().current_scene.name

	if current_scene == "Level 1":
		get_tree().change_scene_to_file("res://scenes/level_2.tscn")
	elif current_scene == "Level 2":
		get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
	else:
		print("⚠️ No next level assigned for this scene!")


func _on_home_pressed() -> void:
	click_sfx.play()
	if menu_fadeout:
		return
	menu_fadeout = true
	
	await get_tree().create_timer(0.2).timeout

	for i in range(15):
		var current_modulate = ui_root.modulate
		ui_root.modulate = Color(0.5, 0.5, 0.5, current_modulate.a - 0.06)  
		await get_tree().create_timer(0.05).timeout

	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
