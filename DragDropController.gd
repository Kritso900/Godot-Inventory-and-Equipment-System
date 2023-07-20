extends Node

var heldItem:Node
var gridSizeOffset:Vector2
var currentGrid:Node
var hoveredTile:Node
var hoveredTilePos:Vector2i
var validDropPos:bool


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (heldItem and currentGrid):
		heldItem.position = get_viewport().get_mouse_position() - currentGrid.gridCellOffset# - gridContainerRef.gridDimensions/2
		for _cellPos in currentGrid.gridCellDict:
			if hoveredTile == currentGrid.gridCellDict[_cellPos].tileRef:
				hoveredTilePos = _cellPos
				
		
		

func PickUp(item:Node):
	if !heldItem:
		heldItem = item
		for _cell in item.occupiedCells:
			currentGrid.gridCellDict[_cell].occupied = false
			currentGrid.gridCellDict[_cell].tileRef.occupied = false

func Place(item:Node):
	var _dropTilePos = hoveredTilePos
	var _dropTile = hoveredTile
	if currentGrid.IsItemGridPosValid(item,_dropTilePos):
		heldItem = null
		item.position = currentGrid.gridCellDict[hoveredTilePos].tileRef.get_global_rect().position
		item.occupiedCells.clear()
		for _itemX in item.item.itemDragDropGridSize.y:
			for _itemY in item.item.itemDragDropGridSize.x:
				item.occupiedCells.append(Vector2i( _itemX+_dropTilePos.x, _itemY+_dropTilePos.y))
				currentGrid.gridCellDict[Vector2i( _itemX+_dropTilePos.x, _itemY+_dropTilePos.y)].occupied = true
				currentGrid.gridCellDict[Vector2i( _itemX+_dropTilePos.x, _itemY+_dropTilePos.y)].tileRef.occupied = true

#var dropItem = preload("res://Scenes/Drag Drop Inventory/DragDropItem.tscn")
#func CreateItem(_item:ItemResource):
#	var _dropItem = dropItem.instantiate()
#	_dropItem.item = _item
#	gridControllerRef.gridCellDict[Vector2i(3,3)].occupied = true
#	var _occupied:bool = false
#	for _gridPos in gridControllerRef.gridCellDict:
#		if !gridControllerRef.gridCellDict[_gridPos].occupied:
#			var _exists:bool = true
#
#			for _gridPoss in _item.itemDragDropGridSize.x:
#				if _gridPoss != 0: if _gridPoss+_gridPos.x > gridControllerRef.gridDimensions.x-1: _exists = false
#			for _gridPoss in _item.itemDragDropGridSize.y:
#				if _gridPoss != 0: if _gridPoss+_gridPos.y > gridControllerRef.gridDimensions.y-1: _exists = false
#
#			if _exists:
#
#				for _gridPoss in _item.itemDragDropGridSize.x:
#					if _gridPoss != 0: if gridControllerRef.gridCellDict[_gridPoss+_gridPos.x].occupied: _occupied = true
#					for _gridPosss in _item.itemDragDropGridSize.y:
#						if _gridPosss != 0: if gridControllerRef.gridCellDict[Vector2i(_gridPos.x + _gridPoss, _gridPos.y + _gridPosss)].occupied: _occupied = true
#
#				#if _gridPos.x + _gridPoss.x > gridDimensions.x:
#				#	pass
#				#if gridCellDict[_gridPos + _gridPoss].occupied:
#				#	_occupied = true
#		else:
#			_occupied = true
#	print(_occupied)
#	_dropItem.setup(gridControllerRef.gridCellSize)
#	add_child(_dropItem)
