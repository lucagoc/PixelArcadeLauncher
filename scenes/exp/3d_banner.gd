extends SubViewportContainer


var cover_material = StandardMaterial3D.new()
var selected_game = 0

func rotate_left():
	$SubViewport/YTurn.play("RESET")
	$SubViewport/YTurn.play("rotate_left")

func rotate_right():
	$SubViewport/YTurn.play("RESET")
	$SubViewport/YTurn.play("rotate_right")

func _on_game_selection(id: int):
	selected_game = id
	await get_tree().create_timer(0.1).timeout
	cover_material.albedo_texture = GameList.GAME_LIST[id].banner
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	BusEvent.connect("GAME_SELECTED", _on_game_selection)
	
	$"SubViewport/Box/Cover".set_surface_override_material(0, cover_material)
	cover_material.roughness = 0.23
	
	$SubViewport/XZTurn.play("selected")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
