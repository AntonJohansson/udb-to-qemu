SECTIONS
{
    /* virt machine, RAM starts at 2gb */
    . = 0x80000000;
    .text : {
        *(.text)
    }
    .rodata : {
        *(.rodata)
    }
    /* align r/w section to next 2mb */
    . = ALIGN(1 << 21);
    .data : {
        *(.data)
    }
    .bss : {
        *(.bss)
    }
    .stack (NOLOAD) :
    {
        . = ALIGN(8);
        _stack_start = .;
        . = . + 0x800;
        _stack_end = .;
    }
}
