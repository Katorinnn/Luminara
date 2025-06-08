extends Node2D

@export var mirror_scene: PackedScene
var mirror_instance: Node2D = null

@onready var interaction_area = $Area2D
@onready var ui_label: Label = $Area2D/HintLabel
@onready var animated_sprite_2d: Sprite2D = $AnimatedSprite2D

var player_near = false

func _ready():
	ui_label.visible = false
	interaction_area.body_entered.connect(_on_body_entered)	
	interaction_area.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("Player"):
		player_near = true
		_update_label()

func _on_body_exited(body):
	if body.is_in_group("Player"):
		player_near = false
		ui_label.visible = false

func _process(_delta):
	if player_near and Input.is_action_just_pressed("attach"):
		var player = get_tree().get_first_node_in_group("Player")
		if player == null:
			return

		# ATTACH mirror if none is attached AND player has one
		if mirror_instance == null and player.has_mirror:
			attach_mirror()
			player.has_mirror = false
			_update_label()
		
		# DETACH mirror if one is attached
		elif mirror_instance != null:
			detach_mirror()
			player.has_mirror = true
			_update_label()
			
func attach_mirror():
	if mirror_scene == null:
		push_error("mirror_scene is not assigned!")
		return
	mirror_instance = mirror_scene.instantiate()
	print("Mirror instantiated:", mirror_instance)
	print("Mirror position before adding:", mirror_instance.position)
	add_child(mirror_instance)
	mirror_instance.global_position = global_position
	mirror_instance.z_index = 10
	mirror_instance.visible = true
	if mirror_instance.has_node("AnimatedSprite2D"):
		var spr = mirror_instance.get_node("AnimatedSprite2D")
		print("AnimatedSprite2D visible before:", spr.visible)
		spr.visible = true
		print("AnimatedSprite2D visible after:", spr.visible)
	print("Mirror global position after setting:", mirror_instance.global_position)
	print("Mirror children:", mirror_instance.get_children())


func detach_mirror():
	if mirror_instance:
		mirror_instance.queue_free()
		mirror_instance = null

func _update_label():
	var player = get_tree().get_first_node_in_group("Player")
	if not player or not player_near:
		ui_label.visible = false
		print("Updating label, player_near:", player_near, "mirror_instance:", mirror_instance)
		return

	if mirror_instance == null and player.has_mirror:
		ui_label.text = "Press E to Attach Mirror"
		ui_label.visible = true
	elif mirror_instance != null:
		ui_label.text = "Press E to Detach Mirror"
		ui_label.visible = true
	else:
		ui_label.visible = false
