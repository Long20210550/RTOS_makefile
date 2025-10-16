/* ******************** (C) COPYRIGHT 2011 STMicroelectronics ********************
 * File Name   : startup_gcc.s   (GNU/GAS, cho STM32F10x Low Density / Cortex-M3)
 * Mô tả       : 
 *  - Thiết lập SP từ vector[0]
 *  - PC = Reset_Handler (vector[1])
 *  - Bảng vector ngắt (exceptions + một số IRQ ngoại vi)
 *  - Gọi SystemInit() rồi khởi chạy C runtime tối thiểu (copy .data / zero .bss), sau đó gọi main()
 *  - Sau reset: Thread mode, Privileged, dùng Main Stack
 * ******************************************************************************/

    .syntax unified
    .cpu cortex-m3
    .thumb

/* Các symbol do linker cung cấp */
    .extern _estack
    .extern _sidata     /* LMA  của .data  (trong FLASH) */
    .extern _sdata      /* VMA bắt đầu của .data (trong RAM) */
    .extern _edata      /* VMA kết thúc của .data (trong RAM) */
    .extern _sbss       /* VMA bắt đầu của .bss  (trong RAM) */
    .extern _ebss       /* VMA kết thúc của .bss  (trong RAM) */

    .extern SystemInit
    .extern main

/* -----------------------------------------------------------------------------
 * Vector Table @ 0x08000000 (FLASH)
 * ---------------------------------------------------------------------------*/
    .section .isr_vector,"a",%progbits
    .align  2
    .global g_pfnVectors
g_pfnVectors:
    .word   _estack                 /* 0: Initial Main Stack Pointer */
    .word   Reset_Handler           /* 1: Reset */
    .word   NMI_Handler             /* 2: NMI */
    .word   HardFault_Handler       /* 3: HardFault */
    .word   MemManage_Handler       /* 4: MemManage */
    .word   BusFault_Handler        /* 5: BusFault */
    .word   UsageFault_Handler      /* 6: UsageFault */
    .word   0                       /* 7: Reserved */
    .word   0                       /* 8: Reserved */
    .word   0                       /* 9: Reserved */
    .word   0                       /* 10: Reserved */
    .word   SVC_Handler             /* 11: SVCall */
    .word   DebugMon_Handler        /* 12: DebugMon */
    .word   0                       /* 13: Reserved */
    .word   PendSV_Handler          /* 14: PendSV */
    .word   SysTick_Handler         /* 15: SysTick */

    /* --- External Interrupts (bám theo danh sách bạn đưa) --- */
    .word   WWDG_IRQHandler             /* Window Watchdog */
    .word   PVD_IRQHandler              /* PVD through EXTI Line detect */
    .word   TAMPER_IRQHandler           /* Tamper */
    .word   RTC_IRQHandler              /* RTC */
    .word   FLASH_IRQHandler            /* Flash */
    .word   RCC_IRQHandler              /* RCC */
    .word   EXTI0_IRQHandler            /* EXTI Line 0 */
    .word   EXTI1_IRQHandler            /* EXTI Line 1 */
    .word   EXTI2_IRQHandler            /* EXTI Line 2 */
    .word   EXTI3_IRQHandler            /* EXTI Line 3 */
    .word   EXTI4_IRQHandler            /* EXTI Line 4 */
    .word   DMA1_Channel1_IRQHandler    /* DMA1 Channel 1 */
    .word   DMA1_Channel2_IRQHandler    /* DMA1 Channel 2 */
    .word   DMA1_Channel3_IRQHandler    /* DMA1 Channel 3 */
    .word   DMA1_Channel4_IRQHandler    /* DMA1 Channel 4 */
    .word   DMA1_Channel5_IRQHandler    /* DMA1 Channel 5 */
    .word   DMA1_Channel6_IRQHandler    /* DMA1 Channel 6 */
    .word   DMA1_Channel7_IRQHandler    /* DMA1 Channel 7 */
    .word   ADC1_2_IRQHandler           /* ADC1_2 */
    .word   USB_HP_CAN1_TX_IRQHandler   /* USB HP / CAN1 TX */
    .word   USB_LP_CAN1_RX0_IRQHandler  /* USB LP / CAN1 RX0 */
    .word   CAN1_RX1_IRQHandler         /* CAN1 RX1 */
    .word   CAN1_SCE_IRQHandler         /* CAN1 SCE */
    .word   EXTI9_5_IRQHandler          /* EXTI Line 9..5 */
    .word   TIM1_BRK_IRQHandler         /* TIM1 Break */
    .word   TIM1_UP_IRQHandler          /* TIM1 Update */
    .word   TIM1_TRG_COM_IRQHandler     /* TIM1 Trigger/Commutation */
    .word   TIM1_CC_IRQHandler          /* TIM1 Capture Compare */
    .word   TIM2_IRQHandler             /* TIM2 */
    .word   TIM3_IRQHandler             /* TIM3 */
    .word   0                           /* Reserved (theo list gốc) */
    .word   I2C1_EV_IRQHandler          /* I2C1 Event */
    .word   I2C1_ER_IRQHandler          /* I2C1 Error */
    .word   0                           /* Reserved */
    .word   0                           /* Reserved */
    .word   SPI1_IRQHandler             /* SPI1 */
    .word   0                           /* Reserved */
    .word   USART1_IRQHandler           /* USART1 */
    .word   USART2_IRQHandler           /* USART2 */
    .word   0                           /* Reserved */
    .word   EXTI15_10_IRQHandler        /* EXTI Line 15..10 */
    .word   RTCAlarm_IRQHandler         /* RTC Alarm EXTI Line */
    .word   USBWakeUp_IRQHandler        /* USB Wakeup */

    .size   g_pfnVectors, . - g_pfnVectors

