### This script controls the tab list inventory and equipment
extends Node

class_name TL_InventoryController

# Reference to the item list container used for the inventory
@export var itemListContainerRef:TL_ItemListContainer

# Reference to the item list container used for equipping items
@export var itemListEquipRef:TL_ItemListContainer

# A dictionary used to store which items the player has, their ammount, and if they're equipped
@export var playerInventory:Dictionary # ItemResource - Amount

# DEBUG - Replace these references to stats from the player controller
var playerIntStat:int = 10
var playerFloatStat:float = 2.5

# Reference to that tab used by the inventory to filter which items are displayed
@export var itemTypeTab:TabBar

# An array of the equip slots
var equipSlotRefArray:Array[TL_EquipItemSlot]



func _ready():
	# Adds a filter tab for each item type to the itemTypeTab
	for _type in Globals.ItemTypes:
		itemTypeTab.add_tab(_type)
	
	#DEBUG - Adds items to show off the inventory's functionalities
	AddItemToInventory(preload("res://Resources/Items/Breastplate.tres"))
	AddItemToInventory(preload("res://Resources/Items/Estoc.tres"))
	AddItemToInventory(preload("res://Resources/Items/Estoc.tres"))
	AddItemToInventory(preload("res://Resources/Items/Potion.tres"))
	AddItemToInventory(preload("res://Resources/Items/Potion.tres"))
	AddItemToInventory(preload("res://Resources/Items/Potion.tres"))
	AddItemToInventory(preload("res://Resources/Items/Potion.tres"))
	
	# Rebuilds the item list to ensure it displays properly
	RebuildItemListType(itemListContainerRef, Globals.ItemTypes.CONSUMABLE)
	$"PanelContainer/VBoxContainer/Int Stat Box/Stat Value".text = str(playerIntStat)
	$"PanelContainer/VBoxContainer/Float Stat Box/Stat Value".text = str(snappedf(playerFloatStat, 0.1))

# Rebuilds the given item list, displaying the items of the given item type
# This should be called every time to inventory is modified
func RebuildItemListType(_targetList:TL_ItemListContainer, _itemType:Globals.ItemTypes):
	_targetList.ClearList()
	for _item in playerInventory:
		if _item.itemType == _itemType:
			for _amount in playerInventory[_item].amount:
				_targetList.AddItemToList(_item)

# Adds the given item to the inventory dictionary, or increases it's amount if it is already present
func AddItemToInventory(_item:ItemResource):
	if playerInventory.has(_item):
		playerInventory[_item].amount += 1
	else:
		playerInventory[_item] = {amount = 1, equipped = false}
	itemListContainerRef.AddItemToList(_item)
	RebuildItemListType(itemListContainerRef, itemTypeTab.current_tab)

# Removes the given item from the inventory, if there's more than one then instead reduces the amount
func RemoveItemFromInventory(_item:ItemResource):
	if playerInventory.has(_item):
		playerInventory[_item].amount -= 1
		if playerInventory[_item].amount == 0:
			playerInventory.erase(_item)
		itemListContainerRef.RemoveItemFromList(_item)
		RebuildItemListType(itemListContainerRef, itemTypeTab.current_tab)

# Opens the equip item list and gives the equip slot's item type
func EquipmentSelect(_type:Globals.ItemTypes, _itemSlot:TL_EquipItemSlot, _equippedItem:ItemResource):
	ShowItemEquipSubView()
	$"Equipment Controller/SubViewportContainer/SubViewport/Item List Container".SetupForEquip(_type, _itemSlot, _equippedItem)

# Refreshes the stat values using the values from the equipped items
func PlayerStatRebuild():
	var _intStat:int
	var _floatStatMulti:float = 1
	for _slot in equipSlotRefArray:
		if _slot.equippedItem:
			_intStat += _slot.equippedItem.exampleInt
			_floatStatMulti += _slot.equippedItem.exampleFloat
	$"PanelContainer/VBoxContainer/Int Stat Box/Stat Value".text = str(playerIntStat + _intStat)
	$"PanelContainer/VBoxContainer/Float Stat Box/Stat Value".text = str(snappedf(playerFloatStat * _floatStatMulti, 0.1))

# Makes the SubViewport containing the equip item list visible
func ShowItemEquipSubView():
	$"Equipment Controller/SubViewportContainer".show()

# Makes the SubViewport containing the equip item list hidden
func HideItemEquipSubView():
	$"Equipment Controller/SubViewportContainer".hide()

# Rebuilds the inventory item to the tab's current value
func _on_tab_bar_tab_changed(tab):
	RebuildItemListType(itemListContainerRef, tab)

# Switchs views between inventory and equipment screen
func _on_menu_type_tab_bar_tab_selected(tab):
	match tab:
		0:
			$VBoxContainer.show()
			$"Equipment Controller".hide()
		1:
			$VBoxContainer.hide()
			$"Equipment Controller".show()
