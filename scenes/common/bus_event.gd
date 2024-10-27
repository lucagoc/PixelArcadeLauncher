##############################################################
#                     Bus Event System                       #
#          This file contains global signals to send         #
##############################################################

extends Node

var print_debug_info: bool = false

# States signals
@warning_ignore("unused_signal")
signal GAME_LIST_LOADED
@warning_ignore("unused_signal")
signal GAME_LAUNCHED(id: int)       # When a game is launched
@warning_ignore("unused_signal")
signal GAME_EXITED(id: int)         # When a game is exited
@warning_ignore("unused_signal")
signal GAME_SELECTED(id: int)       # When a game is selected (indepedent of the context menu)
@warning_ignore("unused_signal")
signal GAME_DESELECTED(id: int)     # When a game is deselected (indepedent of the context menu)
@warning_ignore("unused_signal")
signal DRAWER_RELOADED              # Drawer reloaded
@warning_ignore("unused_signal")
signal DRAWER_FOCUSED               # Drawer focused
@warning_ignore("unused_signal")
signal DRAWER_CATEGORY_OPENED       # Drawer category opened
@warning_ignore("unused_signal")
signal DRAWER_CATEGORY_CLOSED       # Drawer category closed
@warning_ignore("unused_signal")
signal BANNER_MENU_RELOADED         # Banner menu loaded/reloaded
@warning_ignore("unused_signal")
signal BANNER_MENU_FOCUSED          # Banner menu focused
@warning_ignore("unused_signal")
signal BANNER_SELECTED(id: int)     # Banner selected
@warning_ignore("unused_signal")
signal SCALING_CHANGED				# Scaling changed

# Action signals
@warning_ignore("unused_signal")
signal CENTER_SELECTED_BANNER  		# Center the screen on a banner
@warning_ignore("unused_signal")
signal SELECT_GAME(id: int)         # Select a game

func _on_game_list_loaded() -> void:
	print("[SIGNAL] Game list loaded")

func _on_game_launched(id: int) -> void:
	print("[SIGNAL] Game launched: ", id)

func _on_game_exited(id: int) -> void:
	print("[SIGNAL] Game exited: ", id)

func _on_game_selected(id: int) -> void:
	print("[SIGNAL] Game selected: ", id)

func _on_game_deselected(id: int) -> void:
	print("[SIGNAL] Game deselected: ", id)

func _on_drawer_reloaded() -> void:
	print("[SIGNAL] Drawer reloaded")

func _on_drawer_focused() -> void:
	print("[SIGNAL] Drawer opened")

func _on_drawer_category_opened() -> void:
	print("[SIGNAL] Drawer category opened")

func _on_drawer_category_closed() -> void:
	print("[SIGNAL] Drawer category closed")

func _on_banner_menu_reloaded() -> void:
	print("[SIGNAL] Banner menu reloaded")

func _on_banner_menu_focused() -> void:
	print("[SIGNAL] Banner menu focused")

func _on_banner_selection(id: int) -> void:
	print("[SIGNAL] Banner selected: ", id)

func _on_scaling_changed() -> void:
	print("[SIGNAL] Scaling changed")

func _on_center_selected_banner() -> void:
	print("[SIGNAL] Centered banner")

func _on_select_game(id: int) -> void:
	print("[SIGNAL] Select game: ", id)

func _ready() -> void:
	if print_debug_info:
		# State signals
		connect("GAME_LIST_LOADED", _on_game_list_loaded)
		connect("GAME_LAUNCHED", _on_game_launched)
		connect("GAME_EXITED", _on_game_exited)
		connect("GAME_SELECTED", _on_game_selected)
		connect("GAME_DESELECTED", _on_game_deselected)
		connect("DRAWER_RELOADED", _on_drawer_reloaded)
		connect("DRAWER_FOCUSED", _on_drawer_focused)
		connect("DRAWER_CATEGORY_OPENED", _on_drawer_category_opened)
		connect("DRAWER_CATEGORY_CLOSED", _on_drawer_category_closed)
		connect("BANNER_MENU_RELOADED", _on_banner_menu_reloaded)
		connect("BANNER_MENU_FOCUSED", _on_banner_menu_focused)
		connect("BANNER_SELECTED", _on_banner_selection)
		connect("SCALING_CHANGED", _on_scaling_changed)

		# Action signals
		connect("CENTER_SELECTED_BANNER", _on_center_selected_banner)
		connect("SELECT_GAME", _on_select_game)