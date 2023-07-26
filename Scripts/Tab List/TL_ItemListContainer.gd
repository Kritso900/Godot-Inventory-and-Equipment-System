extends PanelContainer

class_name TL_ItemListContainer

@export var itemListRef:VBoxContainer
@export var itemStatsSceneRef:PackedScene
@export var itemTextSceneRef:PackedScene
@export var controllerRef:TL_InventoryController
var equipMode:bool = false


func AddItemToList(_item:ItemResource):
	var _listItem:Node
	if equipMode and _item.tabListShowStats:
		_listItem = itemStatsSceneRef.instantiate()
	else:
		_listItem = itemTextSceneRef.instantiate()
	_listItem.Setup(_item, controllerRef)
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
		itemListRef.remove_child(_itemNode) # Removes the item from the list
		_itemNode.queue_free() # Deletes the item node

func SetupForEquip(_type:Globals.ItemTypes, _itemSlot:TL_EquipItemSlot, _equippedItem:ItemResource):
	equipMode = true
	controllerRef.RebuildItemListType(self, _type)
	if FindItemInList(_equippedItem):
		RemoveItemFromList(_equippedItem)
	for _listItem in itemListRef.get_children():
		_listItem.SetupEquip(_itemSlot)
