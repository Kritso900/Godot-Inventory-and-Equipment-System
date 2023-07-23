extends Node

@export var itemListContainerRef:Node

@export var playerInventory:Dictionary # ItemResource - Amount

@export var itemTypeTab:TabBar

func _ready():
	RebuildItemListType(Globals.ItemTypes.CONSUMABLE)
	for _type in Globals.ItemTypes:
		itemTypeTab.add_tab(_type)
	#itemTypeTab.tab_selected.connect(RebuildItemListAll.bind(itemTypeTab.current_tab))
	itemTypeTab.tab_clicked.connect(RebuildItemListType)

# Rebuild functions refresh what is shown in the inventory list
# Run one of these when opening the inventory or changing what items types are shown
#func RebuildItemListAll():
#	itemListContainerRef.ClearList()
#	for _item in playerInventory:
#		for _amount in playerInventory[_item]:
#			itemListContainerRef.AddItemToList(_item)

func RebuildItemListType(_itemType:Globals.ItemTypes):
	itemListContainerRef.ClearList()
	for _item in playerInventory:
		if _item.itemType == _itemType:
			for _amount in playerInventory[_item]:
				itemListContainerRef.AddItemToList(_item)

func AddItemToInventory(_item:ItemResource):
	if playerInventory.has(_item):
		playerInventory[_item].amount += 1
	else:
		playerInventory[_item].amount = 1
	itemListContainerRef.AddItemToList(_item)
	
func RemoveItemFromInventory(_item:ItemResource):
	if playerInventory.has(_item):
		playerInventory[_item].amount -= 1
		if playerInventory[_item].amount == 0:
			playerInventory.erase(_item)
		itemListContainerRef.RemoveItemInList(_item)

func EquipmentSelect(_type:Globals.ItemTypes):
	pass
