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

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.inventoryItemPickup.connect(grabbed)
	SignalBus.inventoryItemPlace.connect(released)
	gridDimensions = Vector2i(GridRef.columns, GridRef.get_children(false).size()/GridRef.columns)
	#if GridRef.get_children(false).size()%GridRef.columns: push_error("Grid is not a rectangle, please fix this")
	gridCellSize = $GridContainer/TextureRect.size
	gridCellOffset = gridCellSize/2
	for _tile in GridRef.get_children(false):
		var _x = GridRef.get_children(false).find(_tile)/GridRef.columns
		var _y = GridRef.get_children(false).find(_tile) - _x*GridRef.columns
		var _gridPos = Vector2i(_x, _y)
		print(_tile.position)
		gridCellDict[_gridPos] = {tileRef = _tile, occupied = false}
		_tile.position = _gridPos
		
	
#	for _tile in GridRef.get_children(false):
#		var tile:TextureRect = _tile
#		if ignoredGridSquares.find(_tile) == -1:
#			var _id = GridRef.get_children(false).find(_tile)
#
#			var _x = GridRef.get_children(false).find(_tile)/GridRef.columns
#			var _y = GridRef.get_children(false).find(_tile) - _x*GridRef.columns
#			var _gridPos = Vector2i(_x, _y)
#			gridAStar.add_point(_id, (Vector2(_gridPos)*gridCellSize)+gridCellSize+GridRef.global_position)
#
#			var _dropItem = dropItem.instantiate()
#			add_sibling(_dropItem)
#			pass
#
#		pass
	
	for _x in gridDimensions.x:
		for _y in gridDimensions.y:
			pass
	
	
	pass # Replace with function body.

var dropItemType = preload("res://Resources/Items/Breastplate.tres")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Sprite2D.position = get_viewport().get_mouse_position()
	if Input.is_action_just_pressed("ui_left"):
		CreateItem(preload("res://Resources/Items/Breastplate.tres"))
		
	if Input.is_action_just_pressed("ui_right"):
		CreateItem(preload("res://Resources/Items/Estoc.tres"))
	if Input.is_action_just_pressed("ui_down"):
		
		print(gridCellDict[Vector2i(0,0)].occupied, gridCellDict[Vector2i(0,1)].occupied,gridCellDict[Vector2i(0,2)].occupied,gridCellDict[Vector2i(0,3)].occupied,gridCellDict[Vector2i(0,4)].occupied,gridCellDict[Vector2i(0,5)].occupied)
		print(gridCellDict[Vector2i(1,0)].occupied, gridCellDict[Vector2i(1,1)].occupied,gridCellDict[Vector2i(1,2)].occupied,gridCellDict[Vector2i(1,3)].occupied,gridCellDict[Vector2i(1,4)].occupied,gridCellDict[Vector2i(1,5)].occupied)

var grabbed = Callable(self, "Grab")
var released = Callable(self, "Release")

func PickUp(item:Node):
	### Called when an item is picked up from this inventory
	pass

func Place(item:Node, _gridTile:Vector2i):
	
	pass
	
	
	
	
func GetMouseLocationOnGrid():
	return Vector2i.ZERO # Put code here




func _on_mouse_entered_inventory_grid():
	mouseInGrid = true


func _on_mouse_exited_inventory_grid():
	mouseInGrid = false

func CreateItem(_item:ItemResource):
	var _dropItem = dropItem.instantiate()
	_dropItem.item = _item
	#gridCellDict[Vector2i(1,0)].occupied = true
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
	_dropItem = null
	
