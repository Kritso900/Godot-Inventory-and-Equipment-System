### This script
extends PanelContainer

class_name DD_PlayerStats

# An array of all equip slots
var equipSlotRefArray:Array[DD_EquipSlot]

# DEBUG - Replace this with a reference to a variable form you character controller
var playerIntStat:int = 10

# DEBUG - Replace this with a reference to a variable form you character controller
var playerFloatStat:float = 2.5

func _ready():
	equipSlotRefArray.append($"../PanelContainer/VBoxContainer/HBoxContainer3/Drag Drop Equip Slot")
	equipSlotRefArray.append($"../PanelContainer/VBoxContainer/HBoxContainer/Drag Drop Equip Slot2")

func _process(delta):
	var _intStat:int
	var _floatStatMulti:float = 1
	
	# Checks all equip slots and if they contain an item then add the item's stats to the stat display
	for _slot in equipSlotRefArray:
		if _slot.equippedItem:
			_intStat += _slot.equippedItem.exampleInt
			_floatStatMulti += _slot.equippedItem.exampleFloat
	$"VBoxContainer/Int Stat Box/Stat Value".text = str(playerIntStat + _intStat)
	$"VBoxContainer/Float Stat Box/Stat Value".text = str(snappedf(playerFloatStat * _floatStatMulti, 0.1))
