extends Area2D

@export var next_scene_path: String = "res://scenes/level_2.tscn"
@export var target_node_path: NodePath  # Drag your Marker2D here in editor
@onready var marker_2d: Marker2D = $Marker2D

func _ready():
	monitoring = false  # Disabled until door opens

func _process(_delta):
	var target = get_node_or_null(target_node_path)
	if target and global_position.distance_to(target.global_position) < 16.0:
		get_tree().change_scene_to_file(next_scene_path)
