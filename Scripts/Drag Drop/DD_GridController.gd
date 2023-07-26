### This script is used for the grid of the drag drop inventory
extends Node

class_name DD_GridController

# If the mouse is currently inside the inventory grid
var mouseInGrid:bool

# Dictionary used as a reference for all grid squares and if they're occupied
@export var gridCellDict:Dictionary

# The grid dimentions of this grid, x = columns, y = rows
var gridDimensions:Vector2i

# Size of each grid tile, the example project uses 64x64 sprites
var gridCellSize:Vector2

# An offset that can be used to easily get the center of each grid tile
var gridCellOffset:Vector2

# A reference to the grid node
@onready var GridRef:GridContainer = $GridContainer

# A reference to the Grid Item node that will be instantiated when creating a new grid item
var dropItem = preload("res://Scenes/Drag Drop/DD_GridItem.tscn")

func _ready():
	gridDimensions = Vector2i(GridRef.columns, GridRef.get_children(false).size()/GridRef.columns)
	gridCellSize = $GridContainer/TextureRect.size
	gridCellOffset = gridCellSize/2
	
	# Sets up the gridCellDict dictionary
	for _tile in GridRef.get_children(false):
		var _x = GridRef.get_children(false).find(_tile)/GridRef.columns
		var _y = GridRef.get_children(false).find(_tile) - _x*GridRef.columns
		var _gridPos = Vector2i(_x, _y)
		gridCellDict[_gridPos] = {tileRef = _tile, occupied = false}
		_tile.position = _gridPos
		

func _process(delta):
	$Sprite2D.position = get_viewport().get_mouse_position()
	
	# DEBUG
	if Input.is_action_just_pressed("ui_left"):
		CreateItem(preload("res://Resources/Items/Breastplate.tres"))
	
	# DEBUG
	if Input.is_action_just_pressed("ui_right"):
		CreateItem(preload("res://Resources/Items/Estoc.tres"))
	
	# DEBUG
	if Input.is_action_just_pressed("ui_down"):
		CreateItem(preload("res://Resources/Items/Potion.tres"))
	
	if DD_InventoryController.heldItem:
		# Sets the size of the hover panels to the same as the held item
		$"Hover Panel Seperator/Hover Panel".size = Vector2(DD_InventoryController.heldItem.item.itemDragDropGridSize)*gridCellSize
		$"Hover Panel Seperator/Bad Hover Panel".size = Vector2(DD_InventoryController.heldItem.item.itemDragDropGridSize)*gridCellSize
		
		
		var _gridPos = DD_InventoryController.hoveredTilePos
		var _occupied:bool = true
		var _exists:bool = true
		DD_InventoryController.validDropPos = false
		
		# Sets the hover panels to show the bad panel, if a valid position is given this is changed
		$"Hover Panel Seperator/Hover Panel".hide()
		$"Hover Panel Seperator/Bad Hover Panel".show()
		# Checks if the item currently held is out of bounds of the grid
		for _itemX in DD_InventoryController.heldItem.item.itemDragDropGridSize.y:
			if _itemX+_gridPos.x > gridDimensions.x-1: _exists = false
			for _itemY in DD_InventoryController.heldItem.item.itemDragDropGridSize.x:
				if _itemY+_gridPos.y > gridDimensions.y-1: _exists = false

		if _exists:
			_occupied = false
			# Checks if the item currently held is overlapping with any other items
			for _itemX in DD_InventoryController.heldItem.item.itemDragDropGridSize.y:
				for _itemY in DD_InventoryController.heldItem.item.itemDragDropGridSize.x:
					if gridCellDict[Vector2i( _itemX+_gridPos.x, _itemY+_gridPos.y)].occupied: 
						_occupied = true
			
			# If the position is not overlapping then only show the good hover panel
			if !_occupied: 
				DD_InventoryController.validDropPos = true
				$"Hover Panel Seperator/Hover Panel".show()
				$"Hover Panel Seperator/Bad Hover Panel".hide()
		
		# If the item is in bounds of the grid, move the hover panels to show the item's drop position
		if _exists:
			$"Hover Panel Seperator/Hover Panel".position = DD_InventoryController.hoveredTile.get_global_rect().position
			$"Hover Panel Seperator/Bad Hover Panel".position = DD_InventoryController.hoveredTile.get_global_rect().position
		
		# If the mouse has left the grid, hide the hover panels
		if (!mouseInGrid):
			$"Hover Panel Seperator/Hover Panel".hide()
			$"Hover Panel Seperator/Bad Hover Panel".hide()
	
	# If an item is not being held, hide hover panels
	else:
		$"Hover Panel Seperator/Hover Panel".hide()
		$"Hover Panel Seperator/Bad Hover Panel".hide()
		
	# Checks if the mouse is inside the inventory grid
	if $MarginContainer.get_global_rect().has_point(get_viewport().get_mouse_position()): 
		_on_mouse_entered_inventory_grid()
	else: _on_mouse_exited_inventory_grid()


