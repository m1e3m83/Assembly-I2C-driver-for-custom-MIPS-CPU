# mem is word accessible hence the strings should be placed in separete words

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
    addi $t1, $zero, 1
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

main:
    addi $t0, $zero, 0x1
    sw $t0, 0x200($zero)
    addi $t0, $zero, 0x3
    sw $t0, 0x200($zero)

    sw $zero, 500($zero)

main_loop:
    addi $s0, $zero, 0
    get_ins:
        addi $a0, $zero, 0xff #addr
        addi $a1, $s0, 0    #data
        jal receive_letter
        bne $v0, $zero, get_ins

        lw $t0, 0($s0)
        bne $t0, $zero, add_letter
        j get_ins

        add_letter:
            addi $s0, $s0, 1
            addi $t1, $zero, 10
            bne $t0, $t1, get_ins
        
    show_command:
        sw $zero, 0($s0)
        addi $a0, $zero, 0x00  #addr
        addi $a1, $zero, 0     #data
        jal send_data
        
    lw $s1, 0($zero)
    addi $t1, $zero, 'F'
    bne $s1, $t1, L

    F:
        addi $s0, $zero, 1
        addi $s1, $zero, 1
        loop_F:
            addi $a0, $zero, 0xff #addr
            addi $a1, $zero, 0    #data
            jal receive_letter
            bne $v0, $zero, loop_F
            lw $t0, 0($zero)
            addi $t1, $zero, 'r'
            bne $t0, $t1, not_r
            j F 
            not_r:
            addi $t1, $zero, 'q'
            bne $t0, $t1, not_q

            sw $zero, 500($zero)
            addi $a0, $zero, 0x01
            addi $a1, $zero, 500
            jal send_data_byte
            j main_loop

            not_q:
            sw $s0, 0($zero)
            addi $a0, $zero, 0x01 
            addi $a1, $zero, 0
            jal send_data_byte    

            add $s2, $s1, $s0
            add $s0, $s1, $zero
            add $s1, $s2, $zero
            j loop_F

    L: 
        addi $t1, $zero, 'L'
        bne $s1, $t1, T
        lw $s1, 4($zero)
        addi $s1, $s1, -48
        addi $t0, $zero, 1
        sllv $s2, $t0, $s1
        srlv $s2, $s2, $t0
        lw $t0, 500($zero)

        addi $t1, $zero, 'F'
        lw $s1, 7($zero)
        bne $s1, $t1, ON

        OFF:
        addi $t2, $zero, 15
        xor $s2, $s2, $t2
        and $s2, $s2, $t0
        j LED

        ON:
        or $s2, $s2, $t0

        LED:
        sw $s2, 500($zero)
        addi $a0, $zero, 0x01  #addr
        addi $a1, $zero, 500     #data
        jal send_data_byte
        j main_loop

    T:
        addi $t1, $zero, 'T'
        bne $s1, $t1, main_loop 
        addi $a0, $zero, 0x00  #addr
        addi $a1, $zero, 5     #data
        jal send_data
        j main_loop


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
    end_connection loop1 loop2
    add $v0, $zero, $zero
    jr $ra
    error:
    addi $v0, $zero, 1
    jr $ra

receive_letter:
    init_connection #a0 addr, a1 data
    send_byte $a0
    bne $t3, $zero, error2
    receive_byte  #outputs in t1
    sw $t1, 0($a1)
    end_connection loop3 loop4
    add $v0, $zero, $zero
    jr $ra
    error2:
    addi $v0, $zero, 1
    jr $ra

send_data_byte:
    init_connection #a0 addr, a1 data
    send_byte $a0
    bne $t3, $zero, error3  
    lw $t2, 0($a1)
    send_byte $t2
    addi $a1, $a1, 1
    bne $t3, $zero, error3
    end_connection loop5 loop6
    add $v0, $zero, $zero
    jr $ra
    error3:
    addi $v0, $zero, 1
    jr $ra