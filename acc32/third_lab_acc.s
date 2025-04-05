	.data
result: .word 0x84
in1: .word 0x80
a: .word 0x80
b: .word 0x0
one: .word 0x1
help: .word 0x0

	.text

_start:
	load_ind in1
	store_addr a
	load_addr in1
	store_addr in1
	load_ind in1
	store_addr b
gcd_cycle:
	load_addr b
	beqz end_cycle
	store_addr help
	load_addr a
	rem b
	store_addr b
	load_addr help
	store_addr a
	jmp gcd_cycle

end_cycle:
	load_addr a

end:
	store_ind result
	halt

