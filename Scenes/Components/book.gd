extends Window

var page_counter = 0
var page_max_size = 0
@onready var container = $BoxContainer


func _ready():
	$Next_Page.pressed.connect(next_page_pressed)
	$Back_Page.pressed.connect(back_page_pressed)
	#hide_all_page(container)
	hide_all_page_with_expection(container, 0)
	page_max_size = $BoxContainer.get_child_count() - 1
	
	
func next_page_pressed():
	if page_counter >= page_max_size:
		return
	page_counter += 1
	hide_all_page_with_expection(container, page_counter)

func back_page_pressed():
	if page_counter <= 0:
		return
	page_counter -= 1
	hide_all_page_with_expection(container, page_counter)

func hide_all_page(container: BoxContainer):
	for i:Label in container.get_children():
		i.hide()

var counter = 0
func hide_all_page_with_expection(container: BoxContainer, exception: int):
	counter = 0
	for i:Label in container.get_children():
		if counter == exception:
			i.visible = true
			counter = counter + 1
			continue
		counter = counter + 1
		i.visible = false
