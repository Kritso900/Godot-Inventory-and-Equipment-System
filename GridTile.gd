extends Node
var position:Vector2i
var occupied:bool

func _process(delta):
	if $".".get_global_rect().has_point(get_viewport().get_mouse_position()):
		_on_mouse_entered()
	$LabelPos.text = str(position)
	$LabelOcc.text = "Yes" if occupied else "No"
	pass

func _on_mouse_entered():
	DragDropController.hoveredTile = self
