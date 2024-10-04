extends Control

@onready var animation_player = $MainVbox/MainHbox/MainSettings/AnimationPlayer

func _ready():
	$MainVbox/MainHbox/MainSettings/System.grab_focus()
