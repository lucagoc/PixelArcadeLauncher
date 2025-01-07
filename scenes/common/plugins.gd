################################################
#               Plugins Manager                #
################################################

extends Node

var plugins = {}

func _get(property: StringName) -> Variant:
	return plugins[property]

func _on_settings_loaded():
	# Look for .gd in the plugins directory and load them.
	var plugins_folder_path = Settings.get_setting("General", "plugins_folder_path")
	var plugins_folder = DirAccess.open(plugins_folder_path)
	if not plugins_folder:
		printerr("[Plugins] Cannot open plugins folder at " + plugins_folder_path)
	else:
		plugins_folder.list_dir_begin()
		var file = plugins_folder.get_next()
		while file != "":
			if file.ends_with(".gd"):
				var plugin = load(plugins_folder_path + file)
				if plugin != null:
					plugins[file] = plugin.new()
					add_child(plugins[file])
					print("[Plugins] Plugin loaded successfully: " + file)
			file = plugins_folder.get_next()

func _ready():
	BusEvent.connect("SETTINGS_LOADED", _on_settings_loaded)
