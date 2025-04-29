extends Node2D

@onready var raid := get_node(".")
@onready var back: Button = $Back



func _ready() -> void:
    back.pressed.connect(
        func() -> void:
        SignalBus.scene_to_main.emit()
        )
