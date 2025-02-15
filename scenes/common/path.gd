extends Node

# Path to the main folder of the launcher
var data

# Launcher Properties path structure
var settings_file = "settings.conf"        # Path to the settings file
var games_folder  = "games/"               # Path to the games folder
var themes_folder = "themes/"              # Path to the themes folder

# Game properties path structure
var game_conf   = "game.conf"              # Path to the game.conf file
var game_banner = "banner.png"             # Path to the game banner
var game_hero   = "hero.png"               # Path to the game hero
var game_icon   = "icon.png"               # Path to the game icon
var game_logo   = "logo.png"               # Path to the game logo
var game_theme  = "theme.ogg"              # Path to the game theme

# PAL Data
var data_pal = "data.pal"                  # Path to the game PAL data

# Default images
var placeholder = "res://assets/img/default/placeholder.svg"

# Convert a posix path to a windows path
func posix_to_win_path(path: String) -> String:
	var new_path = path.replace("/", "\\")
	return new_path

# Return the absolute path to the game folder
func get_game(folder_name: String) -> String:
	if OS.has_feature("windows"):
		return data + games_folder + folder_name + "\\"
	else:
		return data + games_folder + folder_name + "/"

func strip_quotes(string: String) -> String:
	if string.begins_with("\"") and string.ends_with("\""):
		return string.substr(1, string.length() - 2)
	return string

func strip_brackets(string: String) -> String:
	if string.begins_with("[") and string.ends_with("]"):
		return string.substr(1, string.length() - 2)
	return string

func string_to_path(string: String) -> String:

	string = strip_quotes(string)

	# Replace $HOME, ~, $USERPROFILE by the user home directory
	if string.begins_with("$HOME"):
		string = string.replace("$HOME", OS.get_environment("HOME"))
	elif string.begins_with("~"):
		string = string.replace("~", OS.get_environment("HOME"))
	elif string.begins_with("$USERPROFILE"):
		string = string.replace("$USERPROFILE", OS.get_environment("USERPROFILE"))

	if OS.has_feature("windows"):
		return posix_to_win_path(string)
	else:
		return string

func _ready():
	# Windows things UwU
	if OS.has_feature("windows"):
		data = OS.get_environment("USERPROFILE") + "\\PixelArcadeLauncher\\"
		data = posix_to_win_path(data)
		settings_file = posix_to_win_path(settings_file)
		games_folder = posix_to_win_path(games_folder)
		themes_folder = posix_to_win_path(themes_folder)
		game_conf = posix_to_win_path(game_conf)
		game_banner = posix_to_win_path(game_banner)
		game_hero = posix_to_win_path(game_hero)
		game_icon = posix_to_win_path(game_icon)
		game_logo = posix_to_win_path(game_logo)
	else:
		data = OS.get_environment("HOME") + "/PixelArcadeLauncher/"
