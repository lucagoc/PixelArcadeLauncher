extends Control

var settings = load("res://scripts/sys/settings.gd").new()

class Game:
	var id: String
	var name: String
	var platform: String
	var exec: String
	var description: String
	var genre: String
	var icon: ImageTexture
	var logo: ImageTexture
	var banner: ImageTexture
	var hero: ImageTexture

var game_list: Array = []

signal game_list_loaded

var placeholder_banner = ImageTexture.create_from_image(load("res://assets/placeholder_banner.png"))


# Create a game and read game.conf file
# First line must contain [PixelArcadePackage]
# Then the following lines must be:
# 	name = Name of the game
# 	platform = Platform of the game [Windows, Linux, MAME, unknown]
# 	exec = Command to execute the game
# 	description = Description of the game
# 	genre = Genre of the game
func load_game(id: String) -> Game:
	var game = Game.new()
	game.id = id
	var game_path = path.get_game(id)
	var file = FileAccess.open(game_path + path.game_conf, FileAccess.READ)
	if file != null:
		var line = file.get_line()
		if line == "[PixelArcadePackage]":
			line = file.get_line()
			while line != "":
				var parts = line.split("=")
				if parts.size() == 2:
					var key = parts[0].strip_edges()
					var value = parts[1].strip_edges()
					match key:
						"name":
							game.name = value
						"platform":
							game.platform = value
						"exec":
							game.exec = value
						"description":
							game.description = value
						"genre":
							game.genre = value
				line = file.get_line()
			
			# Icon
			var icon_img = Image.new()
			icon_img.load(game_path + path.game_icon)
			if icon_img == null:
				printerr("[ERROR] Cannot open the file " + game_path + path.game_icon)
				icon_img.load("res://icon.png")
			#icon_img.resize(64, 64)
			game.icon = ImageTexture.create_from_image(icon_img)

			# Logo
			var logo_img = Image.new()
			logo_img.load(game_path + path.game_logo)
			#img.resize(128, 128)
			game.logo = ImageTexture.create_from_image(logo_img)
			
			# Banner
			var banner_img = Image.new()
			banner_img.load(game_path + path.game_banner)
			if banner_img == null:
				printerr("[ERROR] Cannot open the file " + game_path + path.game_banner)
				game.banner = placeholder_banner
			else:
				game.banner = ImageTexture.create_from_image(banner_img)

			# Hero
			var hero_img = Image.new()
			if FileAccess.file_exists(game_path + path.game_hero):
				hero_img.load(game_path + path.game_hero)
				game.hero = ImageTexture.create_from_image(hero_img)
			else:
				hero_img.load("res://assets/img/unknown.png")
				game.hero = ImageTexture.create_from_image(hero_img)
		else:
			printerr("[ERROR] " + id + "/game.conf isn't in the proper format")
	else:
		printerr("[ERROR] Cannot open the file " + game_path + path.game_conf)
	if file != null:
		file.close()
	
	return game


# Load all the games folders by ID from the game folder
func load_games_list():
	var dir = DirAccess.open(path.data + path.games_folder)
	if dir == null:
		printerr("[ERROR] Cannot open the directory " + path.data + path.games_folder)
		return
	dir.list_dir_begin()
	var dir_name = dir.get_next()
	while dir_name != "":
		print("[INFO] Found directory \"" + dir_name + "\"")
		if dir.current_is_dir():
			var game = load_game(dir_name)
			game_list.append(game)
			print("[INFO] Loaded game " + game.name)
		else:
			printerr("[ERROR] " + dir_name + " is not a directory")
		dir_name = dir.get_next()
	dir.list_dir_end()

	# Signal the game list is loaded
	emit_signal("game_list_loaded")


func load_config():
	# Check if the launcher folder exists
	var dir = DirAccess.open(path.data)
	if dir == null:
		print("[INFO] Folder " + path.data + " not found, creating a new one...")
		DirAccess.make_dir_absolute(path.data)
		DirAccess.make_dir_absolute(path.data + path.games_folder)
		settings.save_settings()		
	else:
		print("[INFO] Folder " + path.data + " found")

	var setting_file = FileAccess.open(path.data + path.settings_file, FileAccess.READ)
	if setting_file == null:
		print("[INFO] settings.conf not found, creating a new one...")
		settings.save_settings()
	else:
		print("[INFO] settings.conf found, loading...")
		settings.load_settings()
	if setting_file != null:
		setting_file.close()


func start_loading():
	print("PixelArcadeLauncher is starting...")
	$LoadingScreen.show()
	$LoadingScreen/Mouse/AnimatedSprite2D.play("mouseRun")
	$MainMenu.hide()
	$AnimationPlayer.play("loading_start")


func end_loading():
	$AnimationPlayer.play("loading_end")
	print("[INFO] PixelArcadeLauncher has been loaded successfully !")


func _ready():
	start_loading()
	load_config()
	load_games_list()
	end_loading()

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

func _on_path_ready():
	print("[INFO] Path ready")
	
