extends Control

@export var scaling = 1

signal scaling_changed

# Save the settings in the settings.conf file
func save_settings():
	var setting_file = FileAccess.open(Path.data + Path.settings_file, FileAccess.WRITE)
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
						scaling = int(value)
						emit_signal("scaling_changed")
					"vsync":
						if value == "true":
							DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
						else:
							DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
			line = settings_file.get_line()
		settings_file.close()
	else:
		printerr("Cannot open the file " + Path.data + Path.settings_file)
