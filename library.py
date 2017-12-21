import json, sys

pos = json.loads(open('new_pos_list.json').read())
pos = set(pos)
neg = json.loads(open('new_neg_list.json').read())
neg = set(neg)


def get_word():
	which_list = 0
	word = raw_input("WORD: ")
	if word in pos:
		print "already in Pos"
		return
	if word in neg:
		print "already in Neg"
		return
	while True:
		try:
			which_list = int(raw_input("1 for Pos, 2 for Neg: "))
			if which_list == 1:
				pos.add(word)
				return
			if which_list == 2:
				neg.add(word)
				return
		except ValueError:
			print "Oops. Try again, idiot."
	


if __name__ == "__main__":

	e = 100
	while (e != 0):
		get_word()
		while True:
			try:
				e = int(raw_input("Enter 0 to exit, 1 to continue: "))
				break
			except ValueError:
				print "Oops. Try again, idiot."
	pos = sorted(pos)
	neg = sorted(neg)
	with open('new_pos_list.json', 'w') as f:
		pos_str_ = json.dumps(pos,
                      indent=4, sort_keys=True)
		f.write(pos_str_)

	with open('new_neg_list.json', 'w') as f:
		neg_str_ = json.dumps(neg,
                      indent=4, sort_keys=True)
		f.write(neg_str_)
