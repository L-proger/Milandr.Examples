ENTRY(Reset_Handler)

MEMORY {
  FLASH (rx) : ORIGIN = 0x00000000, LENGTH = 128K
  RAM (rw)   : ORIGIN = 0x20000000, LENGTH = 32K
  IRAM (rwx) : ORIGIN = 0x20100000, LENGTH = 16K
}

_estack = ORIGIN(RAM) + LENGTH(RAM);  /* Place Stack Pointer at end of RAM */
_Min_Heap_Size = 0x200;               /* required amount of heap  */
_Min_Stack_Size = 0x400;              /* required amount of stack */

SECTIONS {

  /* The ISR vectors goes at the beginning of FLASH */
  .isr_vector : {
    . = ALIGN(4);
    KEEP(*(.isr_vector))
    . = ALIGN(4);
  } > FLASH

  /* The program code and other data goes into FLASH */
  .text : {
    . = ALIGN(4);
    *(.text)
    *(.text*)
    *(.glue_7)         /* glue arm to thumb code */
    *(.glue_7t)        /* glue thumb to arm code */
    *(.eh_frame)
    KEEP (*(.init))
    KEEP (*(.fini))
    . = ALIGN(4);
    _etext = .;
  } > FLASH

  /* Place constants, strings, etc.into FLASH */
  .rodata : {
    . = ALIGN(4);
    *(.rodata)
    *(.rodata*)
    . = ALIGN(4);
  } > FLASH

  .ARM.extab : { *(.ARM.extab* .gnu.linkonce.armextab.*) } >FLASH
  .ARM : {
    __exidx_start = .;
    *(.ARM.exidx*)
    __exidx_end = .;
  } > FLASH

  .preinit_array : {
    PROVIDE_HIDDEN (__preinit_array_start = .);
    KEEP (*(.preinit_array*))
    PROVIDE_HIDDEN (__preinit_array_end = .);
  } > FLASH

  .init_array : {
    PROVIDE_HIDDEN (__init_array_start = .);
    KEEP (*(SORT(.init_array.*)))
    KEEP (*(.init_array*))
    PROVIDE_HIDDEN (__init_array_end = .);
  } > FLASH

  .fini_array : {
    PROVIDE_HIDDEN (__fini_array_start = .);
    KEEP (*(SORT(.fini_array.*)))
    KEEP (*(.fini_array*))
    PROVIDE_HIDDEN (__fini_array_end = .);
  } > FLASH

  /* used by the startup to initialize data */
  _sidata = LOADADDR(.data);

  /* Initialized data sections goes into RAM, load LMA copy after code */
  .data : {
    . = ALIGN(4);
    _sdata = .;
    *(.data)
    *(.data*)
    . = ALIGN(4);
    _edata = .;
  } > RAM AT > FLASH

  .ramfunc : AT (_edata) {
    __ramfunc_start__ = .;
    *(.ramfunc*)
    . = ALIGN(4);
    __ramfunc_end__ = .;
  } > IRAM

  /* Uninitialized data section */
  . = ALIGN(4);
  .bss : {
    _sbss = .;
    __bss_start__ = _sbss;
    *(.bss)
    *(.bss*)
    *(COMMON)
    . = ALIGN(4);
    _ebss = .;
    __bss_end__ = _ebss;
  } > RAM

  /* User_heap_stack section, used to check that there is enough RAM left */
  ._user_heap_stack : {
    . = ALIGN(8);
    PROVIDE ( end = . );
    PROVIDE ( _end = . );
    . = . + _Min_Heap_Size;
    . = . + _Min_Stack_Size;
    . = ALIGN(8);
  } > RAM

  /* Remove information from the standard libraries */
  /DISCARD/ : {
    libc.a ( * )
    libm.a ( * )
    libgcc.a ( * )
  }

  .ARM.attributes 0 : { *(.ARM.attributes) }
}