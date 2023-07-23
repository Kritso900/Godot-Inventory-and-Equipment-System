extends "res://TabListItem.gd"

@export var stat1Ref:HBoxContainer
@export var stat2Ref:HBoxContainer

func Setup(_item):
	super(_item)
	setupStat(stat1Ref, preload("res://1x1 Misc Item Error.png"), _item.exampleInt)
	setupStat(stat2Ref, preload("res://1x1 Misc Item Error.png"), _item.exampleFloat)

func setupStat(_statRef:HBoxContainer, _statTexture:CompressedTexture2D, _statValue):
	_statRef.find_child("Stat Icon").set_texture(_statTexture)
	_statRef.find_child("Stat Value").set_text(str(_statValue))
