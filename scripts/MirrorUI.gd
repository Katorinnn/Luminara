extends CanvasLayer

@onready var mirror_icon = $Mirror
@onready var player = null

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	mirror_icon.visible = false 

func _process(_delta):
	if player:
		mirror_icon.visible = player.has_mirror
