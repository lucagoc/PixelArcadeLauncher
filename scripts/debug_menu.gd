extends Control

var pipe
var thread

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Show all the system information
	$SystemInfo.text = "OS: " + OS.get_name() + " " + OS.get_distribution_name() + " \nKernel: " + OS.get_version() + "\n" + "Processeur: " + str(OS.get_processor_count()) + " cores\n" + "RAM usage: " + str((OS.get_static_memory_usage()/1024)/1024) + " MB\n" + "Langue: " + OS.get_locale() 

	# Start the shell
	var info
	if OS.get_name() == "Windows":
		info = OS.execute_with_pipe("pwsh.exe", [])
	else:
		info = OS.execute_with_pipe("/bin/bash", [])
	pipe = info["stdio"]
	thread = Thread.new()
	thread.start(_thread_func)
	get_window().close_requested.connect(clean_func)


func _add_char(c):
	$Terminal/VBoxContainer/TextEdit.text += c
	$Terminal/VBoxContainer/TextEdit.scroll_vertical = $Terminal/VBoxContainer/TextEdit.get_v_scroll_bar().max_value


func _thread_func():
	# read stdin and add to TextEdit.
	while pipe.is_open() and pipe.get_error() == OK:
		_add_char.call_deferred(char(pipe.get_8()))


func _on_line_edit_text_submitted(new_text: String) -> void:
	# send command to stdin.
	var cmd = new_text + "\n"
	var buffer = cmd.to_utf8_buffer()
	pipe.store_buffer(buffer)
	$Terminal/VBoxContainer/HBoxContainer/LineEdit.text = ""


func clean_func():
	# close pipe and cleanup.
	pipe.close()
	thread.wait_to_finish()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Quit with menu with escape key
	if Input.is_action_just_pressed("ui_cancel"):
		clean_func()
		get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_volume_up_pressed() -> void:
	# Exec command amixer set Master 10%+ 
	OS.execute("/usr/bin/amixer", ["set", "Master", "10%+"])	


func _on_volume_down_pressed() -> void:
	# Exec command amixer set Master 10%- 
	OS.execute("/usr/bin/amixer", ["set", "Master", "10%-"])


func _on_button_pressed() -> void:
	_on_line_edit_text_submitted($Terminal/VBoxContainer/HBoxContainer/LineEdit.text)
