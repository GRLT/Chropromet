extends Control

@onready var keyboard_popup = $Keyboard
@onready var keyboard_state = $Keyboard_State
@onready var player_input_screen = $Player_Input_Screen
@onready var submit_button = $Submit

var keyboard_visibilty = false

enum azerty_layout {a,z,e,r,t,y,u,i,o,p,q,s,d,f,g,h,j,k,l,m,w,x,c,v,b,n}
enum qwerty_layout {q,w,e,r,t,y,u,i,o,p,a,s,d,f,g,h,j,k,l,z,x,c,v,b,n,m}
enum dvorak_layout {p,y,f,g,c,r,l,a,o,e,u,i,d,h,t,n,s,q,j,k,x,b,m,w,v,z}

#FIXME
#Add more keyboard presets like QWERTY, AZERTY, DVORAK

#FIXME
#Input_Screen text is overflowing make it better please! [after overflow "..."]
func _ready():
	keyboard_state.pressed.connect(hide_reveal_keyboard)
	player_input_screen.text = ""
	
	if !is_connected("keyboard_layout", layout_set_callback):
		ProblemGenerator.connect("keyboard_layout", layout_set_callback)
	
	#layout_set(dvorak_layout,keyboard_popup)
	
func layout_set_callback(layout):
	match layout:
		"azerty":
			layout_set(azerty_layout)
		"qwerty":
			layout_set(qwerty_layout)
		"dvorak":
			layout_set(dvorak_layout)
		_:
			assert(false, "No matching layout found, supported layout {azerty/qwerty/dvorak}")

func button_event(button: Button):
	match button.name:
		"backspace":
			if player_input_screen.text.length() != 0:
				player_input_screen.text[-1] = ""
		_:
			player_input_screen.text += button.name


func layout_set(layout):
	var iter = 0
	for i:Button in keyboard_popup.get_children():
		i.pressed.connect(button_event.bind(i))
		#Special button, if you want more rework this
		if i.name == "backspace":
			continue
		i.name = layout.find_key(iter)
		i.text = layout.find_key(iter)
		iter += 1

func hide_reveal_keyboard():
	submit_button.visible = keyboard_visibilty
	player_input_screen.visible = keyboard_visibilty
	for i:Button in keyboard_popup.get_children():
		i.visible = keyboard_visibilty
	if keyboard_visibilty:
		keyboard_visibilty = false
	else:
		keyboard_visibilty = true
