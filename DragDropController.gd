extends Node

var HeldItem:Node
@onready var gridControllerRef = find_child("InventoryGridController")

# Called when the node enters the scene tree for the first time.
func _ready():
	#CreateItem(dropItem)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (HeldItem):
		HeldItem.position = get_viewport().get_mouse_position() - HeldItem.imageRef.size/2
		
		

var dropItem = preload("res://Scenes/Drag Drop Inventory/DragDropItem.tscn")
func CreateItem(_item:ItemResource):
	var _dropItem = dropItem.instantiate()
	_dropItem.item = _item
	gridControllerRef.gridCellDict[Vector2i(3,3)].occupied = true
	var _occupied:bool = false
	for _gridPos in gridControllerRef.gridCellDict:
		if !gridControllerRef.gridCellDict[_gridPos].occupied:
			var _exists:bool = true
		
			for _gridPoss in _item.itemDragDropGridSize.x:
				if _gridPoss != 0: if _gridPoss+_gridPos.x > gridControllerRef.gridDimensions.x-1: _exists = false
			for _gridPoss in _item.itemDragDropGridSize.y:
				if _gridPoss != 0: if _gridPoss+_gridPos.y > gridControllerRef.gridDimensions.y-1: _exists = false
				
			if _exists:
				
				for _gridPoss in _item.itemDragDropGridSize.x:
					if _gridPoss != 0: if gridControllerRef.gridCellDict[_gridPoss+_gridPos.x].occupied: _occupied = true
					for _gridPosss in _item.itemDragDropGridSize.y:
						if _gridPosss != 0: if gridControllerRef.gridCellDict[Vector2i(_gridPos.x + _gridPoss, _gridPos.y + _gridPosss)].occupied: _occupied = true
				
				#if _gridPos.x + _gridPoss.x > gridDimensions.x:
				#	pass
				#if gridCellDict[_gridPos + _gridPoss].occupied:
				#	_occupied = true
		else:
			_occupied = true
	print(_occupied)
	_dropItem.setup(gridControllerRef.gridCellSize)
	add_child(_dropItem)
