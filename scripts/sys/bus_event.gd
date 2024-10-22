##############################################################
#                     Bus Event System                       #
#          This file contains global signals to send         #
##############################################################

extends Node

signal GAME_LIST_LOAD_SUCCESSFULL   # Game list loaded
signal GAME_LIST_LOAD_FAILURE       # Game list loaded

signal GAME_LAUNCHED(id: int)       # When a game is launched
signal GAME_SELECTED(id: int)       # When a game is selected (indepedent of the context menu)
signal GAME_DESELECTED(id: int)     # When a game is deselected (indepedent of the context menu)

signal DRAWER_RELOADED              # Drawer reloaded
signal DRAWER_OPENED                # Drawer opened
signal DRAWER_CLOSED                # Drawer closed
signal DRAWER_CATEGORY_OPENED       # Drawer category opened
signal DRAWER_CATEGORY_CLOSED       # Drawer category closed

signal BANNER_MENU_RELOADED         # Banner menu loaded/reloaded
signal BANNER_MENU_FOCUSED          # Banner menu focused
