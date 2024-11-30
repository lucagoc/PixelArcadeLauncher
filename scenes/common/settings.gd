extends Control

# Paramètres stockés dans des dictionnaires
var settings = {
	"General": {
		"debug_mode": false,
		"animations": true,
		"mame_plugins_home": "$HOME"
	},
	"Maintenance": {
		"enabled": false,
		"message": "Maintenance mode is currently enabled."
	},
	"Sound": {
		"enabled": true,
		"volume": 100
	},
	"Video": {
		"scaling": 1.0,
		"vsync": true,
		"fullscreen": true
	},
	"Menu": {
		"disable_drawer": false
	},
	"Screensaver": {
		"disable_screensaver": false
	}
}

# Sauvegarde des paramètres dans un fichier settings.conf
func save_settings():
	var setting_file = FileAccess.open(Path.data + Path.settings_file, FileAccess.WRITE)

	# Copie l'entête de base
	var header_file = FileAccess.open("res://assets/txt/header.txt", FileAccess.READ)
	if header_file != null:
		setting_file.store_line(header_file.get_as_text())
	else:
		printerr("Cannot open the file res://assets/txt/header.txt")

	# Parcours des sections et des paramètres
	for section in settings.keys():
		setting_file.store_line("[" + section + "]")
		for key in settings[section].keys():
			setting_file.store_line(key + " = " + str(settings[section][key]))
		setting_file.store_line("") # Ligne vide entre les sections

	setting_file.close()

# Chargement des paramètres depuis un fichier settings.conf
func load_settings():
	var setting_file = FileAccess.open(Path.data + Path.settings_file, FileAccess.READ)
	if setting_file == null:
		printerr("Cannot open the file " + Path.data + Path.settings_file)
		return

	var current_section = ""
	while !setting_file.eof_reached():
		var line = setting_file.get_line().strip_edges()

		# Gestion des sections
		if line.begins_with("[") and line.ends_with("]"):
			current_section = line.substr(1, line.length() - 2)
			continue

		# Gestion des paramètres
		var setting = line.split(" = ")
		if setting.size() == 2 and current_section in settings:
			var key = setting[0]
			var value = setting[1]
			if key in settings[current_section]:
				settings[current_section][key] = parse_value(settings[current_section][key], value)

	setting_file.close()

# Parse les valeurs en fonction de leur type attendu
func parse_value(existing_value, new_value):
	if typeof(existing_value) == TYPE_BOOL:
		return new_value.matchn("true")
	elif typeof(existing_value) == TYPE_INT:
		return new_value.to_int()
	elif typeof(existing_value) == TYPE_FLOAT:
		return new_value.to_float()
	else:
		return new_value

# Applique les paramètres
func apply_settings():
	var video_settings = settings["Video"]
	get_tree().root.content_scale_factor = video_settings["scaling"]
	
	if video_settings["fullscreen"]:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	if video_settings["vsync"]:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)

	if OS.has_feature("linux") and settings["Sound"]["enabled"]:
		var sound_volume = str(settings["Sound"]["volume"]) + "%"
		OS.execute("/usr/bin/amixer", ["set", "Master", sound_volume])
	
	BusEvent.emit_signal("SCALING_CHANGED", video_settings["scaling"])

# Récupère un paramètre
func get_setting(section, key):
	return settings[section][key]

# Does not save the settings to the file
func set_setting(section, key, value):
	settings[section][key] = value
	apply_settings()
