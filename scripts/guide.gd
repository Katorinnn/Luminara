extends CanvasLayer


func _ready() -> void:
	pass 


func _process(delta: float) -> void:
	pass


func _on_proceed_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")
