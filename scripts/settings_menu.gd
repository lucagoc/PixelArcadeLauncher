extends Control

@onready var animation_player = $MainVbox/MainHbox/MainSettings/AnimationPlayer

func _ready():
	$MainVbox/MainHbox/MainSettings/System.grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
