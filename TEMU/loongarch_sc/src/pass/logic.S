#include "trap.h" 
.data
    num1:   .word 99      # 第一个整数
    num2:   .word 29      # 第二个整数
    result: .word 59       # 结果
.text
.globl main
main:
    # 运算指令测试,正常
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

    addi.w $s4,$zero,0x100  # 动态区存储偏移
    st.b $t1,$s4,0x10        
    ld.b $s1,$t0,0x10        
    st.w $t7,$s4,0x20       

    # 拼凑偏移地址,更改data段成功
    lu12i.w $s7, 0x0400     
    ori $s7, $s7, 0x0000 #0x00400000
    addi.w $s8,$zero,0xac
    st.w $s8,$s7,0x0        

    # 宏指令加载.data(失败,超出memory)
    # la $x,num1           
    # la $s6,result
    # ld.w $s7,$s5,0
    # addi.w $s8,$s7,0x2
    # st.w $s4,$s6,0x3F

    # 细分指令加载.data(失败)
    # lu12i.w $x, num1  # 加载标签的高16位地址
    # ori $x, $x, %lo(num1)  # 和标签的低16位地址进行或操作
    
    # 重写la细分
    pcaddu12i  $s6,  0x0
    # lu12i.w $s7, 0x0FFF
    # ori $s7, $s7, 0xFFF
    lu12i.w $s7,0xFF
    andi $s8,$s6,0x3F

    # 分支指令测试,正常
    beq $t0,$t1,end         # 不等不跳
    ld.w $s2,$s4,0x20
    add.w $s3,$t2,$zero     # $s3 = 0x1  
    beq $t1,$t1,equala      # 相等跳转equala  
end:
    HIT_GOOD_TRAP
equala:
    bge $t0,$t1,equalc      # 小于不跳
    add.w $s3,$t4,$s3       # $s3 = 0x9
    bge $t1,$t0,equalb      # 大于跳转
    add.w $s3,$t4,$s3       # $s3 = 0x11(不应该)
    HIT_GOOD_TRAP
equalb:
    bne $t0,$t0,equalb      # 相等不跳
    add.w $s3,$t0,$s3       # $s3 = 0xb
    bne $t0,$t1,equalc      # 不等跳转
    HIT_GOOD_TRAP 
equalc:
    add.w $s3,$t7,$s3       # $s3 = 0x26
    HIT_GOOD_TRAP


    






