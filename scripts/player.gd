extends CharacterBody2D

const SPEED = 200.0

@onready var anim = $AnimatedSprite2D

var is_equipped = false
var has_mirror = false

func _ready():
	add_to_group("Player")

func _physics_process(delta: float) -> void:
	# Get the input direction.
	var direction_x := Input.get_axis("left", "right")
	var direction_y := Input.get_axis("upward", "downward")
	
	velocity.x = direction_x * SPEED
	velocity.y = direction_y * SPEED

	# Play animations based on input.
	if direction_x < 0:
		$AnimatedSprite2D.play("left")
	elif direction_x > 0:
		$AnimatedSprite2D.play("right")
	elif direction_y < 0:
		$AnimatedSprite2D.play("upward")
	elif direction_y > 0:
		$AnimatedSprite2D.play("downward")
	else:
		$AnimatedSprite2D.play("idle")

	# Check interact input (E).
	if Input.is_action_just_pressed("interact"):
		_interact()

	# Check equip input (Q).
	if Input.is_action_just_pressed("equip"):
		_toggle_equipped()

	# Apply movement.
	move_and_slide()

func _interact():
	pass

func _toggle_equipped():
	pass
	
func collect_mirror(mirror_node):
	if not has_mirror:
		mirror_node.queue_free()
		has_mirror = true
		print("Mirror collected!")
