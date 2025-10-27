/*
 * Startup file for STM32F103C6 microcontroller
 * This file contains the vector table and the startup code
 * for the STM32F103C6 microcontroller.
 * Write startup code for Reset_Handler and Default_Handler.
 * to init data and bss sections.
 * Call to main() function.
 */

#include <stdint.h>
extern uint32_t _edata;
extern uint32_t _sdata;
extern uint32_t _etext;
extern uint32_t _sbss;
extern uint32_t _ebss;
extern int main(void);
extern void SystemInit(void);
#define SRAM_START 0x20000000U
#define SRAM_SIZE  (10U * 1024U) // 10 KB
#define SRAM_END   (SRAM_START + SRAM_SIZE)
#define STACK_START SRAM_END
void Reset_Handler(void);
void Default_Handler(void);
void NMI_Handler(void) __attribute__((weak, alias("Default_Handler")));
void HardFault_Handler(void) __attribute__((weak, alias("Default_Handler")));
void MemManage_Handler(void) __attribute__((weak, alias("Default_Handler")));
void BusFault_Handler(void) __attribute__((weak, alias("Default_Handler")));
void UsageFault_Handler(void) __attribute__((weak, alias("Default_Handler")));
void SVC_Handler(void) __attribute__((weak, alias("Default_Handler")));
void DebugMon_Handler(void) __attribute__((weak, alias("Default_Handler")));
void PendSV_Handler(void) __attribute__((weak, alias("Default_Handler")));
void SysTick_Handler(void) __attribute__((weak, alias("Default_Handler")));
void WWDG_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void PVD_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void TAMPER_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void RTC_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void FLASH_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void RCC_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void EXTI0_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void EXTI1_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void EXTI2_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void EXTI3_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void EXTI4_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void DMA1_Channel1_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void DMA1_Channel2_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void DMA1_Channel3_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void DMA1_Channel4_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void DMA1_Channel5_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void DMA1_Channel6_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void DMA1_Channel7_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void ADC1_2_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void USB_HP_CAN1_TX_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void USB_LP_CAN1_RX0_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void USB_LP_CAN1_RX1_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void CAN1_SCE_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void EXTI9_5_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void TIM1_BRK_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void TIM1_UP_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void TIM1_TRG_COM_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void TIM1_CC_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void TIM2_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void TIM3_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void TIM4_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void I2C1_EV_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void I2C1_ER_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void I2C2_EV_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void I2C2_ER_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void SPI1_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void SPI2_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void USART1_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void USART2_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void USART3_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void EXTI15_10_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void RTC_Alarm_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void USBWakeUp_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void TIM8_BRK_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void TIM8_UP_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void TIM8_TRG_COM_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void TIM8_CC_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void ADC3_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void FSMC_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void SDIO_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void TIM5_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void SPI3_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void UART4_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void UART5_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void TIM6_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void TIM7_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void DMA2_Channel1_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void DMA2_Channel2_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void DMA2_Channel3_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
void DMA2_Channel4_5_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));

