extends Area2D

@export var rotation_step_degrees := 45
@onready var ui_label: Label = $HintLabel
@onready var animated_sprite_2d: Sprite2D = $AnimatedSprite2D
@onready var warning_timer: Timer = Timer.new()

var player_near = false

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))
	ui_label.visible = false
	
	# Setup warning timer
	warning_timer.wait_time = 2.0
	warning_timer.one_shot = true
	warning_timer.connect("timeout", Callable(self, "_on_warning_timeout"))
	add_child(warning_timer)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		player_near = true
		ui_label.text = "Press E to detach"
		ui_label.visible = true

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("Player"):
		player_near = false
		ui_label.visible = false
		if warning_timer.is_stopped() == false:
			warning_timer.stop()

func _process(_delta):
	if player_near:
		if Input.is_action_just_pressed("detach"):
			detach()

		if Input.is_action_just_pressed("rotate"):
			animated_sprite_2d.rotation_degrees += rotation_step_degrees
			animated_sprite_2d.rotation_degrees = fposmod(animated_sprite_2d.rotation_degrees, 360)


func detach():
	var player = get_tree().get_first_node_in_group("Player")
	if player == null:
		return

	if player.has_mirror:
		ui_label.text = "You have one in your hand"
		ui_label.visible = true
		warning_timer.start()
	else:
		player.has_mirror = true
		ui_label.visible = false
		queue_free()

func _on_warning_timeout():
	if player_near:
		ui_label.text = "Press E to detach"
	else:
		ui_label.visible = false
