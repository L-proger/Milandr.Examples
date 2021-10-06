  .syntax unified
  .cpu cortex-m0
  .fpu softvfp
  .thumb

.global g_pfnVectors
.global Default_Handler

/* start address for the initialization values of the .data section.
defined in linker script */
.word _sidata
/* start address for the .data section. defined in linker script */
.word _sdata
/* end address for the .data section. defined in linker script */
.word _edata
/* start address for the .bss section. defined in linker script */
.word _sbss
/* end address for the .bss section. defined in linker script */
.word _ebss

  .section .text.Reset_Handler
  .weak Reset_Handler
  .type Reset_Handler, %function
Reset_Handler:
  ldr   r0, =_estack
  mov   sp, r0          /* set stack pointer */

/* Copy the data segment initializers from flash to SRAM */
  ldr r0, =_sdata
  ldr r1, =_edata
  ldr r2, =_sidata
  movs r3, #0
  b LoopCopyDataInit

CopyDataInit:
  ldr r4, [r2, r3]
  str r4, [r0, r3]
  adds r3, r3, #4

LoopCopyDataInit:
  adds r4, r0, r3
  cmp r4, r1
  bcc CopyDataInit

/* Zero fill the bss segment. */
  ldr r2, =_sbss
  ldr r4, =_ebss
  movs r3, #0
  b LoopFillZerobss

FillZerobss:
  str  r3, [r2]
  adds r2, r2, #4

LoopFillZerobss:
  cmp r2, r4
  bcc FillZerobss

/* Call the clock system intitialization function.*/
  bl  SystemInit
/* Call static constructors */
  bl __libc_init_array
/* Call the application's entry point.*/
  bl main

LoopForever:
    b LoopForever


.size Reset_Handler, .-Reset_Handler

//Default ISR handler
  .section .text.Default_Handler,"ax",%progbits
Default_Handler:
Infinite_Loop:
  b Infinite_Loop
  .size Default_Handler, .-Default_Handler

//Allocate interrupt vectors table
  .section .isr_vector,"a",%progbits
  .type g_pfnVectors, %object
  .size g_pfnVectors, .-g_pfnVectors

//Allocate interrupt vectors
g_pfnVectors:
  .word  _estack
  .word  Reset_Handler
  .word  NMI_Handler
  .word  HardFault_Handler
  .word  0
  .word  0
  .word  0
  .word  0
  .word  0
  .word  0
  .word  0
  .word  SVC_Handler
  .word  0
  .word  0
  .word  PendSV_Handler
  .word  SysTick_Handler

/* External interrupts */
  .long MIL_STD_1553B2_IRQHandler   /* IRQ0 */
  .long MIL_STD_1553B1_IRQHandler   /* IRQ1 */
  .long USB_IRQHandler              /* IRQ2 */
  .long CAN1_IRQHandler             /* IRQ3 */
  .long CAN2_IRQHandler             /* IRQ4 */
  .long DMA_IRQHandler              /* IRQ5 */
  .long UART1_IRQHandler            /* IRQ6 */
  .long UART2_IRQHandler            /* IRQ7 */
  .long SSP1_IRQHandler             /* IRQ8 */
  .long BUSY_IRQHandler             /* IRQ9 */
  .long ARINC429R_IRQHandler        /* IRQ10 */
  .long POWER_IRQHandler            /* IRQ11 */
  .long WWDG_IRQHandler             /* IRQ12 */
  .long Timer4_IRQHandler           /* IRQ13 */
  .long Timer1_IRQHandler           /* IRQ14 */
  .long Timer2_IRQHandler           /* IRQ15 */
  .long Timer3_IRQHandler           /* IRQ16 */
  .long ADC_IRQHandler              /* IRQ17 */
  .long ETHERNET_IRQHandler         /* IRQ18 */
  .long SSP3_IRQHandler             /* IRQ19 */
  .long SSP2_IRQHandler             /* IRQ20 */
  .long ARINC429T1_IRQHandler       /* IRQ21 */
  .long ARINC429T2_IRQHandler       /* IRQ22 */
  .long ARINC429T3_IRQHandler       /* IRQ23 */
  .long ARINC429T4_IRQHandler       /* IRQ24 */
  .long 0                           /* IRQ25 reserved */
  .long 0                           /* IRQ26 reserved */
  .long BKP_IRQHandler              /* IRQ27 */
  .long EXT_INT1_IRQHandler         /* IRQ28 */
  .long EXT_INT2_IRQHandler         /* IRQ29 */
  .long EXT_INT3_IRQHandler         /* IRQ30 */
  .long EXT_INT4_IRQHandler         /* IRQ31 */


  //Provide weak aliases for exception handlers to the Default_Handler.
  .macro	irq_handler	handler_name
  .weak	\handler_name
  .set	\handler_name, Default_Handler
  .endm

  irq_handler NMI_Handler
  irq_handler HardFault_Handler
  irq_handler SVC_Handler
  irq_handler PendSV_Handler
  irq_handler SysTick_Handler

  irq_handler MIL_STD_1553B2_IRQHandler
  irq_handler MIL_STD_1553B1_IRQHandler
  irq_handler USB_IRQHandler
  irq_handler CAN1_IRQHandler
  irq_handler CAN2_IRQHandler
  irq_handler DMA_IRQHandler
  irq_handler UART1_IRQHandler
  irq_handler UART2_IRQHandler
  irq_handler SSP1_IRQHandler
  irq_handler BUSY_IRQHandler
  irq_handler ARINC429R_IRQHandler
  irq_handler POWER_IRQHandler
  irq_handler WWDG_IRQHandler
  irq_handler Timer4_IRQHandler
  irq_handler Timer1_IRQHandler
  irq_handler Timer2_IRQHandler
  irq_handler Timer3_IRQHandler
  irq_handler ADC_IRQHandler
  irq_handler ETHERNET_IRQHandler
  irq_handler SSP3_IRQHandler
  irq_handler SSP2_IRQHandler
  irq_handler ARINC429T1_IRQHandler
  irq_handler ARINC429T2_IRQHandler
  irq_handler ARINC429T3_IRQHandler
  irq_handler ARINC429T4_IRQHandler
  irq_handler BKP_IRQHandler
  irq_handler EXT_INT1_IRQHandler
  irq_handler EXT_INT2_IRQHandler
  irq_handler EXT_INT3_IRQHandler
  irq_handler EXT_INT4_IRQHandler


