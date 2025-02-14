extends RichTextLabel


func _ready() -> void:
	BusEvent.connect("LOADING_SCREEN_ENDED", _on_loading_ended)

func _on_loading_ended():
	text = tr("CREDITS_MAIN") + "\n"
	text += tr("CREDITS_LICENCE") + "\n"
	text += tr("CREDITS_CONTRIBUTE") + "\n" + "\n"
	text += tr("CREDITS_THANKS")
