extends Control

class General:
	var debug_mode := false
	var animations := true

class Maintenance:
	var enabled := false
	var message := "Maintenance mode is currently enabled."

class Sound:
	var enabled := true
	var volume := 100

class Video:
	var scaling := 1.0
	var vsync := true
	var fullscreen := true

class Menu:
	var disable_drawer := false

class Screensaver:
	var disable_screensaver := false

var general = General.new()
var maintenance = Maintenance.new()
var sound = Sound.new()
var video = Video.new()
var menu = Menu.new()
var screensaver = Screensaver.new()

# Save the settings in the settings.conf file
func save_settings():

	# Open the file	
	var setting_file = FileAccess.open(Path.data + Path.settings_file, FileAccess.WRITE)

	# Copy the base header
	var header_file = FileAccess.open("res://assets/txt/header.txt", FileAccess.READ)
	if header_file != null:
		setting_file.store_line(header_file.get_as_text())
	else:
		printerr("Cannot open the file res://settings.conf")
	
	# Apply the settings
	setting_file.store_line("[General]")
	setting_file.store_line("debug_mode = " + str(general.debug_mode))
	setting_file.store_line("animations = " + str(general.animations))
	setting_file.store_line("")

	setting_file.store_line("[Maintenance]")
	setting_file.store_line("enabled = " + str(maintenance.enabled))
	setting_file.store_line("message = " + maintenance.message)
	setting_file.store_line("")

	setting_file.store_line("[Sound]")
	setting_file.store_line("enabled = " + str(sound.enabled))
	setting_file.store_line("volume = " + str(sound.volume))
	setting_file.store_line("")

	setting_file.store_line("[Video]")
	setting_file.store_line("scaling = " + str(video.scaling))
	setting_file.store_line("vsync = " + str(video.vsync))
	setting_file.store_line("fullscreen = " + str(video.fullscreen))
	setting_file.store_line("")

	setting_file.store_line("[Menu]")
	setting_file.store_line("disable_drawer = " + str(menu.disable_drawer))
	setting_file.store_line("")

	setting_file.store_line("[Screensaver]")
	setting_file.store_line("disable_screensaver = " + str(screensaver.disable_screensaver))
	setting_file.store_line("")

	# Close the file
	setting_file.close()


# Load the settings from the settings.conf file
func load_settings():
	
	# Open the file
	var setting_file = FileAccess.open(Path.data + Path.settings_file, FileAccess.READ)

	# Check if the file exists
	if setting_file == null:
		printerr("Cannot open the file res://settings.conf")
		return

	var section = ""
	
	# Read the file
	while !setting_file.eof_reached():

		# Read the line
		var line = setting_file.get_line()

		# Check if the line is empty
		if line == "":
			continue

		# Check if the line is a section
		if line.begins_with("[") and line.ends_with("]"):
			section = line.substr(1, line.length() - 2)
			continue

		# Check if the line is a setting
		var setting = line.split(" = ")
		if setting.size() == 2:

			# General
			if section == "General":
				if setting[0] == "debug_mode":
					general.debug_mode = setting[1].matchn("true")
				elif setting[0] == "animations":
					general.animations = setting[1].matchn("true")

			# Maintenance
			elif section == "Maintenance":
				if setting[0] == "enabled":
					maintenance.enabled = setting[1].matchn("true")
				elif setting[0] == "message":
					maintenance.message = setting[1]

			# Sound
			elif section == "Sound":
				if setting[0] == "enabled":
					sound.enabled = setting[1].matchn("true")
				elif setting[0] == "volume":
					sound.volume = setting[1].to_int()

			# Video
			elif section == "Video":
				if setting[0] == "scaling":
					video.scaling = setting[1].to_float()
				elif setting[0] == "vsync":
					video.vsync = setting[1].matchn("true")
				elif setting[0] == "fullscreen":
					video.fullscreen = setting[1].matchn("true")

			# Menu
			elif section == "Menu":
				if setting[0] == "disable_drawer":
					menu.disable_drawer = setting[1].matchn("true")

			# Screensaver
			elif section == "Screensaver":
				if setting[0] == "disable_screensaver":
					screensaver.disable_screensaver = setting[1].matchn("true")

	# Close the file
	setting_file.close()

func apply_settings():
	get_tree().root.content_scale_factor = video.scaling
	if video.fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	if video.vsync:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)

	BusEvent.emit_signal("SCALING_CHANGED", video.scaling)
