extends Area2D

@export var target_mirror: NodePath
var mirror: Node2D = null  # Explicitly typed

func _ready():
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)
	
	if has_node(target_mirror):
		mirror = get_node(target_mirror)
	else:
		push_error("Target mirror path is invalid!")

func _on_body_entered(body):
	if body.is_in_group("Player") and mirror:
		mirror.is_rotating = false

func _on_body_exited(body):
	if body.is_in_group("Player") and mirror:
		mirror.is_rotating = true
