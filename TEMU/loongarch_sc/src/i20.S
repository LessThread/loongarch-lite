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

    # lu12i_w
    lu12i.w $s0,0x11
    lu12i.w $s1,0xF

    # pcaddu12i
    pcaddu12i $s2,0x12
    pcaddu12i $s3,0xF

    # 汇编结束
    HIT_GOOD_TRAP		#stop temu

