extends Control

@export var scaling := 1.0
@export var maintenance = false
@export var maintenance_message = "Promis c'est pour bientôt !"

# Save the settings in the settings.conf file
func save_settings():
	
	var setting_file = FileAccess.open(Path.data + Path.settings_file, FileAccess.WRITE)

	# If the settings file does not exist, create it
	if setting_file == null:
		var blank_setting_file = FileAccess.open("res://settings.conf", FileAccess.READ)
		if blank_setting_file != null:
			setting_file = FileAccess.open(Path.data + Path.settings_file, FileAccess.WRITE)
			if setting_file != null:
				setting_file.store_line(blank_setting_file.get_as_text())
				setting_file.close()
			else:
				printerr("Cannot open the file " + Path.data + Path.settings_file)
		else:
			printerr("Cannot open the file res://settings.conf")
	else:
		printerr("Cannot open the file " + Path.data + Path.settings_file)

# Load the settings from the settings.conf file
func load_settings():
	var settings_file = FileAccess.open(Path.data + Path.settings_file, FileAccess.READ)
	if settings_file != null:
		var line = settings_file.get_line()
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
						scaling = float(value)
						BusEvent.emit_signal("SCALING_CHANGED")
					"vsync":
						if value == "true":
							DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
						else:
							DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
					"maintenance":
						if value == "true":
							maintenance = true
					"message":
						maintenance_message = value
			line = settings_file.get_line()
		settings_file.close()
	else:
		printerr("Cannot open the file " + Path.data + Path.settings_file)
