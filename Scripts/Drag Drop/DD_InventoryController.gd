### This script is an auto-load script that can be easily accessed everywhere in the project
### It controls the movement of DD_GridItems on the grid of the drag drop inventory
extends Node

# The item currently held
var heldItem:DD_GridItem

# An offset that can be used to easily get the center of each grid tile
var gridSizeOffset:Vector2

# The most recent grid interacted with
var currentGrid:DD_GridController

# The last tile hovered over
var hoveredTile:DD_GridTile

# The grid position of the last hovered tile
var hoveredTilePos:Vector2i

# If the current position is valid for the held item to be placed
var validDropPos:bool

# Allows other scripts to get a reference to this auto-load script
func GetControllerRef():
	return self

func _process(delta):
	
	# Checks if an item is held
	if (heldItem):
		# Sets the item node's position to the mouse affected by the grid offset
		heldItem.position = get_viewport().get_mouse_position() - currentGrid.gridCellOffset
		
		# Checks if the hovered cell is inside the current grid
		for _cellPos in currentGrid.gridCellDict:
			if hoveredTile == currentGrid.gridCellDict[_cellPos].tileRef:
				# Gets the hovered cell's position in the grid
				hoveredTilePos = _cellPos

# Called when clicking on an item
func PickUp(item:DD_GridItem):
	
	# Checks an item isn't currently held
	if !heldItem:
		
		# Sets the item clicked on as being held
		heldItem = item
		
		# Sets all the cells the item occupied to unoccupied
		for _cell in item.occupiedCells:
			currentGrid.gridCellDict[_cell].occupied = false
			currentGrid.gridCellDict[_cell].tileRef.occupied = false

# Called when clicking if an item is held
func Place(item:DD_GridItem):
	var _dropTilePos = hoveredTilePos
	var _dropTile = hoveredTile
	
	# Checks if the item is in a valid place to be placed
	if currentGrid.IsItemGridPosValid(item,_dropTilePos):
		# Sets the item to not be held
		heldItem = null
		
		# Sets the item's position to the position of the hovered tile so it fits into the grid
		item.position = currentGrid.gridCellDict[hoveredTilePos].tileRef.get_global_rect().position
		
		# Resets the cell the item knows it occupies
		item.occupiedCells.clear()
		
		# Sets all the cells the item would occupy to occupied
		for _itemX in item.item.itemDragDropGridSize.y:
			for _itemY in item.item.itemDragDropGridSize.x:
				item.occupiedCells.append(Vector2i( _itemX+_dropTilePos.x, _itemY+_dropTilePos.y))
				currentGrid.gridCellDict[Vector2i( _itemX+_dropTilePos.x, _itemY+_dropTilePos.y)].occupied = true
				currentGrid.gridCellDict[Vector2i( _itemX+_dropTilePos.x, _itemY+_dropTilePos.y)].tileRef.occupied = true

# Removes the given item from the inventory
func Destroy(item:DD_GridItem):
	item.get_parent().remove_child(item)
	heldItem = null
