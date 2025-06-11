extends Control

@onready var click_sfx: AudioStreamPlayer2D = $SFX/clickSFX
@onready var hover_sfx: AudioStreamPlayer2D = $SFX/hoverSFX

var menu_fadeout = false

func _ready() -> void:
	var cursor_texture = load("res://assets/bgBtn/pointer_scifi_a.png")
	Input.set_custom_mouse_cursor(cursor_texture)

func _process(delta: float) -> void:
	pass

func _on_start_btn_pressed() -> void:
	click_sfx.play()
	await get_tree().create_timer(0.2).timeout  

	for i in range(15):
		set_modulate(lerp(get_modulate(), Color(1, 1, 1, 0), 0.4))
		await get_tree().create_timer(0.05).timeout

	get_tree().change_scene_to_file("res://scenes/guide.tscn")

func _on_option_btn_pressed() -> void:
	click_sfx.play()

func _on_exit_btn_pressed() -> void:
	click_sfx.play()
	await get_tree().create_timer(0.2).timeout 
	get_tree().quit()

func _on_button_mouse_entered() -> void:
	hover_sfx.play()
