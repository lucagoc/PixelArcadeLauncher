extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Show all the system information
	$SystemInfo.text = "OS: " + OS.get_name() + " " + OS.get_distribution_name() + " \nKernel: " + OS.get_version() + "\n" + "Processeur: " + str(OS.get_processor_count()) + " cores\n" + "RAM usage: " + str((OS.get_static_memory_usage()/1024)/1024) + " MB\n" + "Langue: " + OS.get_locale() 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Quit with menu with escape key
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_volume_up_pressed() -> void:
	# Exec command amixer set Master 10%+ 
	OS.execute("/usr/bin/amixer", ["set", "Master", "10%+"])	


func _on_volume_down_pressed() -> void:
	# Exec command amixer set Master 10%- 
	OS.execute("/usr/bin/amixer", ["set", "Master", "10%-"])
