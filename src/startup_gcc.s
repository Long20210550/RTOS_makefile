/* startup_gcc.s — Cortex-M3 (STM32F103C6), GNU assembler syntax */
.syntax unified
.cpu cortex-m3
.thumb

/* Các symbol do linker cung cấp */
.extern SystemInit
.extern main
/* Nếu bạn tự định nghĩa PendSV_Handler, SysTick_Handler trong C thì không cần extern ở đây */

/* Vector table đặt trong FLASH */
.global g_pfnVectors
.global Reset_Handler

.section .isr_vector,"a",%progbits
.type g_pfnVectors, %object
g_pfnVectors:
  .word _estack             /* Đỉnh stack (đặt trong linker.ld) */
  .word Reset_Handler       /* Reset */
  .word NMI_Handler
  .word HardFault_Handler
  .word MemManage_Handler
  .word BusFault_Handler
  .word UsageFault_Handler
  .word 0,0,0,0             /* Reserved */
  .word SVC_Handler
  .word DebugMon_Handler
  .word 0
  .word PendSV_Handler
  .word SysTick_Handler

  /* IRQs tối thiểu (có thể thêm tùy bạn dùng) */
  .word WWDG_IRQHandler             /* 0 */
  .word PVD_IRQHandler
  .word TAMPER_IRQHandler
  .word RTC_IRQHandler
  .word FLASH_IRQHandler
  .word RCC_IRQHandler
  .word EXTI0_IRQHandler
  .word EXTI1_IRQHandler
  .word EXTI2_IRQHandler
  .word EXTI3_IRQHandler
  .word EXTI4_IRQHandler
  .word DMA1_Channel1_IRQHandler
  .word DMA1_Channel2_IRQHandler
  .word DMA1_Channel3_IRQHandler
  .word DMA1_Channel4_IRQHandler
  .word DMA1_Channel5_IRQHandler
  .word DMA1_Channel6_IRQHandler
  .word DMA1_Channel7_IRQHandler
  .word ADC1_2_IRQHandler
  .word USB_HP_CAN1_TX_IRQHandler
  .word USB_LP_CAN1_RX0_IRQHandler
  .word CAN1_RX1_IRQHandler
  .word CAN1_SCE_IRQHandler
  .word EXTI9_5_IRQHandler
  .word TIM1_BRK_IRQHandler
  .word TIM1_UP_IRQHandler
  .word TIM1_TRG_COM_IRQHandler
  .word TIM1_CC_IRQHandler
  .word TIM2_IRQHandler
  .word TIM3_IRQHandler
  .word TIM4_IRQHandler
  .word I2C1_EV_IRQHandler
  .word I2C1_ER_IRQHandler
  .word I2C2_EV_IRQHandler
  .word I2C2_ER_IRQHandler
  .word SPI1_IRQHandler
  .word SPI2_IRQHandler
  .word USART1_IRQHandler
  .word USART2_IRQHandler
  .word USART3_IRQHandler
  .word EXTI15_10_IRQHandler
  .word RTCAlarm_IRQHandler
  .word USBWakeUp_IRQHandler
  /* Nếu MCU bạn có nhiều IRQ khác, thêm tiếp vào đây */

.size g_pfnVectors, . - g_pfnVectors

/* Default weak handlers: trỏ về Default_Handler nếu bạn không định nghĩa */
.macro WEAK_DEFAULT name
  .weak \name
  .thumb_func
  \name:
    b Default_Handler
.endm

.text
.thumb

/* Reset Handler */
.section .text.Reset_Handler,"ax",%progbits
.thumb_func
.type Reset_Handler, %function
Reset_Handler:
  bl  SystemInit
  bl  main
1: b 1b
.size Reset_Handler, . - Reset_Handler

/* Default handler */
.thumb_func
Default_Handler:
  b .

/* Cortex-M3 exceptions (weak) */
WEAK_DEFAULT NMI_Handler
WEAK_DEFAULT HardFault_Handler
WEAK_DEFAULT MemManage_Handler
WEAK_DEFAULT BusFault_Handler
WEAK_DEFAULT UsageFault_Handler
WEAK_DEFAULT SVC_Handler
WEAK_DEFAULT DebugMon_Handler
/* PendSV/SysTick: nếu bạn có trong C thì sẽ override, không thì rơi về default */
WEAK_DEFAULT PendSV_Handler
WEAK_DEFAULT SysTick_Handler

/* Peripheral IRQs (weak) - thêm đủ các IRQ bạn cần */
WEAK_DEFAULT WWDG_IRQHandler
WEAK_DEFAULT PVD_IRQHandler
WEAK_DEFAULT TAMPER_IRQHandler
WEAK_DEFAULT RTC_IRQHandler
WEAK_DEFAULT FLASH_IRQHandler
WEAK_DEFAULT RCC_IRQHandler
WEAK_DEFAULT EXTI0_IRQHandler
WEAK_DEFAULT EXTI1_IRQHandler
WEAK_DEFAULT EXTI2_IRQHandler
WEAK_DEFAULT EXTI3_IRQHandler
WEAK_DEFAULT EXTI4_IRQHandler
WEAK_DEFAULT DMA1_Channel1_IRQHandler
WEAK_DEFAULT DMA1_Channel2_IRQHandler
WEAK_DEFAULT DMA1_Channel3_IRQHandler
WEAK_DEFAULT DMA1_Channel4_IRQHandler
WEAK_DEFAULT DMA1_Channel5_IRQHandler
WEAK_DEFAULT DMA1_Channel6_IRQHandler
WEAK_DEFAULT DMA1_Channel7_IRQHandler
WEAK_DEFAULT ADC1_2_IRQHandler
WEAK_DEFAULT USB_HP_CAN1_TX_IRQHandler
WEAK_DEFAULT USB_LP_CAN1_RX0_IRQHandler
WEAK_DEFAULT CAN1_RX1_IRQHandler
WEAK_DEFAULT CAN1_SCE_IRQHandler
WEAK_DEFAULT EXTI9_5_IRQHandler
WEAK_DEFAULT TIM1_BRK_IRQHandler
WEAK_DEFAULT TIM1_UP_IRQHandler
WEAK_DEFAULT TIM1_TRG_COM_IRQHandler
WEAK_DEFAULT TIM1_CC_IRQHandler
WEAK_DEFAULT TIM2_IRQHandler
WEAK_DEFAULT TIM3_IRQHandler
WEAK_DEFAULT TIM4_IRQHandler
WEAK_DEFAULT I2C1_EV_IRQHandler
WEAK_DEFAULT I2C1_ER_IRQHandler
WEAK_DEFAULT I2C2_EV_IRQHandler
WEAK_DEFAULT I2C2_ER_IRQHandler
WEAK_DEFAULT SPI1_IRQHandler
WEAK_DEFAULT SPI2_IRQHandler
WEAK_DEFAULT USART1_IRQHandler
WEAK_DEFAULT USART2_IRQHandler
WEAK_DEFAULT USART3_IRQHandler
WEAK_DEFAULT EXTI15_10_IRQHandler
WEAK_DEFAULT RTCAlarm_IRQHandler
WEAK_DEFAULT USBWakeUp_IRQHandler

/* Kết thúc */

