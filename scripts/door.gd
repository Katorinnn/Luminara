extends Area2D

class_name Door

@onready var destination_point_tag: String
@onready var destination_door_tag: String
@onready var spawn_direction = "up"

@onready var spawn = $Spawn


@onready var transition_screen: CanvasLayer = $"../transition_screen"
@export var open_on_enter: bool = false 

var player_near = false
var is_open = false

func _ready():
	$AnimatedSprite2D.play("close")

func _process(delta):
	if player_near and Input.is_action_just_pressed("interact"):  
		get_tree().change_scene_to_file("res://scenes/house.tscn")
		if is_open:
			close_door()
		else:
			open_door()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_near = true
		if open_on_enter and not is_open:
			open_door()
					
func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_near = false

func open_door():
	is_open = true
	$AnimatedSprite2D.play("open")
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.play("open") 


func close_door():
	is_open = false
	$AnimatedSprite2D.play("close")
