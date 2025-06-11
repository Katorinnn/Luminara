extends Node2D

@onready var line: Line2D = $Line2D

const MAX_BOUNCES = 10
var door_opened = false


func _ready():
	var gradient = Gradient.new()
	gradient.add_point(0.0, Color(1, 1, 0.75, 1.0))
	gradient.add_point(1.0, Color(1, 1, 0.75, 0.0))

	var grad_texture = GradientTexture2D.new()
	grad_texture.gradient = gradient
	grad_texture.width = 256

	line.texture = grad_texture
	line.texture_repeat = CanvasItem.TEXTURE_REPEAT_DISABLED
	line.texture_mode = Line2D.LINE_TEXTURE_STRETCH

func _process(_delta):
	var direction = Vector2.RIGHT.rotated(global_rotation)
	draw_beam(global_position, direction)

func draw_beam(origin: Vector2, direction: Vector2):
	line.clear_points()
	line.add_point(to_local(origin))

	var current_pos = origin
	var current_dir = direction
	var bounces = 0
	var space_state = get_world_2d().direct_space_state

	while bounces < MAX_BOUNCES:
		var query = PhysicsRayQueryParameters2D.new()
		query.from = current_pos
		query.to = current_pos + current_dir * 1000
		query.collide_with_areas = true
		query.collide_with_bodies = true

		var result = space_state.intersect_ray(query)

		if result:
			var collider = result.collider
			var collision_point = result.position
			var normal = result.normal

			line.add_point(to_local(collision_point))

			if collider.is_in_group("Endpoint"):
				open_door()
				
				# Notify main scene to stop the timer
				var main_node = get_tree().current_scene  # Or use explicit node path
				if main_node.has_method("finish_game"):
					main_node.finish_game()

				break
			elif collider.is_in_group("Mirror"):
				current_dir = current_dir.bounce(normal).normalized()
				current_pos = collision_point + current_dir * 1.0
				bounces += 1
			else:
				break
		else:
			line.add_point(to_local(current_pos + current_dir * 1000))
			break

func open_door():
	if door_opened:
		return
	door_opened = true
	
	var scene_name = get_tree().current_scene.name
	print("Scene name:", scene_name)

	var anim_name = "open_door"
	if scene_name == "Level2":
		anim_name = "open_horizontal"
	elif scene_name == "Level3":
		anim_name = "open_slide"
	
	print("Animation to play:", anim_name)

	for door in get_tree().get_nodes_in_group("Door"):
		var anim_player = door.get_node_or_null("AnimationPlayer")
		if anim_player:
			print("Found AnimationPlayer in:", door.name)
			print("Available animations:", anim_player.get_animation_list())
			anim_player.play(anim_name)
		else:
			print("No AnimationPlayer found in:", door.name)

		var portal = door.get_node_or_null("Portal")
		if portal and portal is Area2D:
			portal.set_deferred("monitoring", true)
			portal.set_deferred("monitorable", true)
