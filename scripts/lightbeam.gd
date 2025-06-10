extends Node2D

@onready var line: Line2D = $Line2D

const MAX_BOUNCES: int = 10

func _ready():
	# Create gradient from yellow to transparent
	var gradient := Gradient.new()
	gradient.add_point(0.0, Color(1, 1, 0.75, 1.0))  # Opaque yellow
	gradient.add_point(1.0, Color(1, 1, 0.75, 0.0))  # Transparent

	var grad_texture := GradientTexture2D.new()
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
		query.collision_mask = 0xFFFFFFFF  # Check all layers

		var result = space_state.intersect_ray(query)

		if result:
			var collider = result.collider
			var collision_point = result.position
			var normal = result.normal

			line.add_point(to_local(collision_point))

			# Reflect only off mirrors
			if collider.is_in_group("Mirror"):
				current_dir = current_dir.bounce(normal).normalized()
				current_pos = collision_point + current_dir * 1.0  # Avoid self-intersection
				bounces += 1
			else:
				break
		else:
			var end_point = current_pos + current_dir * 1000
			line.add_point(to_local(end_point))
			break
