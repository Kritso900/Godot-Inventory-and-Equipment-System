extends Node

class_name TL_InventoryController

@export var itemListContainerRef:TL_ItemListContainer

@export var itemListEquipRef:TL_ItemListContainer

@export var playerInventory:Dictionary # ItemResource - Amount

var playerIntStat:int = 10
var playerFloatStat:float = 2.5

@export var itemTypeTab:TabBar

var equipSlotRefArray:Array[TL_EquipItemSlot]



func _ready():
	
	for _type in Globals.ItemTypes:
		itemTypeTab.add_tab(_type)
	AddItemToInventory(preload("res://Resources/Items/Breastplate.tres"))
	AddItemToInventory(preload("res://Resources/Items/Estoc.tres"))
	AddItemToInventory(preload("res://Resources/Items/Estoc.tres"))
	AddItemToInventory(preload("res://Resources/Items/Potion.tres"))
	AddItemToInventory(preload("res://Resources/Items/Potion.tres"))
	AddItemToInventory(preload("res://Resources/Items/Potion.tres"))
	AddItemToInventory(preload("res://Resources/Items/Potion.tres"))
	RebuildItemListType(itemListContainerRef, Globals.ItemTypes.CONSUMABLE)
	$"PanelContainer/VBoxContainer/Int Stat Box/Stat Value".text = str(playerIntStat)
	$"PanelContainer/VBoxContainer/Float Stat Box/Stat Value".text = str(snappedf(playerFloatStat, 0.1))
	#itemTypeTab.tab_selected.connect(RebuildItemListType)#.bind(itemTypeTab.current_tab))
	#itemTypeTab.tab_clicked.connect(RebuildItemListType.bind(itemListContainerRef, itemTypeTab.current_tab))

# Rebuild functions refresh what is shown in the inventory list
# Run one of these when opening the inventory or changing what items types are shown
#func RebuildItemListAll():
#	itemListContainerRef.ClearList()
#	for _item in playerInventory:
#		for _amount in playerInventory[_item]:
#			itemListContainerRef.AddItemToList(_item)

func RebuildItemListType(_targetList:Node, _itemType:Globals.ItemTypes):
	_targetList.ClearList()
	for _item in playerInventory:
		if _item.itemType == _itemType:
			for _amount in playerInventory[_item].amount:
				_targetList.AddItemToList(_item)

func AddItemToInventory(_item:ItemResource):
	if playerInventory.has(_item):
		playerInventory[_item].amount += 1
	else:
		playerInventory[_item] = {amount = 1, equipped = false}
	itemListContainerRef.AddItemToList(_item)
	RebuildItemListType(itemListContainerRef, itemTypeTab.current_tab)
	
func RemoveItemFromInventory(_item:ItemResource):
	if playerInventory.has(_item):
		playerInventory[_item].amount -= 1
		if playerInventory[_item].amount == 0:
			if playerInventory[_item].equipped:
				#for _slot in equipSlotRefArray:
				pass#if _item == _slot.equippedItem: _slot.UnequipItem()
			playerInventory.erase(_item)
		itemListContainerRef.RemoveItemFromList(_item)
		RebuildItemListType(itemListContainerRef, itemTypeTab.current_tab)

func EquipmentSelect(_type:Globals.ItemTypes, _itemSlot:TL_EquipItemSlot, _equippedItem:ItemResource):
	$"Equipment Controller/SubViewportContainer".visible = true
	$"Equipment Controller/SubViewportContainer/SubViewport/Item List Container".SetupForEquip(_type, _itemSlot, _equippedItem)

func PlayerStatRebuild():
	var _intStat:int
	var _floatStatMulti:float = 1
	for _slot in equipSlotRefArray:
		if _slot.equippedItem:
			_intStat += _slot.equippedItem.exampleInt
			_floatStatMulti += _slot.equippedItem.exampleFloat
	$"PanelContainer/VBoxContainer/Int Stat Box/Stat Value".text = str(playerIntStat + _intStat)
	$"PanelContainer/VBoxContainer/Float Stat Box/Stat Value".text = str(snappedf(playerFloatStat * _floatStatMulti, 0.1))

func EquipmentUnequip(_itemSlot:TL_EquipItemSlot):
	pass

func ShowItemEquipSubView():
	$"Equipment Controller/SubViewportContainer".show()

func HideItemEquipSubView():
	$"Equipment Controller/SubViewportContainer".hide()


func _on_tab_bar_tab_changed(tab):
	RebuildItemListType(itemListContainerRef, tab)


func _on_menu_type_tab_bar_tab_selected(tab):
	match tab:
		0:
			$VBoxContainer.show()
			$"Equipment Controller".hide()
		1:
			$VBoxContainer.hide()
			$"Equipment Controller".show()
