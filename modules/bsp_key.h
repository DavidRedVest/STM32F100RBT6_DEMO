#ifndef __BSP_KEY_H__
#define __BSP_KEY_H__
#include "main.h"

#define WKUP_PRES	3		//WK_UP
#define WK_UP   HAL_GPIO_ReadPin(GPIOA,GPIO_PIN_0)//PA0


void GPIO_KEY_Init(void);

uint8_t key_scan(uint8_t mode);


#endif

