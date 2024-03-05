extends Node

var SHIFT: int = -1

signal caeser_signal

class Caesar_Shift:
	var message: String
	var encrypted: String
	var shift: int

##TODO
##UPPER/LOWER CASE

#IDEA
#Due to this maybe I cloud add a mysterious signal where an unkown language is used.
#Using date or some commonly used this like "GREAT/GLORY" or dates like 1950.05.12 so it's
#easier for the player to identifiy the shift
enum CHIPER_ALPHABET {a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z}


func _ready() -> void:
	caesar_chiper("this is a message", SHIFT)

func chiper_index(character: String) -> int:
	for i in CHIPER_ALPHABET:
		if character in CHIPER_ALPHABET:
			return CHIPER_ALPHABET.get(character)
		else:
			assert(false, "Missing character: %s" % character)
	return -1	 
	
	
func chiper_encryption(index: int) -> String:
	#We loop around in the Alphabet
	var maxSize: int = CHIPER_ALPHABET.size()
	
	if index >= maxSize:
		var offset = index - maxSize
		index = 0 + offset
		return CHIPER_ALPHABET.find_key(index) 
	if index < 0:
		return CHIPER_ALPHABET.find_key(maxSize + index)
	else:
		return CHIPER_ALPHABET.find_key(index)
	

func chiper_decryption(character: String, shift: int) -> String:
	var index: int = chiper_index(character)
	var maxSize: int = CHIPER_ALPHABET.size() - 1
	shift = shift * -1
	
	if index + shift > maxSize:
		var offset: int = (index - maxSize) + shift - 1
		index = offset
		return CHIPER_ALPHABET.find_key(index)
		
	if index + shift < 0:
		return CHIPER_ALPHABET.find_key(maxSize + shift + 1)
		
	return CHIPER_ALPHABET.find_key(index + shift) 
	


func caesar_chiper(text : String, shift : int):
	assert(shift > 26 || shift > -26, "There's no reason to go beyond shift 25 as you're just repeating yourself")

	var cs = Caesar_Shift.new()
	
	var input_string: String = ""
	var dec_str: String = ""
	var encrypted_string: String = ""

	
	for i in text:
		if i == " ":
			input_string += i
			encrypted_string += i
			continue
		input_string += i
		
		var SHIFT_Alphabet_Index: int = chiper_index(i) + shift
		encrypted_string += chiper_encryption(SHIFT_Alphabet_Index)
		
	for i in encrypted_string:
		if i == " ":
			dec_str += i
			continue
		dec_str += chiper_decryption(i, SHIFT)

	cs.shift = shift
	cs.encrypted = encrypted_string
	cs.message = input_string
	
	#emit_signal("caeser_signal", Caiser_Shift)
