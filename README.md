# 说明 

在Linux上搭建STM32F100RBT6开发板开发环境，为QEMU做准备。

- 实现了LED
- 实现了串口打印，并且实现了printf打印
- 实现了按键
- 将HAL_Delay延迟函数从systick实现改为TIM7定时器，为后面移植FreeRTOS做准备

- 去掉`HAL`库中`Legacy`文件代码
- 优化`Makefile`语法，让隐藏文件`.main.o.d`等文件都放入到`obj`目录
- 增加串口2的初始化

