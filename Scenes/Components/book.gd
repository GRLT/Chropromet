extends Window
class_name Book

var page_counter: int = 0
var page_max_size: int
@onready var container: BoxContainer = $BoxContainer
@onready var book: Window = get_node(".")


func _ready() -> void:
    
    SignalBus.hide_book_pages_with_exception.connect(
        func(exepction:Array[String]) -> void:
            remove_pages_with_expection(exepction)
            
            #Needs a little time so Container can resize itself
            await get_tree().process_frame
            page_max_size = container.get_child_count() - 1
            hide_all_page_with_expection(0)
    )
    
    
    ($Next_Page as Button).pressed.connect(
        func() -> void:
            if page_counter >= page_max_size:
                return
            page_counter += 1
            hide_all_page_with_expection(page_counter)
    )

    ($Back_Page as Button).pressed.connect(
        func() -> void:
            if page_counter <= 0:
                return
            page_counter -= 1
            hide_all_page_with_expection(page_counter)
    )

    book.close_requested.connect(func() -> void: book.queue_free())

func remove_pages_with_expection(exepction: Array[String]) -> void:
    for i:Label in container.get_children():
        if exepction.has(i.name):
            continue
        else:
            i.queue_free()


func hide_all_page(container: BoxContainer) -> void:
    for i: Label in container.get_children():
        i.hide()


var counter: int = 0


func hide_all_page_with_expection(exception: int) -> void:
    counter = 0
    for i: Label in container.get_children():
        if counter == exception:
            i.visible = true
            counter = counter + 1
            continue
        counter = counter + 1
        i.visible = false
