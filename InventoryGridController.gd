extends Node

var HeldObject
var previousGridPosition:Vector2i
var currentGridPosition:Vector2i
var previousRotation:int
var currentRotation:int
var mouseInGrid:bool
@export var gridCellDict:Dictionary

var gridDimensions:Vector2i
var gridCellSize:Vector2
var gridCellOffset:Vector2
var ignoredGridSquares:Array[TextureRect] # (Optional) Children of GridContainer to be excluded from the AStar grid
@onready var GridRef:GridContainer = $GridContainer
var gridAStar:AStar2D = AStar2D.new()


var dropItem = preload("res://Scenes/Drag Drop Inventory/DragDropItem.tscn")

func _ready():
	gridDimensions = Vector2i(GridRef.columns, GridRef.get_children(false).size()/GridRef.columns)
	gridCellSize = $GridContainer/TextureRect.size
	gridCellOffset = gridCellSize/2
	for _tile in GridRef.get_children(false):
		var _x = GridRef.get_children(false).find(_tile)/GridRef.columns
		var _y = GridRef.get_children(false).find(_tile) - _x*GridRef.columns
		var _gridPos = Vector2i(_x, _y)
		print(_tile.position)
		gridCellDict[_gridPos] = {tileRef = _tile, occupied = false}
		_tile.position = _gridPos
		

func _process(delta):
	$Sprite2D.position = get_viewport().get_mouse_position()
	if Input.is_action_just_pressed("ui_left"):
		CreateItem(preload("res://Resources/Items/Breastplate.tres"))
		
	if Input.is_action_just_pressed("ui_right"):
		CreateItem(preload("res://Resources/Items/Estoc.tres"))
	
	if DragDropController.heldItem:
		$"Hover Panel Seperator/Hover Panel".size = Vector2(DragDropController.heldItem.item.itemDragDropGridSize)*gridCellSize
		$"Hover Panel Seperator/Bad Hover Panel".size = Vector2(DragDropController.heldItem.item.itemDragDropGridSize)*gridCellSize
		
		
		var _gridPos = DragDropController.hoveredTilePos
		var _occupied:bool = true
		var _exists:bool = true
		DragDropController.validDropPos = false
		$"Hover Panel Seperator/Hover Panel".hide()
		$"Hover Panel Seperator/Bad Hover Panel".show()
		for _itemX in DragDropController.heldItem.item.itemDragDropGridSize.y:
			if _itemX+_gridPos.x > gridDimensions.x-1: _exists = false
			for _itemY in DragDropController.heldItem.item.itemDragDropGridSize.x:
				if _itemY+_gridPos.y > gridDimensions.y-1: _exists = false

		if _exists:
			_occupied = false
			for _itemX in DragDropController.heldItem.item.itemDragDropGridSize.y:
				for _itemY in DragDropController.heldItem.item.itemDragDropGridSize.x:
					if gridCellDict[Vector2i( _itemX+_gridPos.x, _itemY+_gridPos.y)].occupied: _occupied = true
			if !_occupied: 
				DragDropController.validDropPos = true
				$"Hover Panel Seperator/Hover Panel".show()
				$"Hover Panel Seperator/Bad Hover Panel".hide()
			
		if _exists:
			$"Hover Panel Seperator/Hover Panel".position = DragDropController.hoveredTile.get_global_rect().position
			$"Hover Panel Seperator/Bad Hover Panel".position = DragDropController.hoveredTile.get_global_rect().position
			
		if (!mouseInGrid):
			$"Hover Panel Seperator/Hover Panel".hide()
			$"Hover Panel Seperator/Bad Hover Panel".hide()
	else:
		$"Hover Panel Seperator/Hover Panel".hide()
		$"Hover Panel Seperator/Bad Hover Panel".hide()
	if $MarginContainer.get_global_rect().has_point(get_viewport().get_mouse_position()): _on_mouse_entered_inventory_grid()
	else: _on_mouse_exited_inventory_grid()



func _on_mouse_entered_inventory_grid():
	mouseInGrid = true
	DragDropController.gridSizeOffset = gridCellOffset
	DragDropController.currentGrid = self


func _on_mouse_exited_inventory_grid():
	mouseInGrid = false

func CreateItem(_item:ItemResource):
	var _dropItem = dropItem.instantiate()
	_dropItem.item = _item
	var _occupied:bool = true
	var _lastGridPos
	var _cellsToOccupy:Array[Vector2i]
	for _x in gridDimensions.x:
		if !_occupied: break
		for _y in gridDimensions.y:
			var _gridPos = Vector2i(_x,_y)
			if !gridCellDict[_gridPos].occupied:
				var _exists:bool = true
				_lastGridPos = _gridPos
				
				for _itemX in _item.itemDragDropGridSize.y:
					if _itemX+_gridPos.x > gridDimensions.x-1: _exists = false
					for _itemY in _item.itemDragDropGridSize.x:
						if _itemY+_gridPos.y > gridDimensions.y-1: _exists = false
						
				if _exists:
					_occupied = false
					_cellsToOccupy.clear()
					for _itemX in _item.itemDragDropGridSize.y:
						for _itemY in _item.itemDragDropGridSize.x:
							if gridCellDict[Vector2i( _itemX+_gridPos.x, _itemY+_gridPos.y)].occupied: _occupied = true
							_cellsToOccupy.append(Vector2i(_itemX+_gridPos.x, _itemY+_gridPos.y))
					if !_occupied: break
			else:
				_occupied = true
				
	if !_occupied:
		_dropItem.setup(gridCellSize)
		add_sibling(_dropItem)
		_dropItem.position = gridCellDict[_lastGridPos].tileRef.get_global_rect().position
		gridCellDict[_lastGridPos].occupied = true
		print(_cellsToOccupy)
		for _cell in _cellsToOccupy:
			gridCellDict[_cell].occupied = true
			gridCellDict[_cell].tileRef.occupied = true
		_dropItem.occupiedCells = _cellsToOccupy
		_dropItem.locationCell = _lastGridPos
	_dropItem = null
	
	
	
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
			DragDropController.validDropPos = true
	return true if _exists and !_occupied else false
