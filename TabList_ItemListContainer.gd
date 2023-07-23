extends PanelContainer

@export var itemListRef:VBoxContainer
@export var itemStatsSceneRef:PackedScene
@export var itemTextSceneRef:PackedScene

func _process(delta):
	itemListRef = $"ScrollContainer/Item List"

func AddItemToList(_item:ItemResource):
	var _listItem:Node
	if _item.tabListShowStats:
		_listItem = itemStatsSceneRef.instantiate()
	else:
		_listItem = itemTextSceneRef.instantiate()
	_listItem.Setup(_item)
	itemListRef.add_child(_listItem)

func FindItemInList(_item):
	for _listItem in itemListRef.get_children():
		if _item == _listItem.item:
			return _listItem
	return null

func RemoveNodeFromList(_itemNode:Node):
	if itemListRef.find_child(_itemNode.name): 
		itemListRef.remove_child(_itemNode)
	else:
		print("Could not find node in list: "+_itemNode.name)

func RemoveItemFromList(_item:ItemResource):
	RemoveNodeFromList(FindItemInList(_item))

# Clears all item nodes from the item list. Does not affect inventory
func ClearList():
	for _itemNode in itemListRef.get_children():
		itemListRef.remove_child(itemListRef) # Removes the item from the list
		_itemNode.queue_free() # Deletes the item node

