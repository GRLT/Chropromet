extends Node


signal scene_to_main
signal raid_prep(current_raid_object: Raid_Object)
signal logic_game(logic_board: Logic_Board)
signal morse(morse_object: Morse)
signal fail_points()
signal hide_book_pages_with_exception(exepction: Array[String])

signal all_signal_sent_out
signal morse_complete
signal chiper_complete
signal logic_gate_complete
