OUTPUT_ARCH(loongarch)
ENTRY(_start)
SECTIONS
{
        . = 0x80000000;
        .text : 
        {
            *(.text)
            _etext = .;
        }

        . = 0x80040000;
        .data : 
        {
            *(.data)              
        }

	.bss :
        {
            *(.bss)
        }

} 
