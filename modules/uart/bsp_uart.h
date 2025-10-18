#ifndef __BSP_UART_H__
#define __BSP_UART_H__
#include "main.h"
extern UART_HandleTypeDef huart1;



void MX_USART1_UART_Init(void);

extern void myputstr(const char *str);


#endif

