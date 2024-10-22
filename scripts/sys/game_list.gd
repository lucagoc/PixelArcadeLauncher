extends Node

class Game:
	# Game data
	var name: String			# Name of the game
	var platform: String		# Platform of the game (windows, mame, linux)
	var description: String		# Description of the game
	var genre: String			# Genre (action, arcade, adventure, etc.)

	# Executable
	var exec: String			# Command to launch the game

	# Assets
	var icon: ImageTexture		# Icon (drawer menu)
	var logo: ImageTexture		# Logo (more info, loading screen)
	var banner: ImageTexture	# Banner (main menu)
	var hero: ImageTexture		# Hero (background)
	
	# Internal data
	var path: String			# Absolute path to the game folder
	var id: int					# Unique ID (int) of the game, attributed on load

var GAME_LIST: Array = []

# Load an img asset and return an ImageTexture
# Load a placeholder if the asset doesn't exist
func load_asset(asset_path) -> ImageTexture:
	var icon_img = Image.new()
	if FileAccess.file_exists(asset_path):
		icon_img.load(asset_path)
	else:
		icon_img.load(Path.placeholder)
	return ImageTexture.create_from_image(icon_img)

# Load the game configuration file
func load_config_file(game, path) -> void:
	var file = FileAccess.open(path, FileAccess.READ)
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
		else:
			printerr(game.folder + "/game.conf isn't in the proper format")
	else:
		printerr("Cannot open the file " + game.folder + "/game.conf")
	if file != null:
		file.close()


# Load a game from the game folder
func load_game(folder_name: String) -> Game:
	var game = Game.new()

	game.path = Path.data + Path.games_folder + folder_name + "/"
	game.id = GAME_LIST.size()
	
	var game_path = Path.data + Path.games_folder + folder_name + "/"
	load_config_file(game, game_path + Path.game_conf)
	game.icon = load_asset(game_path + Path.game_icon)
	game.logo = load_asset(game_path + Path.game_logo)
	game.banner = load_asset(game_path + Path.game_banner)
	game.hero = load_asset(game_path + Path.game_hero)
	
	return game

# Load all the games folders by ID from the game folder
func load_list():
	var dir = DirAccess.open(Path.data + Path.games_folder)
	if dir == null:
		printerr("Cannot open the directory " + Path.data + Path.games_folder)
		return
	dir.list_dir_begin()
	var dir_name = dir.get_next()
	while dir_name != "":
		print("Found directory \"" + dir_name + "\"")
		if dir.current_is_dir():
			var game = load_game(dir_name)
			GAME_LIST.append(game)
			print("Loaded game " + game.name)
		else:
			printerr(dir_name + " is not a directory")
		dir_name = dir.get_next()
	dir.list_dir_end()

	# Signal the game list is loaded
	BusEvent.emit_signal("GAME_LIST_LOAD_SUCCESSFULL")

# Reload the game list
func reload():
	GAME_LIST.clear()
	load_list()

# Find a game by folder name
func find_game(folder: String) -> Game:
	for game in GAME_LIST:
		if game.folder == folder:
			return game
	return null
