extends Area2D


@onready var game_complete_popup = get_node("/root/YourMainScene/CanvasLayer/GameCompletePopup")

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		show_game_complete()
		# Optionally stop player movement or the game

func show_game_complete():
	game_complete_popup.visible = true
	# Optionally: pause game
	get_tree().paused = true
