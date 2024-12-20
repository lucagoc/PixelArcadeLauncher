extends Node

class Game:
	# Game data
	var name: String					# Name of the game
	var platform: String				# Platform of the game (windows, mame, linux)
	var description: String				# Description of the game
	var categories: Array					# categories (action, arcade, adventure, etc.)

	# Executable
	var exec: String			# Command to launch the game

	# Assets
	var icon: ImageTexture				# Icon (drawer menu)
	var logo: ImageTexture				# Logo (more info, loading screen)
	var banner: ImageTexture			# Banner (main menu)
	var hero: ImageTexture				# Hero (background)
	var theme: AudioStreamOggVorbis		# Theme music
	
	# Data
	var nb_launches: int		# Number of times the game has been launched
	var last_launch: int		# Last time the game has been launched

	# Internal data
	var path: String			# Absolute path to the game folder
	var id: int					# Unique ID (int) of the game, attributed on load

var GAME_LIST: Array = []
var games_by_category: Dictionary = {"all": []}

# Load an img asset and return an ImageTexture
# Load a placeholder if the asset doesn't exist
func load_asset(asset_path) -> ImageTexture:
	var asset_img = Image.new()
	if FileAccess.file_exists(asset_path):
		asset_img.load(asset_path)
	else:
		asset_img.load(Path.placeholder)
	return ImageTexture.create_from_image(asset_img)

func load_banner(asset_path) -> ImageTexture:
	var banner_img = Image.new()
	if FileAccess.file_exists(asset_path):
		banner_img.load(asset_path)
		# resize 600x900
		#banner_img.resize(600, 900)
	else:
		banner_img.load(Path.placeholder)
	return ImageTexture.create_from_image(banner_img)

func load_theme(asset_path) -> AudioStreamOggVorbis:
	if FileAccess.file_exists(asset_path):
		return AudioStreamOggVorbis.load_from_file(asset_path)
	else:
		return null

func strip_quotes(string: String) -> String:
	if string.begins_with("\"") and string.ends_with("\""):
		return string.substr(1, string.length() - 2)
	return string

func strip_brackets(string: String) -> String:
	if string.begins_with("[") and string.ends_with("]"):
		return string.substr(1, string.length() - 2)
	return string

func process_categories(value: String) -> Array:
	var categories = []
	var parts = strip_brackets(value).split(",")
	for part in parts:
		categories.append(strip_quotes(part.strip_edges()).capitalize())
	print(categories)
	return categories

# Fonction pour ajouter un jeu dans toutes ses catégories
func add_game_to_categories(game):
	games_by_category["all"].append(game)
	for category in game.categories:
		if not games_by_category.has(category):
			games_by_category[category] = []  # Initialiser la liste si elle n'existe pas
		games_by_category[category].append(game)

# Fonction pour récupérer la liste des jeux dans une catégorie
func get_games_by_category(category: String) -> Array:
	if games_by_category.has(category):
		return games_by_category[category]
	else:
		return []  # Retourner une liste vide si la catégorie n'existe pas

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
							game.exec = strip_quotes(value)
						"description":
							game.description = value
						"categories":
							game.categories = process_categories(value)
							add_game_to_categories(game)
				line = file.get_line()
		else:
			printerr(game.folder + "/game.conf isn't in the proper format")
	else:
		printerr("Cannot open the file " + game.folder + "/game.conf")
	if file != null:
		file.close()

# Load the PAL data
func load_data_pal(game, path) -> void:
	var file = FileAccess.open(path, FileAccess.READ)
	if file != null:
		var line = file.get_line()
		while line != "":
			var parts = line.split("=")
			if parts.size() == 2:
				var key = parts[0].strip_edges()
				var value = parts[1].strip_edges()
				match key:
					"nb_launches":
						game.nb_launches = int(value)
					"last_launch":
						game.last_launch = int(value)
			line = file.get_line()
	else:
		printerr("Cannot open the file " + game.folder + "/game.pal")

# Load a game from the game folder
func load_game(folder_name: String) -> Game:
	var game = Game.new()

	game.path = Path.data + Path.games_folder + folder_name + "/"
	game.id = GAME_LIST.size()
	
	var game_path = Path.data + Path.games_folder + folder_name + "/"

	load_config_file(game, game_path + Path.game_conf)	# Load the game configuration file

	game.icon = load_asset(game_path + Path.game_icon)
	game.logo = load_asset(game_path + Path.game_logo)
	game.banner = load_banner(game_path + Path.game_banner)
	game.hero = load_asset(game_path + Path.game_hero)
	game.theme = load_theme(game_path + Path.game_theme)

	# Create the PAL file if it doesn't exist
	if not FileAccess.file_exists(game_path + Path.data_pal):
		var file = FileAccess.open(game_path + Path.data_pal, FileAccess.WRITE)
		if file != null:
			file.store_line("nb_launches=0")
			file.store_line("last_launch=0")
			file.close()
	
	load_data_pal(game, game_path + Path.data_pal)		# Load the PAL data (nb of launches, last launch)
	
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
	BusEvent.emit_signal("GAME_LIST_LOADED")

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
