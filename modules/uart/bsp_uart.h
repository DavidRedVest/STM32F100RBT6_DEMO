#ifndef __BSP_UART_H__
#define __BSP_UART_H__
#include "main.h"
extern UART_HandleTypeDef huart1;
extern UART_HandleTypeDef huart2;

void MX_USART1_UART_Init(void);
void MX_USART2_UART_Init(void);

extern void myputstr(const char *str);


#endif