/* -----------------------------------------------------------------------------
 * Reset_Handler: copy .data từ FLASH→RAM, zero .bss, gọi SystemInit() rồi main()
 * ---------------------------------------------------------------------------*/
    .section .text.Reset_Handler,"ax",%progbits
    .align  2
    .global Reset_Handler
    .thumb_func
Reset_Handler:
    /* Copy .data */
    ldr     r0, =_sidata      /* src (FLASH) */
    ldr     r1, =_sdata       /* dst (RAM)   */
    ldr     r2, =_edata
1:
    cmp     r1, r2
    ittt    lt
    ldrlt   r3, [r0], #4
    strlt   r3, [r1], #4
    blt     1b

    /* Zero .bss */
    ldr     r1, =_sbss
    ldr     r2, =_ebss
    movs    r3, #0
2:
    cmp     r1, r2
    itt     lt
    strlt   r3, [r1], #4
    blt     2b

    /* Clock init */
    bl      SystemInit

    /* Nhảy vào main() */
    bl      main

/* Nếu main() trả về, treo ở đây */
3:  b       3b

/* -----------------------------------------------------------------------------
 * Default weak handlers
 * ---------------------------------------------------------------------------*/
    .section .text.Default_Handler,"ax",%progbits
    .align  2
    .thumb_func
Default_Handler:
    b       .

/* Macro tạo weak alias trỏ về Default_Handler */
    .macro  WEAK handler
    .weak   \handler
    .thumb_func
\handler:
    b       Default_Handler
    .endm

/* Cortex-M core exceptions (weak) */
    WEAK    NMI_Handler
    WEAK    HardFault_Handler
    WEAK    MemManage_Handler
    WEAK    BusFault_Handler
    WEAK    UsageFault_Handler
    WEAK    SVC_Handler
    WEAK    DebugMon_Handler
    WEAK    PendSV_Handler
    WEAK    SysTick_Handler

/* Peripheral IRQs (weak) – bám theo list vector ở trên */
    WEAK    WWDG_IRQHandler
    WEAK    PVD_IRQHandler
    WEAK    TAMPER_IRQHandler
    WEAK    RTC_IRQHandler
    WEAK    FLASH_IRQHandler
    WEAK    RCC_IRQHandler
    WEAK    EXTI0_IRQHandler
    WEAK    EXTI1_IRQHandler
    WEAK    EXTI2_IRQHandler
    WEAK    EXTI3_IRQHandler
    WEAK    EXTI4_IRQHandler
    WEAK    DMA1_Channel1_IRQHandler
    WEAK    DMA1_Channel2_IRQHandler
    WEAK    DMA1_Channel3_IRQHandler
    WEAK    DMA1_Channel4_IRQHandler
    WEAK    DMA1_Channel5_IRQHandler
    WEAK    DMA1_Channel6_IRQHandler
    WEAK    DMA1_Channel7_IRQHandler
    WEAK    ADC1_2_IRQHandler
    WEAK    USB_HP_CAN1_TX_IRQHandler
    WEAK    USB_LP_CAN1_RX0_IRQHandler
    WEAK    CAN1_RX1_IRQHandler
    WEAK    CAN1_SCE_IRQHandler
    WEAK    EXTI9_5_IRQHandler
    WEAK    TIM1_BRK_IRQHandler
    WEAK    TIM1_UP_IRQHandler
    WEAK    TIM1_TRG_COM_IRQHandler
    WEAK    TIM1_CC_IRQHandler
    WEAK    TIM2_IRQHandler
    WEAK    TIM3_IRQHandler
    /* Reserved slot bỏ qua */
    WEAK    I2C1_EV_IRQHandler
    WEAK    I2C1_ER_IRQHandler
    /* Reserved slot bỏ qua */
    /* Reserved slot bỏ qua */
    WEAK    SPI1_IRQHandler
    /* Reserved slot bỏ qua */
    WEAK    USART1_IRQHandler
    WEAK    USART2_IRQHandler
    /* Reserved slot bỏ qua */
    WEAK    EXTI15_10_IRQHandler
    WEAK    RTCAlarm_IRQHandler
    WEAK    USBWakeUp_IRQHandler

    .end
