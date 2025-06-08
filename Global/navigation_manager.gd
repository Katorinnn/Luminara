extends Node

const scene_main = preload("res://scenes/main.tscn")
const scene_house = preload("res://scenes/house.tscn")

signal on_trigger_player_spawn

var spawn_door_tag

func go_to_level(level_tag, destination_tag):
	var scene_to_load

	match level_tag:
		"main":
			scene_to_load = scene_main
		"house":
			scene_to_load = scene_house

	if scene_to_load != null:
		TransitionScreen.transition()
		await TransitionScreen.on_transition_finished
		spawn_door_tag = destination_tag
		get_tree().change_scene_to_packed(scene_to_load)

func trigger_player_spawn(position: Vector2, direction: String):
	on_trigger_player_spawn.emit(position, direction)
