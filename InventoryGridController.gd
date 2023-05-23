extends Node

var HeldObject
var previousGridPosition:Vector2i
var currentGridPosition:Vector2i
var previousRotation:int
var currentRotation:int
var mouseInGrid:bool


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
	gridDimensions = Vector2i(GridRef.columns, GridRef.get_children(false).size()/GridRef.columns)
	#if GridRef.get_children(false).size()%GridRef.columns: push_error("Grid is not a rectangle, please fix this")
	print(gridDimensions)
	gridCellSize = $GridContainer/TextureRect.size
	gridCellOffset = gridCellSize/2
	for _tile in GridRef.get_children(false):
		var tile:TextureRect = _tile
		if ignoredGridSquares.find(_tile) == -1:
			var _id = GridRef.get_children(false).find(_tile)
			
			var _x = GridRef.get_children(false).find(_tile)/GridRef.columns
			var _y = GridRef.get_children(false).find(_tile) - _x*GridRef.columns
			var _gridPos = Vector2i(_x, _y)
			gridAStar.add_point(_id, (Vector2(_gridPos)*gridCellSize)+gridCellSize+GridRef.global_position)
			
			var _dropItem = dropItem.instantiate()
			add_sibling(_dropItem)
			pass
			
		pass
	
	
	for _x in gridDimensions.x:
		for _y in gridDimensions.y:
			pass
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Sprite2D.position = get_viewport().get_mouse_position()
	pass

var grabbed = Callable(self, "Grab")

func Grab(item):
	print(item)
	if true: # If mouse is over an item
		print(gridAStar.get_closest_point(get_viewport().get_mouse_position()))
		#previousGridPosition = GetMouseLocationOnGrid() #
	
	
	
	
	
	
	
func GetMouseLocationOnGrid():
	return Vector2i.ZERO # Put code here




func _on_mouse_entered_inventory_grid():
	pass # Replace with function body.


func _on_mouse_exited_inventory_grid():
	pass # Replace with function body.
