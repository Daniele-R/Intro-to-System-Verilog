#include "chu_init.h"
#include "gpio_cores.h"

void uart_delay(int delay) 
{
   uart.disp("current delay: ");
   uart.disp(delay);
   uart.disp(" ms");
   uart.disp("\n\r");
}

int get_delay(GpiCore *sw_p)
{
    int delay_min = 10;
	int step_size = 10;
	uint16_t mask = 0x003E;
    uint16_t sw_in = mask & sw_p->read();
    sw_in = sw_in >> 1;
    int delay = delay_min+(sw_in*step_size);
    return delay;
}

int sw_bit(GpiCore *sw_p, int bit) 
{
	int sw = sw_p->read();
	return bit_read(sw, bit);
}

void led_chaser(GpoCore *led_p, GpiCore *sw_p, int max_led)
{
   // Initialization
   int i, delay, delay_prev;
   delay = get_delay(sw_p);
   delay_prev = delay;
   
   // When sw0 == 1
   led_p->write(1, 0);
   sleep_ms(delay);
   led_p->write(0, 0);
   sleep_ms(delay);
   delay = get_delay(sw_p);
   if(delay != delay_prev)
      uart_delay(delay);

   // When sw0 == 0
   if(!(sw_bit(sw_p, 0)))
   {
       //Right to Left
	   for (i = 1; i < max_led; i++)
       {
          delay_prev = delay;
         
          led_p->write(1, i);
          sleep_ms(delay);
          led_p->write(0, i);
          sleep_ms(delay);
          delay = get_delay(sw_p);
	       
          if(delay != delay_prev)
            uart_delay(delay);
       }

       //Left to Right
       for (i = max_led - 2; i > 0; i--)
       {
          delay_prev = delay;
         
          led_p->write(1, i);
          sleep_ms(delay);
          led_p->write(0, i);
          sleep_ms(delay);
          delay = get_delay(sw_p);
	       
          if(delay != delay_prev)
            uart_delay(delay);
       }
   }
}

// instantiate switch, led
GpoCore led(get_slot_addr(BRIDGE_BASE, S2_LED));
GpiCore sw(get_slot_addr(BRIDGE_BASE, S3_SW));

// run main function
int main() 
{
   while (1) 
   {
	  led_chaser(&led, &sw, 16);
   }
}

