extends Control

@onready var keyboard_popup = $QWERTZ
@onready var keyboard_state = $Keyboard_State
@onready var player_input_screen = $Player_Input_Screen
@onready var submit_button = $Submit

var keyboard = false

#FIXME
#Add more keyboard presets like QWERTY, AZERTY, DVORAK

#FIXME
#Input_Screen text is overflowing make it better please! [after overflow "..."]
func _ready():
	keyboard_state.pressed.connect(hide_reveal_keyboard)
	for i:Button in keyboard_popup.get_children():
		#FIXME SET THIS TO TRUE!
		i.visible = true
		i.pressed.connect(button_event.bind(i))
	player_input_screen.text = ""



func button_event(button: Button):
	match button.name:
		"backspace":
			if player_input_screen.text.length() != 0:
				player_input_screen.text[-1] = ""
		_:
			player_input_screen.text += button.name




func hide_reveal_keyboard():
	submit_button.visible = keyboard
	player_input_screen.visible = keyboard
	for i:Button in keyboard_popup.get_children():
		i.visible = keyboard
	if keyboard:
		keyboard = false
	else:
		keyboard = true
