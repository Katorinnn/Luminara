extends Area2D

@onready var animated_sprite = $AnimatedSprite2D

var is_open = false
var player_in_range = false
var mirror_scene = preload("res://scenes/mirror.tscn")  

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body):
	if body.name == "Player":
		player_in_range = true

func _on_body_exited(body):
	if body.name == "Player":
		player_in_range = false

func _process(delta):
	if Input.is_action_just_pressed("interact") and player_in_range and not is_open:
		open_chest()

func open_chest():
	is_open = true
	animated_sprite.play("open")

	var mirror_instance = mirror_scene.instantiate()
	get_tree().current_scene.add_child(mirror_instance)
	mirror_instance.global_position = global_position
