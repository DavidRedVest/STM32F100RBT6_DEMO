# 说明 

在Linux上搭建STM32F100RBT6开发板开发环境，为QEMU做准备。

- 实现了LED
- 实现了串口打印，并且实现了printf打印
- 实现了按键
- 将HAL_Delay延迟函数从systick实现改为TIM7定时器，为后面移植FreeRTOS做准备。