//Create vector table
uint32_t* vector_table[] __attribute__((section(".isr_vector"))) = {
    (uint32_t*) STACK_START, // Initial Stack Pointer
    (uint32_t*) Reset_Handler, // Reset Handler
    (uint32_t*) NMI_Handler, // NMI Handler
    (uint32_t*) HardFault_Handler, // Hard Fault Handler
    (uint32_t*) MemManage_Handler, // MPU Fault Handler
    (uint32_t*) BusFault_Handler, // Bus Fault Handler
    (uint32_t*) UsageFault_Handler, // Usage Fault Handler
    (uint32_t*) 0, // Reserved
    (uint32_t*) 0, // Reserved
    (uint32_t*) 0, // Reserved
    (uint32_t*) 0, // Reserved
    (uint32_t*) SVC_Handler, // SVCall Handler
    (uint32_t*) DebugMon_Handler, // Debug Monitor Handler
    (uint32_t*) 0, // Reserved
    (uint32_t*) PendSV_Handler, // PendSV Handler
    (uint32_t*) SysTick_Handler, // SysTick Handler
    (uint32_t*) WWDG_IRQHandler, // Window WatchDog
    (uint32_t*) PVD_IRQHandler, // PVD through EXTI Line detection
    (uint32_t*) TAMPER_IRQHandler, // Tamper
    (uint32_t*) RTC_IRQHandler, // RTC
    (uint32_t*) FLASH_IRQHandler, // Flash
    (uint32_t*) RCC_IRQHandler, // RCC
    (uint32_t*) EXTI0_IRQHandler, // EXTI Line0
    (uint32_t*) EXTI1_IRQHandler, // EXTI Line1
    (uint32_t*) EXTI2_IRQHandler, // EXTI Line2
    (uint32_t*) EXTI3_IRQHandler, // EXTI Line3
    (uint32_t*) EXTI4_IRQHandler, // EXTI Line4
    (uint32_t*) DMA1_Channel1_IRQHandler, // DMA1 Channel 1
    (uint32_t*) DMA1_Channel2_IRQHandler, // DMA1 Channel 2
    (uint32_t*) DMA1_Channel3_IRQHandler, // DMA1 Channel 3
    (uint32_t*) DMA1_Channel4_IRQHandler, // DMA1 Channel 4
    (uint32_t*) DMA1_Channel5_IRQHandler, // DMA1 Channel 5
    (uint32_t*) DMA1_Channel6_IRQHandler, // DMA1 Channel 6
    (uint32_t*) DMA1_Channel7_IRQHandler, // DMA1 Channel 7
    (uint32_t*) ADC1_2_IRQHandler, // ADC1 & ADC2
    (uint32_t*) USB_HP_CAN1_TX_IRQHandler, // USB High Priority or CAN1 TX
    (uint32_t*) USB_LP_CAN1_RX0_IRQHandler, // USB Low Priority or CAN1 RX0
    (uint32_t*) USB_LP_CAN1_RX1_IRQHandler, // USB Low Priority or CAN1 RX1
    (uint32_t*) CAN1_SCE_IRQHandler, // CAN1 SCE
    (uint32_t*) EXTI9_5_IRQHandler, // EXTI Line[9
    (uint32_t*) TIM1_BRK_IRQHandler, // TIM1 Break
    (uint32_t*) TIM1_UP_IRQHandler, // TIM1 Update
    (uint32_t*) TIM1_TRG_COM_IRQHandler, // TIM1 Trigger and Commutation
    (uint32_t*) TIM1_CC_IRQHandler, // TIM1 Capture Compare
    (uint32_t*) TIM2_IRQHandler, // TIM2
    (uint32_t*) TIM3_IRQHandler, // TIM3
    (uint32_t*) TIM4_IRQHandler, // TIM4
    (uint32_t*) I2C1_EV_IRQHandler, // I2C1 Event
    (uint32_t*) I2C1_ER_IRQHandler, // I2C1 Error
    (uint32_t*) I2C2_EV_IRQHandler, // I2C2 Event
    (uint32_t*) I2C2_ER_IRQHandler, // I2C2 Error
    (uint32_t*) SPI1_IRQHandler, // SPI1
    (uint32_t*) SPI2_IRQHandler, // SPI2
    (uint32_t*) USART1_IRQHandler, // USART1
    (uint32_t*) USART2_IRQHandler, // USART2
    (uint32_t*) USART3_IRQHandler, // USART3
    (uint32_t*) EXTI15_10_IRQHandler, // EXTI Line[15:10]
    (uint32_t*) RTC_Alarm_IRQHandler, // RTC Alarm through EXTI Line
    (uint32_t*) USBWakeUp_IRQHandler, // USB Wakeup from suspend
    (uint32_t*) TIM8_BRK_IRQHandler, // TIM8 Break
    (uint32_t*) TIM8_UP_IRQHandler, // TIM8 Update
    (uint32_t*) TIM8_TRG_COM_IRQHandler, // TIM8 Trigger and Commutation
    (uint32_t*) TIM8_CC_IRQHandler, // TIM8 Capture Compare
    (uint32_t*) ADC3_IRQHandler, // ADC3
    (uint32_t*) FSMC_IRQHandler, // FSMC
    (uint32_t*) SDIO_IRQHandler, // SDIO
    (uint32_t*) TIM5_IRQHandler, // TIM5
    (uint32_t*) SPI3_IRQHandler, // SPI3
    (uint32_t*) UART4_IRQHandler, // UART4
    (uint32_t*) UART5_IRQHandler, // UART5
    (uint32_t*) TIM6_IRQHandler, // TIM6
    (uint32_t*) TIM7_IRQHandler, // TIM7
    (uint32_t*) DMA2_Channel1_IRQHandler, // DMA2 Channel 1
    (uint32_t*) DMA2_Channel2_IRQHandler, // DMA2 Channel 2
    (uint32_t*) DMA2_Channel3_IRQHandler, // DMA2 Channel 3
    (uint32_t*) DMA2_Channel4_5_IRQHandler // DMA2 Channel 4 and 5
};
// Symbols defined in the linker script
extern uint32_t _sdata; // Start of .data section in SRAM
extern uint32_t _edata; // End of .data section in SRAM

void Reset_Handler(void){
    // Write reset handler code
    uint32_t data_size = (uint32_t)&_edata - (uint32_t)&_sdata;
    uint8_t *pSrc = (uint8_t*)&_etext; // flash location of .data
    uint8_t *pDest = (uint8_t*)&_sdata; // SRAM location of .data
    // nếu để uint32_t thì mỗi lần gán sẽ gán 4 byte, dẫn đến sai dữ liệu
    uint32_t i;
    for(i = 0; i < data_size; i++){
        *pDest++ = *pSrc++;
    }
    // Initialize .bss section to zero
    uint32_t bss_size = (uint32_t)&_ebss - (uint32_t)&_sbss;
    pDest = (uint8_t*)&_sbss; // Start of .bss
    for(i = 0; i < bss_size; i++){
        *pDest++ = 0;
    }
    SystemInit(); // Call system init function
    main();
}
void Default_Handler(void){
    // Write default handler code
    while (1) {
        // Loop forever
    }
}   