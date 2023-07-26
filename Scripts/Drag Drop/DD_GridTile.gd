### This script is used for the tiles that make up the grid of the drag drop inventory
extends Node

class_name DD_GridTile

# Position of the tile in the grid
var position:Vector2i

# If the grid tile is occupied
var occupied:bool

# Shows the tile's position and if it's occupied, delete this function to remove the text from the tiles
func _process(delta):
	if $".".get_global_rect().has_point(get_viewport().get_mouse_position()):
		_on_mouse_entered()
	$LabelPos.text = str(position)
	$LabelOcc.text = "Yes" if occupied else "No"
	pass

# Updates the inventory controller on which tile the mouse is hovering over
func _on_mouse_entered():
	DD_InventoryController.hoveredTile = self
