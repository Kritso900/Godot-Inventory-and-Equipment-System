extends Node

var HeldObject
var previousGridPosition:Vector2i
var currentGridPosition:Vector2i
var previousRotation:int
var currentRotation:int
var mouseInGrid:bool
var gridCellDict:Dictionary

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
		gridCellDict[_gridPos] = {tileRef = _tile, occupied = false}
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
	CreateItem(preload("res://Resources/Items/Estoc.tres"))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Sprite2D.position = get_viewport().get_mouse_position()
	

var grabbed = Callable(self, "Grab")
var released = Callable(self, "Release")

func PickUp(item:Node):
	### Called when an item is picked up from this inventory
	pass

func Place(item:Node):
	pass
	
	
	
	
func GetMouseLocationOnGrid():
	return Vector2i.ZERO # Put code here




func _on_mouse_entered_inventory_grid():
	mouseInGrid = true


func _on_mouse_exited_inventory_grid():
	mouseInGrid = false

func CreateItem(_item:ItemResource):
	var _dropItem = dropItem.instantiate()
	gridCellDict[Vector2i(3,3)].occupied = true
	var _occupied:bool = false
	for _gridPos in gridCellDict:
		if !gridCellDict[_gridPos].occupied:
			var _exists:bool = true
		
			for _gridPoss in _item.itemDragDropGridSize.x:
				if _gridPoss != 0: if _gridPoss+_gridPos.x > gridDimensions.x-1: _exists = false
			for _gridPoss in _item.itemDragDropGridSize.y:
				if _gridPoss != 0: if _gridPoss+_gridPos.y > gridDimensions.y-1: _exists = false
				
			if _exists:
				
				for _gridPoss in _item.itemDragDropGridSize.x:
					if _gridPoss != 0: if gridCellDict[_gridPoss+_gridPos.x].occupied: _occupied = true
					for _gridPosss in _item.itemDragDropGridSize.y:
						if _gridPosss != 0: if gridCellDict[Vector2i(_gridPos.x + _gridPoss, _gridPos.y + _gridPosss)].occupied: _occupied = true
				
				#if _gridPos.x + _gridPoss.x > gridDimensions.x:
				#	pass
				#if gridCellDict[_gridPos + _gridPoss].occupied:
				#	_occupied = true
		else:
			_occupied = true
	print(_occupied)
	_dropItem.setup(gridCellSize)
