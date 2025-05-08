/*****************************************************************//**
 * @file main_vanilla_test.cpp
 *
 * @brief Basic test of 4 basic i/o cores
 *
 * @author p chu
 * @version v1.0: initial release
 *********************************************************************/

//#define _DEBUG
#include "chu_init.h"
#include "gpio_cores.h"
#include <string>

/**
 * blink once per second for 5 times.
 * provide a sanity check for timer (based on SYS_CLK_FREQ)
 * @param led_p pointer to led instance
 */
void timer_check(GpoCore *led_p) {
   int i;

   for (i = 0; i < 5; i++) {
      led_p->write(0xffff);
      sleep_ms(500);
      led_p->write(0x0000);
      sleep_ms(500);
      debug("timer check - (loop #)/now: ", i, now_ms());
   }
}

/**
 * check individual led
 * @param led_p pointer to led instance
 * @param n number of led
 */
void led_check(GpoCore *led_p, int n) {
   int i;

   for (i = 0; i < n; i++) {
      led_p->write(1, i);
      sleep_ms(200);
      led_p->write(0, i);
      sleep_ms(200);
   }
}

/**
 * leds flash according to switch positions.
 * @param led_p pointer to led instance
 * @param sw_p pointer to switch instance
 */
void sw_check(GpoCore *led_p, GpiCore *sw_p) {
   int i, s;

   s = sw_p->read();
   for (i = 0; i < 30; i++) {
      led_p->write(s);
      sleep_ms(50);
      led_p->write(0);
      sleep_ms(50);
   }
}

/**
 * uart transmits test line.
 * @note uart instance is declared as global variable in chu_io_basic.h
 */
void uart_check() {
   static int loop = 0;

   uart.disp("uart test #");
   uart.disp(loop);
   uart.disp("\n\r");
   loop++;
}

void chasing_led(GpoCore *led_p, GpiCore *sw_p )
{
   static int i = 0; //for which direction led will go, 1 = right, 0 = left
   static int n = 0; //for which led we are turning on
   static int old_sw = 0; //for sensing change in switch
   static int time = 0; //speed

   if(time == 0)
   {
       time = 138;
       uart.disp("current speed: ");
       uart.disp(time);
       uart.disp("\n\r");
   }

   int switch_value = sw_p->read();

   if(old_sw != (switch_value & 62))
   {
       old_sw = switch_value & 62;
       time = (old_sw >> 1) * 4 + 138;
       uart.disp("current speed: ");
       uart.disp(time);
       uart.disp("\n\r");
   }

    if(switch_value & 1)//stay in the right spot
    {
        n = 0;
    }

    led_p -> write(1, n); //turn individual light on
    sleep_ms(time);
    led_p -> write(0, n);
    sleep_ms(time);

   if (i == 0) //movement code
   {
      if (n == 15)
      {
         n = 14;
         i = 1;
      }
      else {
         n++;
      }
   }
   else if (i == 1)
   {
       if (n == 0)
       {
           n = 1;
           i = 0;
       }
       else {
           n--;
       }
   }
   
}

// instantiate switch, led
GpoCore led(get_slot_addr(BRIDGE_BASE, S2_LED));
GpiCore sw(get_slot_addr(BRIDGE_BASE, S3_SW));

int main() {

   while (1) {
      //timer_check(&led);
      //led_check(&led, 16);
      //sw_check(&led, &sw);
      //uart_check();
      chasing_led(&led, &sw);
      //debug("main - switch value / up time : ", sw.read(), now_ms());
   } //while
} //main

