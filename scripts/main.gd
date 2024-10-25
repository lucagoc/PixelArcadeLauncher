extends Control


var settings = load("res://scripts/sys/settings.gd").new()

func preload_data():
	# Check if the launcher folder exists
	var dir = DirAccess.open(Path.data)
	if dir == null:
		print("[WARNING] Folder " + Path.data + " not found, creating a new one...")
		DirAccess.make_dir_absolute(Path.data)
		DirAccess.make_dir_absolute(Path.data + Path.games_folder)
		settings.save_settings()		
	else:
		print("Folder " + Path.data + " found")

	var setting_file = FileAccess.open(Path.data + Path.settings_file, FileAccess.READ)
	if setting_file == null:
		print("[WARNING] settings.conf not found, creating a new one...")
		settings.save_settings()
	else:
		print("settings.conf found, loading...")
		settings.load_settings()
	if setting_file != null:
		setting_file.close()

func load_data():
	start_loading()
	preload_data()
	GameList.reload()
	end_loading()

func start_loading():
	print("PixelArcadeLauncher is starting...")
	$LoadingScreen.show()
	$LoadingScreen/Mouse/AnimatedSprite2D.play("mouseRun")
	$MainMenu.hide()
	$AnimationPlayer.play("loading_start")


func end_loading():
	$AnimationPlayer.play("loading_end")
	print("[SUCCESS] PixelArcadeLauncher has been loaded successfully !")

func add_console_commands():
	LimboConsole.register_command(load_data, "reload", "Reload the game list")
	LimboConsole.register_command(start_loading, "start_loading", "Start the loading screen")

func _ready():
	add_console_commands()
	BusEvent.connect("SCALING_CHANGED", _on_scaling_changed)
	load_data()

@warning_ignore("unused_parameter")
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()


func _on_scaling_changed():
	get_tree().root.content_scale_factor = settings.scaling
