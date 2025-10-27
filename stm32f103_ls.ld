/*
    linker script:
    define memory for section
    set entry point (Reset_Handler)
*/
ENTRY(Reset_Handler)

/* Define memory */
MEMORY
{
    FLASH (rx)  : ORIGIN = 0x08000000, LENGTH = 32K
    RAM (rwx)   : ORIGIN = 0x20000000, LENGTH = 10K
}

/* Define section follow order */
SECTIONS
{
    /* Keep vector tabel in head of Flash */
    .isr_vector :
    {
        KEEP(*(.isr_vector))
    } > FLASH

    /* Code and constant in Flash */
    .text :
    {
        *(.text*)
        *(.rodata*)
        *(.glue_7) *(.glue_7t)
        . = ALIGN(4);
        _etext = .; /* End of the location of code */
    } > FLASH

    /* Global variable: store in FLASH but load to RAM */
    .data :
    {
        _sdata = .; /* Start of data in RAM */
        *(.data*)
        *(.data.*)
        . = ALIGN(4);
        _edata = .;
    } > RAM AT>FLASH

    .bss :
    {
        _sbss = .;
        __bss_start__ = _sbss;
        *(.bss*)
        *(COMMON)
        . = ALIGN(4);
        _ebss = .;
        __bss_end__ = _ebss;
        . = ALIGN(4);
        end = .;
    } > RAM
}