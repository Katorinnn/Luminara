extends Area2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	animation_player.play("pop")  

func _on_body_entered(body):
	if body.name == "Player":
		collect()

func collect():
	queue_free() 
