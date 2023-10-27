#include "trap.h"
   .globl main
   .text
main:
   ori  $t1,$zero,0xff
   nop
   nop
   st.b  $t1,$zero ,0x3     # [0x3] = 0xff
   ori  $t1,$zero,0xee
   nop
   nop
   st.b  $t1,$zero,0x2       # [0x2] = 0xee
   ori  $t1,$zero,0xdd
   nop
   nop
   st.b   $t1,$zero,0x1       # [0x1] = 0xdd
   ori  $t1,$zero,0xcc
   nop
   nop
   st.b  $t1,$zero,0x0       # [0x0] = 0xcc
   ld.b   $v0,$zero,0x3       # $v0 = 0xffffffff
   nop

   lu12i.w  $t1,0x44
   nop
   nop
   ori  $t1,$t1,0x66
   nop
   nop     
   st.w   $t1,$zero,0x8       # [0x8] = 0x44, [0x9]= 0x55, [0xa]= 0x66, [0xb] = 0x77
   ld.w   $v0,$zero,0x8       # $v0 = 0x4466
   nop
   HIT_GOOD_TRAP		#stop temu

