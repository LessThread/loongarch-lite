#include "trap.h"    
    .org 0x0
    .text
    .global _start
_start:
    lu12i.w     $a0,-0x7fc00    # a0 = 0x80400000
    ori         $a1, $a0, 0x100
    ori		$t0, $zero, 0x0FF
    or		$s0, $a1, $t0
    HIT_GOOD_TRAP
