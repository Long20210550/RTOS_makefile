#include<stdint.h>
#define RAM_START 0x20000000U
#define SIZE_RAM (6*1024U)
#define RAM_END (RAM_START+SIZE_RAM)
#define SIZE_TASK 1024U
#define running_state 0x00
#define block_state 0x01
#define runable_state 0x10
#define max_task 3
#define Interrupt_dis() do{__ASM volatile("MOV R1,#0x01");__ASM volatile("MSR PRIMASK,R1");} while(0)
#define Interrupt_en() do{__ASM volatile("MOV R1,#0x00");__ASM volatile("MSR PRIMASK,R1");} while(0)
static uint32_t task1_stack = (uint32_t) RAM_END;
static uint32_t task2_stack = (uint32_t) (RAM_END-SIZE_TASK);
static uint32_t idle_stack = (uint32_t) (RAM_END-2U*SIZE_TASK);
static uint32_t main_stack = (uint32_t) (RAM_END-3U*SIZE_TASK);
typedef struct
{
	uint32_t psp_value;
	void(*task_handeler)(void);
	uint32_t block_count;
	int current_state;
}TCB_task;

void init_systick(void);
void task_delay(uint32_t tick_count, TCB_task my_task[], int current_task, uint32_t g_tick_count);
void schedule(void);
void enable_fault(void);
__attribute__((naked)) void init_mainstack(void);
