#include "trap.h"
.data
   n1: .half 0x01FF
   n2: .half 0x01FF
   n3: .half 0x01FF
   n4: .half 0x01FF
   num1:   .word 0x01FFFFFF      # 第一个整数
   num2:   .word 0x02FFFFFF      # 第一个整数
   num3:   .word 0x03FFFFFF     # 第一个整数
   num4:   .word 0x04FFFFFF      # 第二个整数
   num5:   .word 0x05FFFFFF      # 第二个整数
.text
.globl main
main:
   # 寄存器初始化
   lu12i.w $s7, 0x0400     
   ori $s7, $s7, 0x0000 #0x00400000
   
   pcaddu12i  $t1,0x1
   ld.w $t0,$s7,0x4

   la.global $a1,n1
   la.global $a2,n2
   la.global $a3,n3

   la.got $s1, num1
   la.abs $s2, num2
   la $s3, num3
   la $s4, num4

    
    

