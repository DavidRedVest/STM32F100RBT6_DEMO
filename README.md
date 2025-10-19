# 说明 

在Linux上搭建STM32F100RBT6开发板开发环境，为QEMU做准备。

- 实现了LED
- 实现了串口打印，并且实现了printf打印
- 实现了按键
- 将HAL_Delay延迟函数从systick实现改为TIM7定时器，为后面移植FreeRTOS做准备

- 去掉`HAL`库中`Legacy`文件代码
- 优化`Makefile`语法，让隐藏文件`.main.o.d`等文件都放入到`obj`目录
- 增加串口2的初始化

增加QEMU相关代码

- 实现RCC，模拟HSI+PLL+CFGR,HAL能正常初始化，不在卡住
- 实现FLASH，模拟ACR/SR/CR/WRPR等，HAL_ClockConfig校验通过
- 实现UART1，stdio输出串口，rt_kprintf()正常输出
- TIM7，模拟中断周期，HAL_Delay()成功返回
- 实现NVIC IRQ链，IRQ55(TIM7_IRQn)，中断触发、HAL_IncTick()正常
- 实现Systick替换，HAL_Tick改为TIM7，完全等价于真机行为。

