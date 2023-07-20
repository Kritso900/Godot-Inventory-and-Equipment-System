extends Node

var heldItem:Node
var gridSizeOffset:Vector2
var currentGrid:Node
var hoveredTile:Node
var hoveredTilePos:Vector2i
var validDropPos:bool

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
