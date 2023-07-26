### This script controls the list of TL_Item nodes that is used to display and interact with the inventory
extends PanelContainer

class_name TL_ItemListContainer

@export var itemListRef:VBoxContainer
@export var itemStatsSceneRef:PackedScene
@export var itemTextSceneRef:PackedScene
@export var controllerRef:TL_InventoryController
var equipMode:bool = false

# Adds an item to the item list, does not affect the inventory dictonary
func AddItemToList(_item:ItemResource):
	var _listItem:Node
	if equipMode and _item.tabListShowStats:
		_listItem = itemStatsSceneRef.instantiate()
	else:
		_listItem = itemTextSceneRef.instantiate()
	_listItem.Setup(_item, controllerRef)
	itemListRef.add_child(_listItem)

# Returns a TL_Item node that corresponds to the given item resource
func FindItemInList(_item:ItemResource):
	for _listItem in itemListRef.get_children():
		if _item == _listItem.item:
			return _listItem
	return null

# Removes an item to the item list, does not affect the inventory dictonary
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
		itemListRef.remove_child(_itemNode) # Removes the item from the list
		_itemNode.queue_free() # Deletes the item node

# Sets up items in the item list for equipping to the given item slot
func SetupForEquip(_type:Globals.ItemTypes, _itemSlot:TL_EquipItemSlot, _equippedItem:ItemResource):
	equipMode = true
	controllerRef.RebuildItemListType(self, _type)
	for _listItem in itemListRef.get_children():
		_listItem.SetupEquip(_itemSlot)
