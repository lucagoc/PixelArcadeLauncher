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
var games_folder_path = "C:/PixelArcadeLauncher/games/"

signal game_list_loaded


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
				print("[ERROR] Cannot open the file " + games_folder_path + id + "/icon.png")
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
			hero_img.load(games_folder_path + id + "/hero.png")
			hero_img.resize(397, 128)
			game.hero = ImageTexture.create_from_image(hero_img)
		else:
			print("[ERROR] " + id + "/game.conf isn't in the proper format")
	else:
		print("[ERROR] Cannot open the file " + games_folder_path + id + "/game.conf")
	if file != null:
		file.close()
	
	return game


# Load all the games folders by ID from the folder C:/PixelArcadeLauncher/games
func load_games_list():
	var dir = DirAccess.open(games_folder_path)
	if dir == null:
		print("[ERROR] Cannot open the directory " + games_folder_path)
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
			print("[ERROR] " + dir_name + " is not a directory")
		dir_name = dir.get_next()
	dir.list_dir_end()

	# Signal the game list is loaded
	emit_signal("game_list_loaded")


func start_loading():
	print("PixelArcadeLauncher is starting...")
	$loadingScreen.show()
	$loadingScreen/Mouse/AnimatedSprite2D.play("mouseRun")
	$mainMenu.hide()
	$AnimationPlayer.play("loading_start")


func end_loading():
	$AnimationPlayer.play("loading_end")
	print("[INFO] PixelArcadeLauncher has been loaded successfully !")


func _ready():
	start_loading()
	load_games_list()
	end_loading()


func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
