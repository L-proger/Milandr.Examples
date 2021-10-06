#include <MDR32F9Qx_port.h>
#include <MDR32F9Qx_rst_clk.h>

#define LED_VD5_PIN PORT_Pin_0
#define LED_VD6_PIN PORT_Pin_11
#define LED_VD7_PIN PORT_Pin_8
#define LED_VD8_PIN PORT_Pin_7

void configurePll(void) {
	RST_CLK_DeInit();
	RST_CLK_HSEconfig(RST_CLK_HSE_ON);

	if (RST_CLK_HSEstatus() == ERROR) while (1);

	//Set 144MHz CPU clock
	RST_CLK_CPU_PLLconfig(RST_CLK_CPU_PLLsrcHSEdiv1, RST_CLK_CPU_PLLmul9);
	RST_CLK_CPU_PLLcmd(ENABLE);

	if (RST_CLK_CPU_PLLstatus() == ERROR) while (1);

	RST_CLK_CPU_PLLuse(ENABLE);
	RST_CLK_CPUclkSelection(RST_CLK_CPUclkCPU_C3);
	RST_CLK_PCLKcmd(RST_CLK_PCLK_PORTA, ENABLE);
	RST_CLK_PCLKcmd(RST_CLK_PCLK_PORTD, ENABLE);
}

extern "C" int main() {
	configurePll();


	PORT_InitTypeDef PORT_InitStructure;
	PORT_InitStructure.PORT_OE = PORT_OE_OUT;
	PORT_InitStructure.PORT_FUNC = PORT_FUNC_PORT;
	PORT_InitStructure.PORT_MODE = PORT_MODE_DIGITAL;
	PORT_InitStructure.PORT_SPEED = PORT_SPEED_MAXFAST;
	PORT_InitStructure.PORT_Pin = (LED_VD5_PIN);
	PORT_Init(MDR_PORTD, &PORT_InitStructure);


	int i = 0;
	while(true){
		++i;
		PORT_WriteBit(MDR_PORTD, LED_VD5_PIN, ((i / 1000000) % 2 == 0) ? SET : RESET);
	}

	return 0;
}

