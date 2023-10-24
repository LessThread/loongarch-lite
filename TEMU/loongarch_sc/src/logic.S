#include "trap.h" 
.data
    num1:   .word 10      # 第一个整数
    num2:   .word 20      # 第二个整数
    result: .word 0       # 结果
.text
.globl main
main:
    addi.w $t0,$zero,0x1 # $t0 = 1
    addi.w $t1,$zero,0xA
    add.w $t0,$t0,$t0
    sltu $t2,$t0,$t1
    or $t3,$t0,$zero
    xor $t4,$t1,$t0
    srl.w $t5,$t1,$t0
    andi $t6,$t1,0x011
    ori $t7,$t1,0x011
    lu12i.w $t8,12
    pcaddu12i $s0,12
    st.b $t1,$t0,0xb
    ld.b $s1,$t0,0xb
    st.w $t1,$t0,0xb
    ld.w $s2,$t0,0xb
    beq $t0,$t1,equal
    bne $t0,$t1,equal
    bge $t0,$t1,equal
equal:
    bge $t0,$t1,end
end:
    addi.w $t0,$zero,0x1
    HIT_GOOD_TRAP
