class_name Caesar_Shift_Object



#IDEA
#Due to this maybe I cloud add a mysterious signal where an unkown language is used.
#Using date or some commonly used this like "GREAT/GLORY" or dates like 1950.05.12 so it's
#easier for the player to identifiy the shift

##TODO
##UPPER/LOWER CASE
enum CHIPER_ALPHABET {a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z}

var message: String = ""
var encrypted: String = ""
var encrypted_status: bool = false
var shift: int = 0
	
func _init(_message, _shift) -> void:
	assert(shift > 26 || shift > -26, \
	"There's no reason to go beyond shift 25 as you're just repeating yourself")
	self.message = _message
	self.shift = _shift

	
func chiper_index(character: String) -> int:
	for i in CHIPER_ALPHABET:
		if character in CHIPER_ALPHABET:
			return CHIPER_ALPHABET.get(character)
		else:
			assert(false, "Missing character: %s" % character)
	return -1	 
	
func _chiper_encryption() -> void:
#We loop around in the Alphabet
	var maxSize: int = CHIPER_ALPHABET.size()
	var encrypted_string: String = ""

	for i in message:
		if i == " ":
			encrypted_string += i
			continue
			
		var shiftedIndex: int = chiper_index(i) + shift

		if shiftedIndex >= maxSize:
			var offset = shiftedIndex - maxSize
			shiftedIndex = 0 + offset
			encrypted_string += CHIPER_ALPHABET.find_key(shiftedIndex) 
			continue
		if shiftedIndex < 0:
			encrypted_string += CHIPER_ALPHABET.find_key(maxSize + shiftedIndex)
			continue
		else:
			encrypted_string += CHIPER_ALPHABET.find_key(shiftedIndex)
			continue
	encrypted = encrypted_string
	encrypted_status = true
	
func _chiper_decryption() -> String:
	var index: int
	var maxSize: int = CHIPER_ALPHABET.size() - 1
	var dec_str: String = ""
	
	for i in message:
		if i == " ":
			dec_str += i
			continue
		index = chiper_index(i)	
		if shift > 0:
			if index - shift > maxSize:
				var offset: int = (index + shift) - maxSize
				index = 0 + offset
				dec_str += CHIPER_ALPHABET.find_key(index)
				continue
			if index - shift < 0:
				var offset: int = index - shift
				index = maxSize - abs(offset)
				dec_str += CHIPER_ALPHABET.find_key(index + 1)
				continue
			else:
				dec_str += CHIPER_ALPHABET.find_key(index - shift)
				
		else:
			if index + abs(shift) > maxSize:
				var offset: int = (index + abs(shift)) - maxSize
				index = 0 + offset
				dec_str += CHIPER_ALPHABET.find_key(index - 1)
				#continue
			else:
				dec_str += CHIPER_ALPHABET.find_key(index + abs(shift))
				
	return dec_str
	
func getMessage() -> String:
	return self.message
	
func getShift() -> int:
	return self.shift

func getEncrypted() -> String:
	return self.encrypted