# Called each frame the mouse is inside the grid
func _on_mouse_entered_inventory_grid():
	mouseInGrid = true
	DD_InventoryController.gridSizeOffset = gridCellOffset
	DD_InventoryController.currentGrid = self

# Called each from the mouse is outside the grid
func _on_mouse_exited_inventory_grid():
	mouseInGrid = false

# Called when creating a new item, places it in the first position it will fit
# If the item doesn't fit returns null
func CreateItem(_item:ItemResource):
	var _dropItem:DD_GridItem = dropItem.instantiate()
	_dropItem.item = _item
	var _occupied:bool = true
	var _lastGridPos:Vector2i
	var _cellsToOccupy:Array[Vector2i]
	for _x in gridDimensions.x:
		if !_occupied: break
		for _y in gridDimensions.y:
			var _gridPos = Vector2i(_x,_y)
			# Ignores any tiles that are already occupied
			if !gridCellDict[_gridPos].occupied:
				var _exists:bool = true
				_lastGridPos = _gridPos
				
				# Checks if the item would be out of bounds of the grid
				for _itemX in _item.itemDragDropGridSize.y:
					if _itemX+_gridPos.x > gridDimensions.x-1: _exists = false
					for _itemY in _item.itemDragDropGridSize.x:
						if _itemY+_gridPos.y > gridDimensions.y-1: _exists = false
				
				if _exists:
					_occupied = false
					_cellsToOccupy.clear()
					
					# Checks if the tiles the item will fill are occuped
					for _itemX in _item.itemDragDropGridSize.y:
						for _itemY in _item.itemDragDropGridSize.x:
							if gridCellDict[Vector2i( _itemX+_gridPos.x, _itemY+_gridPos.y)].occupied: _occupied = true
							_cellsToOccupy.append(Vector2i(_itemX+_gridPos.x, _itemY+_gridPos.y))
					# If a valid position is found break out of the inital loop
					if !_occupied: break
			else:
				_occupied = true
	
	# If the position is valid then place the item
	if !_occupied:
		_dropItem.setup(gridCellSize)
		
		# Adds the item to the scene tree
		add_sibling(_dropItem)
		
		# Places the item in the position of the tile where the search started, this is the top left of the item
		_dropItem.position = gridCellDict[_lastGridPos].tileRef.get_global_rect().position
		gridCellDict[_lastGridPos].occupied = true
		
		# Sets all cells the item fills to be occupied, preventing overlaps
		for _cell in _cellsToOccupy:
			gridCellDict[_cell].occupied = true
			gridCellDict[_cell].tileRef.occupied = true
		
		# Tells the item where it is on the grid to make picking it up simpler
		_dropItem.occupiedCells = _cellsToOccupy
		_dropItem.locationCell = _lastGridPos
	
	# If a valid location could not be found then deletes the item
	else: 
		_dropItem.queue_free()
		_dropItem = null
		
	# Returns the item node if it was placed, or null if a position could not be found
	return _dropItem

# Checks if the given item can be placed in the given location
func IsItemGridPosValid(_item:Node, _pos:Vector2i):
	var _exists = true
	var _occupied
	
	for _itemX in _item.item.itemDragDropGridSize.y:
		if _itemX+_pos.x > gridDimensions.x-1: _exists = false
		for _itemY in _item.item.itemDragDropGridSize.x:
			if _itemY+_pos.y > gridDimensions.y-1: _exists = false

	if _exists:
		_occupied = false
		for _itemX in _item.item.itemDragDropGridSize.y:
			for _itemY in _item.item.itemDragDropGridSize.x:
				if gridCellDict[Vector2i( _itemX+_pos.x, _itemY+_pos.y)].occupied: _occupied = true
		if !_occupied: 
			DD_InventoryController.validDropPos = true
	return true if _exists and !_occupied else false
