extends Area2D

@export var auto_rotate_speed := 45.0  # degrees per second
@onready var ui_label: Label = $HintLabel
@onready var animated_sprite_2d: Sprite2D = $AnimatedSprite2D

var is_rotating := true

func _ready():
	randomize()
	rotation_degrees = randi() % 360
	ui_label.visible = false

func _process(delta):
	if is_rotating:
		rotation_degrees += auto_rotate_speed * delta
		rotation_degrees = fposmod(rotation_degrees, 360)

func toggle_rotation():
	is_rotating = !is_rotating
	print("Mirror rotation toggled:", is_rotating)

# Optional — keep or remove the player detection if not needed
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		ui_label.text = ""
		ui_label.visible = true

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("Player"):
		ui_label.visible = false
		
