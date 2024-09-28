extends Control

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
var launcher_path = ""
var games_folder_path = ""

signal game_list_loaded


# Convert a posix path to a windows path
func posix_to_win_path(path: String) -> String:
	var new_path = path.replace("/", "\\")
	return new_path

# Save the settings in the settings.conf file
func save_settings():
	var setting_file = FileAccess.open(launcher_path + "settings.conf", FileAccess.WRITE)
	if setting_file != null:
		setting_file.store_line("[PixelArcadeLauncher]")
		setting_file.store_line("fullscreen = false")
		setting_file.store_line("animation = true")
		setting_file.store_line("sound = true")
		setting_file.store_line("debug = false")
		setting_file.store_line("scaling = 1")
		setting_file.store_line("vsync = true")
		setting_file.close()
	else:
		printerr("[ERROR] Cannot open the file " + launcher_path + "settings.conf")

# Load the settings from the settings.conf file
func load_settings():
	var setting_file = FileAccess.open(launcher_path + "settings.conf", FileAccess.READ)
	if setting_file != null:
		var line = setting_file.get_line()
		while line != "":
			var parts = line.split("=")
			if parts.size() == 2:
				var key = parts[0].strip_edges()
				var value = parts[1].strip_edges()
				match key:
					"fullscreen":
						if value == "true":
							DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
						else:
							DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
					"scaling":
						print("[INFO] Scaling: " + value)
						key = int(value)
						get_tree().root.content_scale_factor = key
					"vsync":
						if value == "true":
							DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
						else:
							DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
			line = setting_file.get_line()
		setting_file.close()
	else:
		printerr("[ERROR] Cannot open the file " + launcher_path + "settings.conf")

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
	var file = FileAccess.open(games_folder_path + id + "/game.conf", FileAccess.READ)
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
			icon_img.load(games_folder_path + id + "/icon.png")
			if icon_img == null:
				printerr("[ERROR] Cannot open the file " + games_folder_path + id + "/icon.png")
				icon_img.load("res://icon.png")
			icon_img.resize(64, 64)
			game.icon = ImageTexture.create_from_image(icon_img)

			# Logo
			var logo_img = Image.new()
			logo_img.load(games_folder_path + id + "/logo.png")
			#img.resize(128, 128)
			game.logo = ImageTexture.create_from_image(logo_img)
			
			# Banner
			var banner_img = Image.new()
			banner_img.load(games_folder_path + id + "/banner.png")
			banner_img.resize(100, 150)
			game.banner = ImageTexture.create_from_image(banner_img)

			# Hero
			var hero_img = Image.new()
			if FileAccess.file_exists(games_folder_path + id + "/hero.png"):
				hero_img.load(games_folder_path + id + "/hero.png")
				game.hero = ImageTexture.create_from_image(hero_img)
			else:
				hero_img.load("res://assets/img/unknown.png")
				game.hero = ImageTexture.create_from_image(hero_img)
		else:
			printerr("[ERROR] " + id + "/game.conf isn't in the proper format")
	else:
		printerr("[ERROR] Cannot open the file " + games_folder_path + id + "/game.conf")
	if file != null:
		file.close()
	
	return game


# Load all the games folders by ID from the game folder
func load_games_list():
	var dir = DirAccess.open(games_folder_path)
	if dir == null:
		printerr("[ERROR] Cannot open the directory " + games_folder_path)
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
	var home_path := OS.get_environment("USERPROFILE") if OS.has_feature("windows") else OS.get_environment("HOME")
	launcher_path = home_path + "/PixelArcadeLauncher/"
	games_folder_path = launcher_path + "games/"
	if OS.has_feature("windows"):
		launcher_path = posix_to_win_path(launcher_path)
		games_folder_path = posix_to_win_path(games_folder_path)
	var dir = DirAccess.open(launcher_path)
	if dir == null:
		print("[INFO] Folder " + launcher_path + " not found, creating a new one...")
		DirAccess.make_dir_absolute(launcher_path)
		DirAccess.make_dir_absolute(games_folder_path)
		save_settings()		
	else:
		print("[INFO] Folder " + launcher_path + " found")

	var setting_file = FileAccess.open(launcher_path + "settings.conf", FileAccess.READ)
	if setting_file == null:
		print("[INFO] settings.conf not found, creating a new one...")
		save_settings()
	else:
		print("[INFO] settings.conf found, loading...")
		load_settings()
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
