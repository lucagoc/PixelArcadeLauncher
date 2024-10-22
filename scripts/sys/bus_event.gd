##############################################################
#                     Bus Event System                       #
#          This file contains global signals to send         #
##############################################################

extends Node

signal GAME_LIST_LOADED

signal GAME_LAUNCHED(id: int)       # When a game is launched
signal GAME_EXITED(id: int)         # When a game is exited
signal GAME_SELECTED(id: int)       # When a game is selected (indepedent of the context menu)
signal GAME_DESELECTED(id: int)     # When a game is deselected (indepedent of the context menu)

signal DRAWER_RELOADED              # Drawer reloaded
signal DRAWER_OPENED                # Drawer opened
signal DRAWER_CLOSED                # Drawer closed
signal DRAWER_CATEGORY_OPENED       # Drawer category opened
signal DRAWER_CATEGORY_CLOSED       # Drawer category closed

signal BANNER_MENU_RELOADED         # Banner menu loaded/reloaded
signal BANNER_MENU_FOCUSED          # Banner menu focused

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

func _on_drawer_opened() -> void:
    print("[SIGNAL] Drawer opened")

func _on_drawer_closed() -> void:
    print("[SIGNAL] Drawer closed")

func _on_drawer_category_opened() -> void:
    print("[SIGNAL] Drawer category opened")

func _on_drawer_category_closed() -> void:
    print("[SIGNAL] Drawer category closed")

func _on_banner_menu_reloaded() -> void:
    print("[SIGNAL] Banner menu reloaded")

func _on_banner_menu_focused() -> void:
    print("[SIGNAL] Banner menu focused")

func _ready() -> void:
    connect("GAME_LIST_LOADED", _on_game_list_loaded)

    connect("GAME_LAUNCHED", _on_game_launched)
    connect("GAME_EXITED", _on_game_exited)
    connect("GAME_SELECTED", _on_game_selected)
    connect("GAME_DESELECTED", _on_game_deselected)
    
    connect("DRAWER_RELOADED", _on_drawer_reloaded)
    connect("DRAWER_OPENED", _on_drawer_opened)
    connect("DRAWER_CLOSED", _on_drawer_closed)
    connect("DRAWER_CATEGORY_OPENED", _on_drawer_category_opened)
    connect("DRAWER_CATEGORY_CLOSED", _on_drawer_category_closed)

    connect("BANNER_MENU_RELOADED", _on_banner_menu_reloaded)
    connect("BANNER_MENU_FOCUSED", _on_banner_menu_focused)
