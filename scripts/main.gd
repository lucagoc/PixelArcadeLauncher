extends Control


var settings = load("res://scripts/sys/settings.gd").new()

func preload_data():
	# Check if the launcher folder exists
	var dir = DirAccess.open(path.data)
	if dir == null:
		print("[INFO] Folder " + path.data + " not found, creating a new one...")
		DirAccess.make_dir_absolute(path.data)
		DirAccess.make_dir_absolute(path.data + path.games_folder)
		settings.save_settings()		
	else:
		print("[INFO] Folder " + path.data + " found")

	var setting_file = FileAccess.open(path.data + path.settings_file, FileAccess.READ)
	if setting_file == null:
		print("[INFO] settings.conf not found, creating a new one...")
		settings.save_settings()
	else:
		print("[INFO] settings.conf found, loading...")
		settings.load_settings()
	if setting_file != null:
		setting_file.close()

func load_data():
	start_loading()
	preload_data()
	GameList.reload_list()
	end_loading()

func start_loading():
	print("PixelArcadeLauncher is starting...")
	$LoadingScreen.show()
	$LoadingScreen/Mouse/AnimatedSprite2D.play("mouseRun")
	$MainMenu.hide()
	$AnimationPlayer.play("loading_start")


func end_loading():
	$AnimationPlayer.play("loading_end")
	print("[INFO] PixelArcadeLauncher has been loaded successfully !")

func add_console_commands():
	LimboConsole.register_command(load_data, "reload", "Reload the game list")
	LimboConsole.register_command(start_loading, "start_loading", "Start the loading screen")

func _ready():
	get_tree().get_root().size_changed.connect(resize)
	add_console_commands()
	settings.connect("scaling_changed", _scale_changed)
	load_data()

@warning_ignore("unused_parameter")
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()


func _scale_changed():
	get_tree().root.content_scale_factor = settings.scaling

func resize():
	Global.window_size = get_viewport().size