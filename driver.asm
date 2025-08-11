.macro send_bit $bit
    addi $t6, $zero, 7
    addi $t0, $zero, 0x80
    and $t0, $t0, $bit
    srlv $t0, $t0, $t6
    sw $t0, 0x200($zero)
    addi $t0, $t0, 2
    sw $t0, 0x200($zero)
    addi $t0, $t0, -2
    sw $t0, 0x200($zero)
.end_macro

.macro recieve_bit 
    addi $t0, $zero, 3
    sw $t0, 0x200($zero)
    lw $t3, 0x200($zero)
    addi $t0 $zero, 1
    sw $t0, 0x200($zero)
.end_macro


.macro init_connection
    addi $t0, $zero, 2
    sw $t0, 0x200($zero) 
    addi $t0, $zero, 0
    sw $t0, 0x200($zero)
.end_macro

.macro end_connection %loop_name1 %loop_name2
    %loop_name1:
    addi $t0, $zero, 0
    sw $t0, 0x200($zero)
    addi $t0, $zero, 2
    sw $t0, 0x200($zero) 
    addi $t0, $zero, 3
    sw $t0, 0x200($zero)  
    lw $t1, 0x200($zero)
    bne $t1, $zero, %loop_name2
    addi $t1, $zero, 1 #j get_c :((((((
    bne $t1, $zero, %loop_name1
    %loop_name2:
.end_macro   

.macro send_byte $byte
    add $t1, $zero, $byte
    send_bit $t1
    sll $t1, $t1, 1
    send_bit $t1
    sll $t1, $t1, 1
    send_bit $t1
    sll $t1, $t1, 1
    send_bit $t1
    sll $t1, $t1, 1
    send_bit $t1
    sll $t1, $t1, 1
    send_bit $t1
    sll $t1, $t1, 1
    send_bit $t1
    sll $t1, $t1, 1
    send_bit $t1
    recieve_bit
.end_macro   

.macro receive_byte
    add $t1, $zero, $zero
    recieve_bit
    add $t1, $t3, $zero
    sll $t1, $t1, 1
    recieve_bit
    add $t1, $t3, $t1
    sll $t1, $t1, 1
    recieve_bit
    add $t1, $t3, $t1
    sll $t1, $t1, 1
    recieve_bit
    add $t1, $t3, $t1
    sll $t1, $t1, 1
    recieve_bit
    add $t1, $t3, $t1
    sll $t1, $t1, 1
    recieve_bit
    add $t1, $t3, $t1
    sll $t1, $t1, 1
    recieve_bit
    add $t1, $t3, $t1
    sll $t1, $t1, 1
    recieve_bit
    add $t1, $t3, $t1

    add $t3, $zero, $zero
    send_bit $t3
.end_macro   

.text 

#mem is word accessible hence the strings should be placed in separete words
send_data:
    init_connection #a0 addr, a1 data
    send_byte $a0
    bne $t3, $zero, error  
    loop: 
    lw $t2, 0($a1)
    send_byte $t2
    addi $a1, $a1, 1
    bne $t3, $zero, error
    bne $t2, $zero, loop
    end_connection fuck fuuck
    add $v0, $zero, $zero

    jr $ra
    error:
    addi $v0, $zero, 1

    jr $ra

send_data_byte:
    init_connection #a0 addr, a1 data
    send_byte $a0
    bne $t3, $zero, errorrrr  
    lw $t2, 0($a1)
    send_byte $t2
    addi $a1, $a1, 1
    bne $t3, $zero, errorrrr
    end_connection fuck fuuck
    add $v0, $zero, $zero

    jr $ra
    errorrrr:
    addi $v0, $zero, 1

    jr $ra


receive_data:
    init_connection #a0 addr, a1 data
    send_byte $a0
    bne $t3, $zero, errorr

    add $v1, $zero, $zero
    looop:
    receive_byte  #outputs in t1
    addi $v1, $v1, 1
    sw $t1, 0($a1)
    addi $a1, $a1, 1
    bne $t1, $zero, looop

    end_connection shit shiiit
    add $v0, $zero, $zero
    
    jr $ra
    errorr:
    addi $v0, $zero, 1

    jr $ra

    #nop
    sll $zero, $zero, 0
