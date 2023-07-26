### The script inherits TL_Item, used when displaying an equipable item that should display it's stats
extends "res://Scripts/Tab List/TL_Item.gd"

@export var stat1Ref:HBoxContainer
@export var stat2Ref:HBoxContainer

# Runs setup from it's inherited script then sets up the stat values
func Setup(_item, _controllerRef):
	super(_item, _controllerRef)
	setupStat(stat1Ref, preload("res://Assets/Sprites/DD_1x1 Misc Item Error.png"), _item.exampleInt)
	setupStat(stat2Ref, preload("res://Assets/Sprites/DD_1x1 Misc Item Error.png"), _item.exampleFloat)

# Sets up the given stat reference using the given values
func setupStat(_statRef:HBoxContainer, _statTexture:CompressedTexture2D, _statValue):
	_statRef.find_child("Stat Icon").set_texture(_statTexture)
	_statRef.find_child("Stat Value").set_text(str(_statValue))
