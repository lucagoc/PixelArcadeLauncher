extends ColorRect

signal item_selected(int)
signal item_activated(int)

func select(index):
	$List.select(index)

func clear():
	$List.clear()

func add_item(name, icon):
	$List.add_item(name, icon)

func _on_list_focus_entered() -> void:
	$Animation.play("open")

func _on_list_focus_exited() -> void:
	$Animation.play("close")

func _on_list_item_selected(index: int) -> void:
	emit_signal("item_selected", index)

func _on_list_item_activated(index: int) -> void:
	emit_signal("item_activated", index)

func get_selected_item():
	return $List.get_selected_items()[0]

func _on_focus_entered() -> void:
	$List.grab_focus()
