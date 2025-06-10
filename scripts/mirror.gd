extends StaticBody2D

@export var auto_rotate_speed := 45.0  # degrees per second
@onready var ui_label: Label = $HintLabel
@onready var animated_sprite_2d: Sprite2D = $AnimatedSprite2D

var player_near = false
var is_rotating := true

func _ready():
	randomize()
	rotation_degrees = randi() % 360  # Random initial rotation for whole mirror

	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))
	ui_label.visible = false

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		player_near = true
		ui_label.text = ""
		ui_label.visible = true

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("Player"):
		player_near = false
		ui_label.visible = false

func _process(delta):
	if player_near and Input.is_action_just_pressed("toggle_mirror"):  
		is_rotating = !is_rotating

	if is_rotating:
		rotation_degrees += auto_rotate_speed * delta
		rotation_degrees = fposmod(rotation_degrees, 360)
