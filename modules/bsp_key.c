#include "bsp_key.h"

void GPIO_KEY_Init(void)
{
	GPIO_InitTypeDef GPIO_InitStruct = {0};
	
	  /* GPIO Ports Clock Enable */
	  __HAL_RCC_GPIOD_CLK_ENABLE();
	  __HAL_RCC_GPIOA_CLK_ENABLE();
	/*Configure GPIO pin : PA0 */
	  GPIO_InitStruct.Pin = GPIO_PIN_0;
	  GPIO_InitStruct.Mode = GPIO_MODE_INPUT;
	  GPIO_InitStruct.Pull = GPIO_PULLDOWN;
	  HAL_GPIO_Init(GPIOA, &GPIO_InitStruct);
}

uint8_t key_scan(uint8_t mode)
{
	static uint8_t key_up = 1;
	if(mode) {
		key_up = 1;
	}
	if(key_up && (WK_UP == 1)  ) {
		HAL_Delay(10);
		key_up = 0;
		if(WK_UP == 1) {
			return WKUP_PRES;
		}
	} else if(WK_UP == 0) {
		key_up = 1;
	}
	return 0;
}


