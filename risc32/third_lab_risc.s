    .data
.org 0x0
out_buf:        .byte '________________________________' ; result buffer
    .data
.org 0x1000
length:		.word 0x90
input_addr:     .word  0x80
output_addr:    .word  0x84               ; Output address where the result should be stored
buf_addr:	.word 0x38
const_1: .word 0x1
mask:	.word 0x5F5F5F00   ; mask for underlines
buf: .byte '________________________________'
out_buf_addr:	.word 0x0
byte_mask: .word 0x000000FF
terminator: .word 0xA  ; terminator to compare
error_value:  .word  0xCCCCCCCC   
    .text
_start:
    lui a2, %hi(byte_mask)
    addi a2, a2, %lo(byte_mask)
    lw a2, 0(a2)
    lui a3, %hi(output_addr)
    addi a3, a3, %lo(output_addr)
    lw a3, 0(a3)
    mv	t4, t1 ; t4 is for real pstring task, not string with \n in the end
    lui t6, %hi(out_buf_addr)
    addi t6, t6, %lo(out_buf_addr)
    lw t6, 0(t6)
    lui t3, %hi(buf_addr)
    addi t3, t3, %lo(buf_addr)
    lw t3, 0(t3)  ; buffer pointer
    lui a1, %hi(mask)
    addi a1, a1, %lo(mask)
    lw    a1, 0(a1)
    ; add t1, t1, a1
    sw t1, 0(t3)
    lui a0, %hi(const_1)
    addi a0, a0, %lo(const_1)
    lw a0, 0(a0)
    sub t4, t4, a0
    lui a4, %hi(terminator)
    addi a4, a4, %lo(terminator)
    lw a4, 0(a4)
    lui a5, %hi(out_buf_addr)    ; a5 - symb counter
    addi a5, a5, %lo(out_buf_addr)
    lw a5, 0(a5)
    addi  a6, zero, 32 ; overflow border 
loop:
    lui      t1, %hi(input_addr)             ; int * input_addr_const = *input_addr;
    addi     t1, t1, %lo(input_addr)
    lw       t1, 0(t1)                       
    lw       t1, 0(t1)
    beq      a4, t1, reverse
    add	     t3, t3, a0
    add a5, a5, a0
    beq a5, a6, error
    sw t1, 0(t3)
    sub t4, t4, a0
    j loop

reverse:
    beqz a5, corner_end   ; check if zero symbols
    sw a5, 0(t6) ; store the length of the word
    add t6, t6, a0
    mv t5, a5   ; move the number of symbols to t5 for loop
    sub t5, t5, a0
reverse_loop:
    beqz t5, end  
    lw t1, 0(t3)  ; load current char on addres contained in pointer
    and t1, t1, a2 ; store only one char using mask
    sw t1, 0(t6)   ; put a char into new buffer and into output stream
    sw t1, 0(a3)
    add t6, t6, a0  ; move pointers
    sub t3, t3, a0
    sub t5, t5, a0  ; sub iteration counter
    j reverse_loop
end:
    lw t1, 0(t3)
    and t1, t1, a2
    sw t1, 0(a3)
    add t1, t1, a1 ; wroking with the last symbol, adding underlines
    sw t1, 0(t6)   ; (actual for previous version of wrench) where byte is erasing other symbols with zeros
    halt
corner_end:
    sub t3, t3, a0  ; we are ending with no symbols in buffer
    lw t1, 0(t3)
    and t1, t1, a2
    add t1, t1, a1
    sw t1, 0(t6)
    halt
error:
    lui t5, %hi(error_value)   ; put error value on output
    addi   t5, t5, %lo(error_value)
    lw    t5, 0(t5)
    sw    t5, 0(a3)
    halt

