extends Control

var offset = 20

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Text/Desc.text = Settings.maintenance.message
	$AnimatedSprite2D.play()
	
	refresh_animation()

	# If the maintenance message is empty, hide the text
	if Settings.maintenance.message == "":
		$Text.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

func refresh_animation():
	# Adapt mouse animation to the screen size
	var screen_x = get_viewport().size.x
	var screen_y = get_viewport().size.y
	
	$AnimatedSprite2D.hide()
	$MouseAnimation.get_animation("mouse_run").track_set_key_value(0, 0, Vector2(-screen_x, screen_y - offset))
	$MouseAnimation.get_animation("mouse_run").track_set_key_value(0, 1, Vector2(2 * screen_x, screen_y - offset))
	$MouseAnimation.play("mouse_run")
	$AnimatedSprite2D.show()

func _on_mouse_animation_animation_finished(anim_name: StringName) -> void:
	refresh_animation()
