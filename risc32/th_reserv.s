    .data
.org 0x0
out_buf:        .byte '________________________________'
    .data
.org 0x1000
length:		.word 0x90
input_addr:     .word  0x80
output_addr:    .word  0x84               ; Output address where the result should be stored
buf_addr:	.word 0x38
const_1: .word 0x1
mask:	.word 0x5F5F5F00
buf: .byte '________________________________'
out_buf_addr:	.word 0x0
byte_mask: .word 0x000000FF
    .text
_start:

    lui      t1, %hi(input_addr)             ; int * input_addr_const = *input_addr;
    addi     t1, t1, %lo(input_addr)
    lw       t1, 0(t1)                       ; int output_addr = *outp
    lw       t1, 0(t1)
    lui a2, %hi(byte_mask)
    addi a2, a2, %lo(byte_mask)
    lw a2, 0(a2)
    lui a3, %hi(output_addr)
    addi a3, a3, %lo(output_addr)
    lw a3, 0(a3)
    mv	t4, t1
    mv t5, t1
    lui t6, %hi(out_buf_addr)
    addi t6, t6, %lo(out_buf_addr)
    lw t6, 0(t6)
    lui t3, %hi(buf_addr)
    addi t3, t3, %lo(buf_addr)
    lw t3, 0(t3)
    lui a1, %hi(mask)
    addi a1, a1, %lo(mask)
    lw    a1, 0(a1)
    ; add t1, t1, a1
    sw t1, 0(t3)
    lui a0, %hi(const_1)
    addi a0, a0, %lo(const_1)
    lw a0, 0(a0)
    sub t4, t4, a0
loop:
    beqz t4, reverse
    lui      t1, %hi(input_addr)             ; int * input_addr_const = *input_addr;
    addi     t1, t1, %lo(input_addr)
    lw       t1, 0(t1)                       ; int output_addr = *outp
    lw       t1, 0(t1)
    add	     t3, t3, a0
    sw t1, 0(t3)
    sub t4, t4, a0
    j loop

reverse:
    lui      t1, %hi(input_addr)             ; int * input_addr_const = *input_addr;
    addi     t1, t1, %lo(input_addr)
    lw       t1, 0(t1)                       ; int output_addr = *outp
    lw       t1, 0(t1)
    and t1, t1, a2
    add t1, t1, a1
    add t3, t3, a0
    sw t1, 0(t3)
    sw t5, 0(t6) 
    add t6, t6, a0
    sub t5, t5, a0
reverse_loop:
    beqz t5, end
    lw t1, 0(t3)
    and t1, t1, a2
    sw t1, 0(t6)
    sw t1, 0(a3)
    add t6, t6, a0
    sub t3, t3, a0
    sub t5, t5, a0
    j reverse_loop
end:
    lw t1, 0(t3)
    and t1, t1, a2
    sw t1, 0(a3)
    add t1, t1, a1
    sw t1, 0(t6)
    halt


