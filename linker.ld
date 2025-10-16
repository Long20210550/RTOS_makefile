ENTRY(Reset_Handler)

/* Điều chỉnh đúng dung lượng của chip bạn */
MEMORY
{
  FLASH (rx)  : ORIGIN = 0x08000000, LENGTH = 32K
  RAM   (rwx) : ORIGIN = 0x20000000, LENGTH = 10K
}

/* Stack top cho vector table entry #0 */
_estack = ORIGIN(RAM) + LENGTH(RAM);

SECTIONS
{
  /* 1) Giữ bảng vector ở đầu FLASH */
  .isr_vector :
  {
    KEEP(*(.isr_vector))
  } > FLASH

  /* 2) Code + hằng số trong FLASH */
  .text :
  {
    *(.text*)                 /* code */
    *(.rodata*)               /* hằng số */
    *(.glue_7) *(.glue_7t)    /* glue (nếu có) */
    _etext = .;               /* cuối phần code trong FLASH */
  } > FLASH

  /* 3) Dữ liệu .data nằm ở RAM nhưng nạp từ FLASH
        => dùng AT> FLASH và khai báo _sidata = LOADADDR(.data) */
  .data : AT ( _etext )
  {
    _sdata = .;
    *(.data*)
    *(.data.*)
    _edata = .;
  } > RAM
  _sidata = LOADADDR(.data);

  /* 4) Vùng .bss (NOLOAD) trong RAM, khởi tạo 0 trong startup */
  .bss (NOLOAD) :
  {
    _sbss = .;
    *(.bss*)
    *(COMMON)
    _ebss = .;
  } > RAM

  /* (tuỳ chọn) heap/stack nếu bạn muốn kiểm soát thêm */
}
