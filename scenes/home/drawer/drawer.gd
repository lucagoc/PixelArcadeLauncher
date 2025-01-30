extends HBoxContainer

var selected_category := ""
var category_icons := {}  # Dictionnaire pour stocker les icônes

func _on_category_list_focus_entered() -> void:
	$Click2.play()
	$AnimationPlayer.play("open_category")
	BusEvent.emit_signal("DRAWER_FOCUSED")
	BusEvent.emit_signal("DRAWER_CATEGORY_OPENED")

func _on_category_list_focus_exited() -> void:
	$Click.play()
	$AnimationPlayer.play("close_category")
	BusEvent.emit_signal("DRAWER_CATEGORY_CLOSED")

func _load_all_category_icons() -> void:
	var dir = DirAccess.open("res://assets/img/categories/")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".png"):
				var category_name = file_name.trim_suffix(".png")
				category_icons[tr(category_name)] = load("res://assets/img/categories/" + file_name)
			file_name = dir.get_next()

func _on_game_list_loaded() -> void:
	$ItemList.clear()
	for game in GameList.GAME_LIST:
		$ItemList.add_item(game.name, game.icon)

	# Clear the category list
	$CategoryBar/CategoryList.clear()

	# Ajouter les catégories avec leur icône correspondante si disponible
	for category in GameList.games_by_category.keys():
		var icon = category_icons.get(category, category_icons.get("PLACEHOLDER"))
		$CategoryBar/CategoryList.add_item(" " + category, icon)

	$CategoryBar/CategoryList.select(0) # Sélectionne la première catégorie
	selected_category = tr("ALL")

func _on_start_screensaver():
	$CategoryBar/CategoryList.focus_mode = FOCUS_NONE
	$ItemList.focus_mode = FOCUS_NONE

func _on_stop_screensaver():
	$CategoryBar/CategoryList.focus_mode = FOCUS_ALL
	$ItemList.focus_mode = FOCUS_ALL

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready() -> void:
	BusEvent.connect("GAME_LIST_LOADED", _on_game_list_loaded)
	BusEvent.connect("START_SCREENSAVER", _on_start_screensaver)
	BusEvent.connect("STOP_SCREENSAVER", _on_stop_screensaver)
	
	_load_all_category_icons()

func _on_item_list_focus_entered() -> void:
	BusEvent.emit_signal("DRAWER_FOCUSED")

func _on_item_list_item_selected(index: int) -> void:
	$Click.play()
	index = GameList.get_games_by_category(selected_category)[index].id		# Get the game ID
	BusEvent.emit_signal("GAME_SELECTED", index)

func _on_item_list_item_activated(index: int) -> void:
	index = GameList.get_games_by_category(selected_category)[index].id 	# Get the game ID
	if not IdleManager.screensaver:
		BusEvent.emit_signal("GAME_LAUNCHED", index)

func _on_category_list_item_selected(index: int) -> void:
	selected_category = $CategoryBar/CategoryList.get_item_text(index).strip_edges()
	var games = GameList.get_games_by_category(selected_category)
	$Click2.play()
	$ItemList.clear()
	for game in games:
		$ItemList.add_item(game.name, game.icon)

	$ItemList.select(0)
