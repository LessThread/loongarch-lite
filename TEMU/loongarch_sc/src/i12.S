#include "trap.h" 
.data
    num1:   .word 99      # 第一个整数
    num2:   .word 29      # 第二个整数
.text
.globl main
main:
    # 寄存器初始化
    addi.w $t1,$zero,0x1
    addi.w $t2,$zero,0x2
    addi.w $t3,$zero,0x3
    addi.w $t4,$zero,0x4
    pcaddu12i $t5,0x1C
    srl.w $t5,$t5,$t4
    lu12i.w $x,0x10
    srl.w $x,$x,$t5

    # ori
    ori $s0,$t1,0x1C

    # addi.w
    addi.w $s1,$t2,0x4    
    
    # andi
    andi $s2,$t4,0xF
    
    # st_w
    st.w $t5,$x,0x10

    # ld_w
    ld.w $s3,$x,0x10 
    
    # st_b
    st.b $t5,$x,0x10

    # ld_b
    ld.b $s4,$x,0x10

    # 汇编结束
    HIT_GOOD_TRAP		#stop temu

