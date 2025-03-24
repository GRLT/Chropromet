extends Control
class_name Keyboard

@onready var keyboard_popup: GridContainer = $Keyboard
@onready var keyboard_state: Button = $Keyboard_State
@onready var player_input_screen: Label = $Player_Input_Screen
@onready var submit_button: Button = $Submit

var keyboard_visibilty: bool = false

#FIXME UPPERCASE
enum azerty_layout { a, z, e, r, t, y, u, i, o, p, q, s, d, f, g, h, j, k, l, m, w, x, c, v, b, n }
enum qwerty_layout { q, w, e, r, t, y, u, i, o, p, a, s, d, f, g, h, j, k, l, z, x, c, v, b, n, m }
enum dvorak_layout { p, y, f, g, c, r, l, a, o, e, u, i, d, h, t, n, s, q, j, k, x, b, m, w, v, z }


#FIXME
#Input_Screen text is overflowing make it better please! [after overflow "..."]
func _ready() -> void:
    keyboard_state.pressed.connect(hide_reveal_keyboard)
    player_input_screen.text = ""

    #connect("keyboard_layout", layout_set_callback)

    layout_set(dvorak_layout)


func layout_set_callback(layout: String) -> void:
    match layout:
        "azerty":
            layout_set(azerty_layout as Variant)
        "qwerty":
            layout_set(qwerty_layout as Variant)
        "dvorak":
            layout_set(dvorak_layout as Variant)
        _:
            assert(false, "No matching layout found, supported layout {azerty/qwerty/dvorak}")


func button_event(button: Button) -> void:
    match button.name:
        "backspace":
            if player_input_screen.text.length() != 0:
                player_input_screen.text[-1] = ""
        _:
            player_input_screen.text += button.name


func layout_set(layout: Dictionary) -> void:
    var iter: int = 0
    for i: Button in keyboard_popup.get_children():
        i.pressed.connect(button_event.bind(i))
        #Special button, if you want more rework this
        if i.name == "backspace":
            continue
        i.name = layout.find_key(iter)
        i.text = layout.find_key(iter)
        iter += 1


func hide_reveal_keyboard() -> void:
    submit_button.visible = keyboard_visibilty
    player_input_screen.visible = keyboard_visibilty
    for i: Button in keyboard_popup.get_children():
        i.visible = keyboard_visibilty
    if keyboard_visibilty:
        keyboard_visibilty = false
    else:
        keyboard_visibilty = true
