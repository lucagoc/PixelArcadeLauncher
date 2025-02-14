extends Panel

var default_icon = load("res://assets/img/settings/Default.png")

func _on_settings_loaded() -> void:
	$MainHbox/CategoryBar.select(0) # Select the first category

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready() -> void:
	# Empty the CategoryList
	$MainHbox/CategoryBar.clear()

	# Create for each section a new item in the CategoryList
	for section in Settings.settings.keys():
		var icon_path = "res://assets/img/settings/" + section + ".png"
		var icon = default_icon
		if FileAccess.file_exists(icon_path):
			icon = load(icon_path)
		$MainHbox/CategoryBar.add_item(section, icon)
	
	# Select the first category
	$MainHbox/CategoryBar.select(0)
	$MainHbox/CategoryBar.grab_focus()
	_on_category_bar_item_selected(0)


func _on_option_toggled(button: CheckButton, option: Array) -> void:
	Settings.settings[$MainHbox/CategoryBar/List.get_item_text(option[1])][option[0]] = button.button_pressed

func _on_option_value_changed(spinbox: SpinBox, option: Array) -> void:
	Settings.settings[$MainHbox/CategoryBar/List.get_item_text(option[1])][option[0]] = spinbox.value

func _on_option_text_changed(lineedit: LineEdit, option: Array) -> void:
	Settings.settings[$MainHbox/CategoryBar/List.get_item_text(option[1])][option[0]] = lineedit.text

func _on_save_button_pressed() -> void:
	Settings.save_settings()

func _on_category_bar_item_selected(index: int) -> void:
	$MainHbox/OptionBar.clear()
	$MainHbox/ValueBar.clear()

	# Create for each option a new item in the OptionList
	for key in Settings.settings[$MainHbox/CategoryBar/List.get_item_text(index)].keys():
		var section = $MainHbox/CategoryBar/List.get_item_text(index)
		var icon_path = "res://assets/img/settings/" + section + "/" + key + ".png"
		var icon = default_icon
		if FileAccess.file_exists(icon_path):
			icon = load(icon_path)
		$MainHbox/OptionBar.add_item(key, icon)

	$MainHbox/OptionBar.select(0)
	_on_option_bar_item_selected(0)


func _on_category_bar_item_activated(int: Variant) -> void:
	$MainHbox/OptionBar.grab_focus()


func add_bool_option(value: bool) -> void:
	$MainHbox/ValueBar.add_item("Activer", default_icon)
	$MainHbox/ValueBar.add_item("Désactiver", default_icon)

	if value:
		$MainHbox/ValueBar.select(0)
	else:
		$MainHbox/ValueBar.select(1)


func _on_option_bar_item_selected(index: int) -> void:
	$MainHbox/ValueBar.clear()

	var category = index_to_category($MainHbox/CategoryBar.get_selected_item())
	var key = index_to_key(category, index)

	var option = Settings.settings[category][key]
	var option_type = typeof(option)

	if option_type == TYPE_BOOL:
		add_bool_option(option)


func _on_option_bar_item_activated(int: Variant) -> void:
	$MainHbox/ValueBar.grab_focus()

func index_to_key(category: String, index: int) -> String:
	return Settings.settings[category].keys()[index]

func index_to_category(index: int) -> String:
	return Settings.settings.keys()[index]

func get_selected_category() -> String:
	return index_to_category($MainHbox/CategoryBar.get_selected_item())

func get_selected_key() -> String:
	return index_to_key(get_selected_category(), $MainHbox/OptionBar.get_selected_item())
