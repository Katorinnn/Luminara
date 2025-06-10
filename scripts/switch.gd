extends Area2D

@export var target_mirror: NodePath
var mirror: Node = null
var player_near := false
var is_rotating := true

@onready var toggle_sound: AudioStreamPlayer2D = $toggleSFX
@onready var hint_label: Label = $HintLabel

func _ready():
	# Try to get the mirror node from the path
	if target_mirror != null and has_node(target_mirror):
		mirror = get_node(target_mirror)
	else:
		push_warning("Mirror target not set or invalid path!")

	# Connect signals for player detection
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		player_near = true
		hint_label.visible = true
		hint_label.text = "Press Shift to toggle mirror"

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("Player"):
		player_near = false
		hint_label.visible = false

func _process(delta: float) -> void:
	if player_near and Input.is_action_just_pressed("toggle_switch"):
		print("Toggle key pressed near switch.")
		if mirror:
			if mirror.has_method("toggle_rotation"):
				mirror.toggle_rotation()
				toggle_sound.play()  
			else:
				print("Target does not have method 'toggle_rotation()'")
		else:
			print("Mirror node is null.")

func toggle_rotation():
	is_rotating = !is_rotating
	print("Mirror rotation toggled:", is_rotating)
