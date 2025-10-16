GCC_DIR:= C:/Program Files (x86)/GNU Arm Embedded Toolchain/10 2021.10/
CC:="$(GCC_DIR)/bin/arm-none-eabi-gcc"
AS:="$(GCC_DIR)/bin/arm-none-eabi-as"
OBJ:="$(GCC_DIR)/arm-none-eabi/bin/objcopy.exe"
ST_LINK:= "C:\Program Files (x86)\STMicroelectronics\STM32 ST-LINK Utility\ST-LINK Utility\ST-LINK_CLI.exe"

DEFS     := -DSTM32F10X_LD
Core := C:/Users/ADMIN/AppData/Local/Arm/Packs/ARM/CMSIS/5.7.0/CMSIS/Core/Include/
Device_driver:= C:/Users/ADMIN/AppData/Local/Arm/Packs/Keil/STM32F1xx_DFP/2.4.1/Device/Include 
CPPFLAGS := -Iinc -I$(Core) -I$(Device_driver) $(DEFS)
CFLAGS = -c -mcpu=cortex-m3 -mthumb -O2 -Wall
LD_FILE = linker.ld
LDFLAGS:= -nostdlib -T$(LD_FILE) -Wl,-Map=RTOS.map
build: out/main.o out/function.o out/system_stm32f10x.o out/startup_stm32f10x.o
	@echo 'Build PASS'
build_hex: out/RTOS.hex
	@echo 'Build hex pass'
out/main.o:src/main.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -o out/main.o src/main.c
out/function.o:src/function.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -o out/function.o src/function.c
out/system_stm32f10x.o:src/system_stm32f10x.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -o out/system_stm32f10x.o src/system_stm32f10x.c
out/startup_stm32f10x.o: src/startup_gcc.s
	$(AS) -mcpu=cortex-m3 -mthumb -o out/startup_stm32f10x.o src/startup_gcc.s
output: out/main.o out/function.o out/system_stm32f10x.o out/startup_stm32f10x.o
	$(CC) $(LDFLAGS) -o out/RTOS.elf out/main.o out/function.o out/system_stm32f10x.o out/startup_stm32f10x.o
out/RTOS.hex: out/RTOS.elf
	$(OBJ) -O ihex out/RTOS.elf out/RTOS.hex
run:
	$(ST_LINK) -ME
	@echo 'Erase chip done, start flash bin'
	$(ST_LINK) -p out/RTOSv1.hex 0x08000000
	@echo 'Flash done'
	@echo 'Restart chip'
	$(ST_LINK) -rst
