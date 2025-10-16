#include <stdio.h>
#include "stm32f10x.h"
#include <stdint.h>
#include "function.h"
void schedule(void)
{
	SCB->ICSR |= SCB_ICSR_PENDSVSET_Msk;
}
void task_delay(uint32_t tick_count, TCB_task my_task[], int current_task, uint32_t g_tick_count)
{
	//disable interrupt
	my_task[current_task].block_count = g_tick_count + tick_count;
	my_task[current_task].current_state = block_state;
	Interrupt_dis();
	schedule();
	Interrupt_en();
	//enable interrupt
}
__attribute__((naked)) void init_mainstack()
{
	__ASM volatile ("MSR MSP, %0": : "r"(main_stack):);
	__ASM volatile ("BX LR ");
}
void enable_fault(void)
{
	SCB->SHCSR |= SCB_SHCSR_BUSFAULTENA_Msk;
	SCB->SHCSR |= SCB_SHCSR_MEMFAULTENA_Msk;
	SCB->SHCSR |= SCB_SHCSR_USGFAULTENA_Msk;
}
void init_systick(void)
{
	uint32_t reloadvalue = 72U*1000-1;
	SysTick->LOAD = reloadvalue;
	SysTick->VAL = 0U;
	SysTick->CTRL = 7U;
}
