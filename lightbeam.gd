extends Node2D

@onready var ray: RayCast2D = $RayCast2D
@onready var line: Line2D = $Line2D

const MAX_BOUNCES: int = 10

func _ready():
	# Create gradient with yellow to transparent
	var gradient := Gradient.new()
	gradient.add_point(0.0, Color(1, 1, 0.75, 1.0))  # Light yellow opaque
	gradient.add_point(1.0, Color(1, 1, 0.75, 0.0))  # Light yellow transparent

	# Create GradientTexture2D and assign the gradient
	var grad_texture := GradientTexture2D.new()
	grad_texture.gradient = gradient
	grad_texture.width = 256  # Higher = smoother gradient

	# Apply to Line2D
	line.texture = grad_texture
	line.texture_repeat = CanvasItem.TEXTURE_REPEAT_DISABLED  # No tiling
	line.texture_mode = Line2D.LINE_TEXTURE_STRETCH  # Stretch across beam

func _process(_delta):
	# Shoot beam in the node's facing direction (rotation)
	var direction = Vector2.RIGHT.rotated(rotation)
	draw_beam(global_position, direction)

func draw_beam(origin: Vector2, direction: Vector2):
	line.clear_points()
	line.add_point(to_local(origin))

	var current_pos = origin
	var current_dir = direction
	var bounces = 0

	while bounces < MAX_BOUNCES:
		ray.global_position = current_pos
		ray.target_position = current_dir * 1000
		ray.force_raycast_update()

		if ray.is_colliding():
			var collider = ray.get_collider()

			# Only reflect if hitting mirror1 or mirror2
			if collider.name == "mirror1" or collider.name == "mirror2":
				var collision_point = ray.get_collision_point()
				var normal = ray.get_collision_normal()

				line.add_point(to_local(collision_point))

				current_dir = current_dir.bounce(normal).normalized()
				current_pos = collision_point + current_dir * 1.0
				bounces += 1
			else:
				# Hit something else (like a wall), stop
				line.add_point(to_local(ray.get_collision_point()))
				break
		else:
			# No collision - draw a straight line
			var end_point = current_pos + current_dir * 1000
			line.add_point(to_local(end_point))
			break
