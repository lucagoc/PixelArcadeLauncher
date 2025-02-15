extends HBoxContainer

var selected_category := ""
var category_icons := {}

func _on_category_list_focus_entered() -> void:
	$Click2.play()
	$AnimationPlayer.play("open_category")
	BusEvent.emit_signal("DRAWER_FOCUSED")
	BusEvent.emit_signal("DRAWER_CATEGORY_OPENED")

func _on_category_list_focus_exited() -> void:
	$Click.play()
	$AnimationPlayer.play("close_category")
	BusEvent.emit_signal("DRAWER_CATEGORY_CLOSED")

func _on_game_list_loaded() -> void:
	
	category_icons = {
		tr("ALL"): load("res://assets/img/categories/ALL.png"),
		tr("2PLAYERS"): load("res://assets/img/categories/2PLAYERS.png"),
		tr("ARCADE") : load("res://assets/img/categories/ARCADE.png"),
		tr("BULLETHELL") : load("res://assets/img/categories/BULLETHELL.png"),
		tr("POPULAR") : load("res://assets/img/categories/POPULAR.png"),
		tr("RHYTHM") : load("res:////assets/img/categories/RHYTHM.png"),
		tr("SOFTWARE") : load("res://assets/img/categories/SOFTWARE.png"),
		tr("STM") : load("res://assets/img/categories/STM.png"),
		tr("PICO-8") : load("res://assets/img/categories/PICO-8.png"),
		tr("FRENCH") : load("res://assets/img/categories/FRENCH.png"),
		tr("JAPANESE") : load("res://assets/img/categories/JAPANESE.png"),
		tr("PC") : load("res://assets/img/categories/PC.png"),
		tr("FIGHTING") : load("res://assets/img/categories/FIGHTING.png"),
		tr("PLATFORM") : load("res://assets/img/categories/PLATFORM.png"),
		tr("PUZZLE") : load("res://assets/img/categories/PUZZLE.png"),
		tr("RACING") : load("res://assets/img/categories/RACING.png"),
		tr("ZZ") : load("res://assets/img/categories/ZZ.png"),
		"PLACEHOLDER" : load("res://assets/img/categories/PLACEHOLDER.png")
	}
	
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
