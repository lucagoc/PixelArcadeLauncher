extends Node

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

signal game_list_loaded # Do not remove this signal

# Load a game from the game folder
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
			if FileAccess.file_exists(game_path + path.game_icon):
				icon_img.load(game_path + path.game_icon)
			else:
				icon_img.load(path.unknown_icon)
			game.icon = ImageTexture.create_from_image(icon_img)

			# Logo
			var logo_img = Image.new()
			if FileAccess.file_exists(game_path + path.game_logo):
				logo_img.load(game_path + path.game_logo)
			else:
				logo_img.load(path.default_logo)
			game.logo = ImageTexture.create_from_image(logo_img)
			
			# Banner
			var banner_img = Image.new()
			if FileAccess.file_exists(game_path + path.game_banner):
				banner_img.load(game_path + path.game_banner)
			else:
				banner_img.load(path.default_banner)
			game.banner = ImageTexture.create_from_image(banner_img)

			# Hero
			var hero_img = Image.new()
			if FileAccess.file_exists(game_path + path.game_hero):
				hero_img.load(game_path + path.game_hero)
			else:
				hero_img.load(path.default_hero)
			game.hero = ImageTexture.create_from_image(hero_img)

		else:
			printerr("[ERROR] " + id + "/game.conf isn't in the proper format")
	else:
		printerr("[ERROR] Cannot open the file " + game_path + path.game_conf)
	if file != null:
		file.close()
	
	return game


# Load all the games folders by ID from the game folder
func load_list():
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

# Reload the game list
func reload_list():
	game_list.clear()
	load_list()
