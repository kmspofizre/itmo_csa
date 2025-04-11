    .data

test_word:	.word 0x80000000
reversed_number: .word 0x0
copy_of_orig:	.word 0x0
input_addr:      .word  0x80
output_addr:     .word  0x84
shifter:	.word 0x1
const_1: 	.word 0x1
const_2:	.word 0x7FFFFFFF

    .text


_start:
	@p input_addr
	a!
	@
	!p copy_of_orig
loop:
	@p copy_of_orig
	@p test_word
	if end
	@p test_word
	and
	if shift_test_word
	no_zero ;
no_zero:
	@p reversed_number
	@p shifter
	+
	!p reversed_number

shift_test_word:
	@p const_2
	@p test_word
	2/
	and
	!p test_word
	@p shifter
	2*
	!p shifter
	loop ;

end:	@p reversed_number
	@p copy_of_orig
	xor
	if equal
	not_equal ;

equal:
	@p const_1
	@p output_addr
	a!
	!
	halt

not_equal:
	dup
	xor
	@p output_addr
	a!
	!
	halt
