#include <stdio.h>
#include "stm32f10x.h"
#include <stdint.h>
#include "function.h"
void task1(void);
void task2(void);
void idle_task(void);
void init_task_stack(void);
static int current_task=0;
static uint32_t g_tick_count = 0;
static TCB_task my_task[max_task];
void SysTick_Handler(void);
__attribute__((naked)) void switch_sp_to_psp(void);
__attribute__((naked)) void PendSV_Handler(void);
void save_psp_value(uint32_t psp_value);
uint32_t get_psp_value(void);
void update_next_task(void);

uint32_t get_psp_value(void)
{
	return my_task[current_task].psp_value;
}
__attribute__((naked)) void switch_sp_to_psp()
{
	__asm volatile ("push {lr}"); //luu lai LR
	__ASM volatile ("BL get_psp_value");//ket qua luu trong R0
	__ASM volatile ("MSR PSP,R0");
	__ASM volatile ("pop {lr}"); // lay lai gia tri LR
	// change to psp use control register
	__ASM volatile ("MOV R0,#0x02");
	__ASM volatile ("MSR CONTROL,R0");
	__ASM volatile ("BX LR");
}
void save_psp_value(uint32_t psp_value)
{
	my_task[current_task].psp_value = psp_value;
}
void update_next_task(void)
{
	int i;
	for(i=0;i<max_task;i++)
	{
		current_task++;
		current_task = current_task%max_task;
		if(current_task !=0 && my_task[current_task].current_state==runable_state)
		{
			my_task[current_task].current_state = running_state;
			return;
		}
	}
	current_task=0;
}
__attribute__((naked)) void PendSV_Handler(void)
{
	//lay gia tri psp cua task hien tai
	__ASM volatile ("MRS R0,PSP");
	__ASM volatile ("STMDB R0!,{R4-R11}");// cat cac thanh ghi R4-R11 vao stack
	__ASM volatile ("push {lr}");// luu tru thanh ghi LR
	__ASM volatile ("BL save_psp_value"); // luu lai gia tri psp cua task
	// chuyen sang task tiep theo
	__ASM volatile ("BL update_next_task");
	// lay psp cua task tiep theo
	__ASM volatile ("BL get_psp_value");
	__ASM volatile ("LDMIA R0!,{R4-R11}");
	__ASM volatile ("MSR PSP,R0");
	__ASM volatile ("pop {lr}");
	__ASM volatile ("BX LR");
}

__attribute__((noreturn)) void idle_task(void)
{
	while(1)
	{
	}
}
__attribute__((noreturn)) void task1(void)
{
	while(1)
	{
		GPIOC->BSRR |= GPIO_BSRR_BR13;
		task_delay(1000, my_task, current_task, g_tick_count);
		GPIOC->BSRR |= GPIO_BSRR_BS13;
		task_delay(1000, my_task, current_task, g_tick_count);
	}
}
__attribute__((noreturn)) void task2(void)
{
	while(1)
	{
		GPIOB->BSRR |= GPIO_BSRR_BS13;
		task_delay(1000, my_task, current_task, g_tick_count);
		GPIOB->BSRR |= GPIO_BSRR_BR13;
		task_delay(1000, my_task, current_task, g_tick_count);
	}
}

void init_task_stack(void)
{
		my_task[0].current_state = runable_state;
		my_task[1].current_state = runable_state;
		my_task[2].current_state = runable_state;
	
		my_task[0].psp_value=idle_stack;
		my_task[1].psp_value=task1_stack;
		my_task[2].psp_value=task2_stack;
	
		my_task[0].task_handeler = idle_task;
		my_task[1].task_handeler = task1;
		my_task[2].task_handeler = task2;
	
		my_task[0].block_count = 0;
		my_task[1].block_count = 0;
		my_task[2].block_count = 0;
		
	volatile uint32_t* psp;
	int i;
	for(i=0;i<max_task;i++)
	{
		psp = (uint32_t*)my_task[i].psp_value;
		psp--;
		*psp = 0x01000000;//xPSR
		psp--;
		*psp = (uint32_t)my_task[i].task_handeler;//PC counter
		psp--;
		*psp = 0xFFFFFFFD;
		int j;
		for(j=0;j<13;j++)
		{
			psp--;
			*psp = 0;
		}
		my_task[i].psp_value=(uint32_t)psp;
	}
}

void SysTick_Handler(void)
{
    g_tick_count++;

    // Unblock task if block_count == g_tick_count
    for (int i = 1; i < max_task; i++)
    {
        if (my_task[i].current_state == block_state)
        {
            if (g_tick_count >= my_task[i].block_count)
            {
                my_task[i].current_state = runable_state;
            }
        }
    }

    // Set PendSV d? trigger context switch
    SCB->ICSR |= SCB_ICSR_PENDSVSET_Msk;
}
int main(void)
{
		enable_fault();
		init_mainstack();
		init_task_stack();
		RCC->APB2ENR |= (1<<4);  // Enable GPIOC clock
    GPIOC->CRH &= 0xFF0FFFFF;  // Configure PC13 as output push-pull
    GPIOC->CRH |= (1<<21);
		RCC->APB2ENR|=RCC_APB2ENR_IOPBEN;
		GPIOB->CRH &= 0xFF0FFFFF;  // Configure PC13 as output push-pull
    GPIOB->CRH |= (1<<21); 
		switch_sp_to_psp();
		init_systick();
		NVIC_SetPriority(SysTick_IRQn,0U);
		schedule();
		while(1)
		{
		}
}
