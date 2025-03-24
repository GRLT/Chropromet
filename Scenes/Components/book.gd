extends Window
class_name Book

var page_counter: int = 0
var page_max_size: int = 0
@onready var container: BoxContainer = $BoxContainer
@onready var book: Window = get_node(".")


func _ready() -> void:
    ($Next_Page as Button).pressed.connect(
        func() -> void:
            if page_counter >= page_max_size:
                return
            page_counter += 1
            hide_all_page_with_expection(container, page_counter)
    )

    ($Back_Page as Button).pressed.connect(
        func() -> void:
            if page_counter <= 0:
                return
            page_counter -= 1
            hide_all_page_with_expection(container, page_counter)
    )

    book.close_requested.connect(func() -> void: book.hide())

    #hide_all_page(container)
    hide_all_page_with_expection(container, 0)
    page_max_size = $BoxContainer.get_child_count() - 1


func hide_all_page(container: BoxContainer) -> void:
    for i: Label in container.get_children():
        i.hide()


var counter: int = 0


func hide_all_page_with_expection(container: BoxContainer, exception: int) -> void:
    counter = 0
    for i: Label in container.get_children():
        if counter == exception:
            i.visible = true
            counter = counter + 1
            continue
        counter = counter + 1
        i.visible = false
