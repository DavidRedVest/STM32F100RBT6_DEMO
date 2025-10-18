# STM32 MCU Makefile

CROSS_COMPILE := arm-none-eabi-
CC      =$(CROSS_COMPILE)gcc
CPP     =$(CROSS_COMPILE)g++
LD      =$(CROSS_COMPILE)ld
AR      =$(CROSS_COMPILE)ar
OBJCOPY =$(CROSS_COMPILE)objcopy
OBJDUMP =$(CROSS_COMPILE)objdump
SIZE    =$(CROSS_COMPILE)size 

#设置全局变量
#固件库全局变量定义
#DEFS := -DUSE_STDPERIPH_DRIVER 
#HAL库全局变量定义
DEFS := -DUSE_HAL_DRIVER -DSTM32F100xB -DHSE_VALUE=8000000U -DHSI_VALUE=8000000U
#-DSTM32F429_439xx  

TARGET := firmware

#设置编译参数和编译选项
CFLAGS := -mcpu=cortex-m3 -mthumb -std=c11 -Wall -ffunction-sections -fdata-sections -fstack-usage
#-O2表示开启优化，-Og便于调试，-g3启用最高等级调试信息（配合GDB使用）
#CFLAGS += -g -O0
LDFLAGS := -mcpu=cortex-m3 -mthumb -Wl,--gc-sections -Wl,-Map=firmware.map -Wl,--print-memory-usage
LDFLAGS += -specs=nosys.specs 
#-specs=nano.specs
#LDFLAGS += -Wl,--start-group -lc -lm -Wl,--end-group

#添加文件路径
INCDIRS := stlib/cminc \
            stlib/inc \
            stlib/inc/Legacy \
            stlib \
            user \
            modules \
            modules/uart

SRCDIRS := stlib \
            stlib/src \
            stlib/src/Legacy \
            user \
            modules \
            modules/uart

VPATH := $(SRCDIRS) $(INCDIRS) 

#链接头文件
INCLUDE := $(patsubst %, -I %, $(INCDIRS))

# 不存在obj目录会报错，创建一个
$(shell mkdir -p obj)

#找到.S和.c文件
SFILES := $(foreach dir, $(SRCDIRS), $(wildcard $(dir)/*.S))
CFILES := $(foreach dir, $(SRCDIRS), $(wildcard $(dir)/*.c))
#去掉文件的路径
SFILENDIR := $(notdir $(SFILES))
CFILENDIR := $(notdir $(CFILES))
#将文件替换为.o文件
COBJS := $(patsubst %, obj/%, $(CFILENDIR:.c=.o))
SOBJS := $(patsubst %, obj/%, $(SFILENDIR:.S=.o))
OBJS := $(SOBJS) $(COBJS)

#头文件依赖
DEPS := $(patsubst obj/%, .%.d, $(OBJS))
DEPS := $(wildcard $(DEPS))

.PHONY: all clean upload

all:start_recursive_build $(TARGET)
	@echo $(TARGET) has been build!

start_recursive_build:
	@echo Hello
#   @make -C ./ -f $(TOPDIR)/Makefile.build

$(TARGET):$(OBJS)
	@$(CC) $^ -Tstlib/STM32F100XB_FLASH.ld -o $(TARGET).elf $(LDFLAGS)
	@$(OBJCOPY) -O binary -S $(TARGET).elf $(TARGET).bin
	@$(SIZE) $(TARGET).elf
	@$(OBJDUMP) -S $(TARGET).elf > $(TARGET).dis

#判断一下，防止重复包含头文件
ifneq ($(DEPS),)
include $(DEPS)
endif

#编译文件
$(SOBJS) : obj/%.o : %.S
	@$(CC) $(CFLAGS) $(INCLUDE) $(DEFS) -c -o $@ $< -MD -MF .$(notdir $@).d

$(COBJS) : obj/%.o : %.c
	@$(CC) $(CFLAGS) $(INCLUDE) $(DEFS) -c -o $@ $< -MD -MF .$(notdir $@).d


clean:
	@rm -f *.o *.bin *.elf *.dis .*.d obj/* *.map


upload:all
	@echo "Flashing firmware to STM32 via J-Link..."
	@JLinkExe jlink.cfg
	@echo "Done."

gdbserver:
	@JLinkGDBServer -device STM32F100RB -if SWD -speed 4000
    
