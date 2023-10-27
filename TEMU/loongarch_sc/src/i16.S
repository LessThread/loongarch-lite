#include "trap.h"
   .globl main
   .text
main:
    # 寄存器初始化
    addi.w $t1,$zero,0x1
    addi.w $t2,$zero,0x2
    addi.w $t3,$zero,0x3
    addi.w $t4,$zero,0x4
    addi.w $t5,$zero,0x5

    # beq
    beq $t0,$t1,end         # 不等不跳
    addi.w $s0,$zero,0x1    
    beq $t1,$t1,equalb      # 相等跳转equalb
    addi.w $s1,$zero,0x1
end:
    addi.w $s6,$zero,0x1
    HIT_GOOD_TRAP

    # bge
equala:
    bge $t0,$t1,end              # 小于不跳
    addi.w $s4,$zero,0x1   
    bge $t1,$t0,end              # 大于跳转
    addi.w $s5,$zero,0x1        
    HIT_GOOD_TRAP
    
    # bne
equalb:
    bne $t0,$t0,end      # 相等不跳
    addi.w $s2,$zero,0x1      
    bne $t0,$t1,equala      # 不等跳转
    addi.w $s3,$zero,0x1
    HIT_GOOD_TRAP 

