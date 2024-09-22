extends Control

# Create a list
var game_list = []

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Loading screen
	$loadingScreen.show()
	$loadingScreen/Mouse/AnimatedSprite2D.play("mouseRun")
	$mainMenu.hide()
	$AnimationPlayer.play("loading_start")

	# Load all the games folders by ID from the folder C:/PixelArcadeLauncher/games
	var dir = DirAccess.open("C:/PixelArcadeLauncher/games")
	if dir == null:
		print("Error: Can't open the directory")
		return
	dir.list_dir_begin()
	var dir_name = dir.get_next()
	while dir_name != "":
		if dir.current_is_dir():
			game_list.append(dir_name)
		else:
			print("Error: " + dir_name + " is not a directory")
		dir_name = dir.get_next()
	dir.list_dir_end()

	print("Detected games : " + str(game_list))

	# Add the games to the list
	$mainMenu/ItemList.clear()
	for game in game_list:

		# Open the file icon.png
		var img = Image.new()
		img.load("C:/PixelArcadeLauncher/games/" + game + "/icon.png")
		img.resize(128, 128)
		var icon = ImageTexture.create_from_image(img)
		if icon == null:
			print("Error: Can't load the icon for the game " + game)
			icon = load("res://icon.png")
		$mainMenu/ItemList.add_item(game, icon)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Quit with escape key
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

func _on_timer_timeout():
	$AnimationPlayer.play("loading_end")
