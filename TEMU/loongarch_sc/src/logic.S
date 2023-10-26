#include "trap.h"  
.data
    num1:   .word 10      # 第一个整数
    num2:   .word 20      # 第二个整数
    result: .word 0       # 结果
.text
.globl main
main:
    addi.w $t0,$zero,0x1    # $t0 = 0x1
    addi.w $t1,$zero,0xA    # $t1 = 0xa
    add.w $t0,$t0,$t0       # $t0 = 0x2
    sltu $t2,$t0,$t1        # $t2 = 0x1
    or $t3,$t0,$zero        # $t3 = 0x2
    xor $t4,$t1,$t0         # $t4 = 0x8
    srl.w $t5,$t1,$t0       # $t5 = 0x2
    andi $t6,$t1,0x011      # $t6 = 0x0
    ori $t7,$t1,0x011       # $t7 = 0x1b
    lu12i.w $t8,12          # $t8 = 0xc000
    pcaddu12i $s0,12        
    addi.w $s4,$zero,0x90 #存储偏移
    st.b $t1,$s4,0x10        
    ld.b $s1,$t0,0x10        
    st.w $t7,$s4,0x20       
    beq $t0,$t1,end         # 不等不跳
    ld.w $s2,$s4,0x20
    add.w $s3,$t2,$zero     # $s3 = 0x1  
    beq $t1,$t1,equala      # 相等跳转equala  
end:
    HIT_GOOD_TRAP
equala:
    bge $t0,$t1,equalc      # 小于不跳
    add.w $s3,$t4,$s3       # $s3 = 0x9
    bge $t1,$t0,equalc      # 大于跳转
    add.w $s3,$t4,$s3       # $s3 = 0x11(不应该)
    HIT_GOOD_TRAP
equalb:
    bne $t0,$t0,equalb      # 相等不跳
    add.w $s3,$t0,$s3       # $s3 = 0xb
    bne $t0,$t1,equalb      # 不等跳转
    HIT_GOOD_TRAP 
equalc:
    add.w $s3,$t7,$s3       # $s3 = 0x26
    HIT_GOOD_TRAP
    






