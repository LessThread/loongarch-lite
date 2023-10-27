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

    # or
    or $s0,$t0,$zero
    or $s1,$t2,$t4

    # xor
    xor $s2,$t0,$zero
    xor $s3,$t2,$t4

    # add.w
    add.w $s4,$t3,$t4
    add.w $s5,$t5,$t1

    # srl_w
    srl.w $s6,$t1,$t0
    srl.w $s7,$t4,$t5

    # slt
    sltu $x,$t1,$t5       

    # 汇编结束
    HIT_GOOD_TRAP		#stop temu

