extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Loading screen
	$loadingScreen.show()
	$loadingScreen/Mouse/AnimatedSprite2D.play("mouseRun")
	$mainMenu.hide()
	$AnimationPlayer.play("loading_start")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_timer_timeout():
	$AnimationPlayer.play("loading_end")
