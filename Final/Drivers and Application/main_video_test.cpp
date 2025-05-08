/*****************************************************************//**
 * @file main_video_test.cpp
 *
 * @brief Basic test of 4 basic i/o cores
 *
 * @author p chu
 * @version v1.0: initial release
 *********************************************************************/

//#define _DEBUG
#include "chu_init.h"
#include "gpio_cores.h"
#include "vga_core.h"
#include "sseg_core.h"

//function prototype
void screen_init(SpriteCore *ghost_p, SpriteCore *ghost2_p, SpriteCore *ghost3_p, SpriteCore *lever_p, OsdCore *osd_p);
void gambling_screen(SpriteCore *ghost_p, SpriteCore *ghost2_p, SpriteCore *ghost3_p, SpriteCore *lever_p, int num_roll);
void reset_screen(SpriteCore *ghost_p, SpriteCore *ghost2_p, SpriteCore *ghost3_p);

void test_start(GpoCore *led_p) {
   int i;

   for (i = 0; i < 20; i++) {
      led_p->write(0xff00);
      sleep_ms(50);
      led_p->write(0x0000);
      sleep_ms(50);
   }
}

/**
 * check bar generator core
 * @param bar_p pointer to Gpv instance
 */
void bar_check(GpvCore *bar_p) {
   bar_p->bypass(0);
   sleep_ms(3000);
}

/**
 * check color-to-grayscale core
 * @param gray_p pointer to Gpv instance
 */
void gray_check(GpvCore *gray_p) {
   gray_p->bypass(0);
   sleep_ms(3000);
   gray_p->bypass(1);
}

/**
 * check osd core
 * @param osd_p pointer to osd instance
 */
void osd_check(OsdCore *osd_p) {
   osd_p->set_color(0x0f0, 0x001); // dark gray/green
   osd_p->bypass(0);
   osd_p->clr_screen();
   for (int i = 0; i < 64; i++) {
      osd_p->wr_char(8 + i, 20, i);
      osd_p->wr_char(8 + i, 21, 64 + i, 1);
      sleep_ms(100);
   }
   sleep_ms(3000);
}

/**
 * test frame buffer core
 * @param frame_p pointer to frame buffer instance
 */
void frame_check(FrameCore *frame_p) {
   int x, y, color;

   frame_p->bypass(0);
   for (int i = 0; i < 10; i++) {
      frame_p->clr_screen(0x008);  // dark green
      for (int j = 0; j < 20; j++) {
         x = rand() % 640;
         y = rand() % 480;
         color = rand() % 512;
         frame_p->plot_line(400, 200, x, y, color);
      }
      sleep_ms(300);
   }
   sleep_ms(3000);
}

/**
 * test ghost sprite
 * @param ghost_p pointer to mouse sprite instance
 */
void mouse_check(SpriteCore *mouse_p) {
   int x, y;

   mouse_p->bypass(0);
   // clear top and bottom lines
   for (int i = 0; i < 32; i++) {
      mouse_p->wr_mem(i, 0);
      mouse_p->wr_mem(31 * 32 + i, 0);
   }

   // slowly move mouse pointer
   x = 0;
   y = 0;
   for (int i = 0; i < 80; i++) {
      mouse_p->move_xy(x, y);
      sleep_ms(50);
      x = x + 4;
      y = y + 3;
   }
   sleep_ms(3000);
   // load top and bottom rows
   for (int i = 0; i < 32; i++) {
      sleep_ms(20);
      mouse_p->wr_mem(i, 0x00f);
      mouse_p->wr_mem(31 * 32 + i, 0xf00);
   }
   sleep_ms(3000);
}

/**
 * test ghost sprite
 * @param ghost_p pointer to ghost sprite instance
 */
void ghost_check(SpriteCore *ghost_p) {
   int x, y;

   // slowly move mouse pointer
   ghost_p->bypass(0);
   ghost_p->wr_ctrl(0x1c);  //animation; blue ghost
   x = 0;
   y = 100;
   for (int i = 0; i < 156; i++) {
      ghost_p->move_xy(x, y);
      sleep_ms(100);
      x = x + 4;
      if (i == 80) {
         // change to red ghost half way
         ghost_p->wr_ctrl(0x04);
      }
   }
   sleep_ms(3000);
}


//the added funcitons
/*
//ISL29501 Initialization
void chip_init(I2cCore *i2c)
{
    const uint8_t DEV_ADDR = 0x57;
    uint8_t wbytes[2];
    wbytes[0] = 0x10;
    wbytes[1] = 0x04; //note: this part of initialization was optional
    i2c -> write_transaction(DEV_ADDR, wbytes, 2, 0); //note: there is a good chance that the devices address is off since I don't know what A1 and A2 is suppose to be
    wbytes[0] = 0x11;
    wbytes[1] = 0x6E;
    i2c -> write_transaction(DEV_ADDR, wbytes, 2, 0);
    wbytes[0] = 0x13;
    wbytes[1] = 0x71;
    i2c -> write_transaction(DEV_ADDR, wbytes, 2, 0); //note: this sets up single shot mode
    wbytes[0] = 0x60;
    wbytes[1] = 0x01;
    i2c -> write_transaction(DEV_ADDR, wbytes, 2, 0); //note: sets up interupts
    wbytes[0] = 0x18;
    wbytes[1] = 0x22;
    i2c -> write_transaction(DEV_ADDR, wbytes, 2, 0);
    wbytes[0] = 0x19; 
    wbytes[1] = 0x22;
    i2c -> write_transaction(DEV_ADDR, wbytes, 2, 0);
    wbytes[0] = 0x90; //note: I used the vivado hierarchy (I believe it was this one) GitHub to figure out some of these values
    wbytes[1] = 0x0F;
    i2c -> write_transaction(DEV_ADDR, wbytes, 2, 0);
    wbytes[0] = 0x91;
    wbytes[1] = 0xFF;
    i2c -> write_transaction(DEV_ADDR, wbytes, 2, 0);
}


double distance_measurement(I2cCore *i2c)
{
    const uint8_t DEV_ADDR = 0x57;
    uint8_t wbytes[2], bytes[2];
    // wbytes = {0x13, 0x71}; //this stuff already done in the iniialization function
    // i2c -> write_transaction(DEV_ADDR, wbytes, 2, 0);
    // wbytes = {0x60, 0x01};
    // i2c -> write_transaction(DEV_ADDR, wbytes, 2, 0);
    wbytes[0] = 0x69; //clear interupt
    i2c -> write_transaction(DEV_ADDR, wbytes, 1, 1);
    i2c -> read_transaction(DEV_ADDR, bytes, 1, 0);

    wbytes[0] = 0xB0; //responsable for starting measurements, soft start
    wbytes[1] = 0x49;
    i2c -> write_transaction(DEV_ADDR, wbytes, 2, 0); //SS = 0, init. a dis. measurement

    wbytes[0] = 0xD1;
    i2c -> write_transaction(DEV_ADDR, wbytes, 1, 1);
    i2c -> read_transaction(DEV_ADDR, bytes, 2, 0);

    double distance = 0.0;
    distance = (((double)bytes[0] * 256.0 + (double)bytes[1])/65536.0) * 33.31 - 2.04; // Distance in meters (m)
    /*
    uart.disp("distance: ");
    uart.disp(distance, 3);
    uart.disp("\n\r"); */ /*
    return distance;
} */



// external core instantiation
GpoCore led(get_slot_addr(BRIDGE_BASE, S2_LED));
GpiCore sw(get_slot_addr(BRIDGE_BASE, S3_SW));
FrameCore frame(FRAME_BASE);
GpvCore bar(get_sprite_addr(BRIDGE_BASE, V7_BAR));
GpvCore gray(get_sprite_addr(BRIDGE_BASE, V6_GRAY)); 
SpriteCore lever(get_sprite_addr(BRIDGE_BASE, V4_USER4), 1024);///---------------
SpriteCore ghost(get_sprite_addr(BRIDGE_BASE, V3_GHOST), 1024);
SpriteCore ghost2(get_sprite_addr(BRIDGE_BASE, V1_MOUSE), 1024);
SpriteCore ghost3(get_sprite_addr(BRIDGE_BASE, V5_USER5), 1024);
OsdCore osd(get_sprite_addr(BRIDGE_BASE, V2_OSD)); ///----------
SsegCore sseg(get_slot_addr(BRIDGE_BASE, S8_SSEG));


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


// #define _DEBUG
#include "xadc_core.h"
#include "sseg_core.h"
#include "spi_core.h"
#include "i2c_core.h"
#include "ps2_core.h"
#include "ddfs_core.h"
#include "adsr_core.h"

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
      sleep_ms(100);
      led_p->write(0, i);
      sleep_ms(100);
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

/**
 * read FPGA internal voltage temperature
 * @param adc_p pointer to xadc instance
 */

void adc_check(XadcCore *adc_p, GpoCore *led_p) {
   double reading;
   int n, i;
   uint16_t raw;

   for (i = 0; i < 5; i++) {
      // display 12-bit channel 0 reading in LED
      raw = adc_p->read_raw(0);
      raw = raw >> 4;
      led_p->write(raw);
      // display on-chip sensor and 4 channels in console
      uart.disp("FPGA vcc/temp: ");
      reading = adc_p->read_fpga_vcc();
      uart.disp(reading, 3);
      uart.disp(" / ");
      reading = adc_p->read_fpga_temp();
      uart.disp(reading, 3);
      uart.disp("\n\r");
      for (n = 0; n < 4; n++) {
         uart.disp("analog channel/voltage: ");
         uart.disp(n);
         uart.disp(" / ");
         reading = adc_p->read_adc_in(n);
         uart.disp(reading, 3);
         uart.disp("\n\r");
      } // end for
      sleep_ms(200);
   }
}

/**
 * tri-color led dims gradually
 * @param led_p pointer to led instance
 * @param sw_p pointer to switch instance
 */

void pwm_3color_led_check(PwmCore *pwm_p) {
   int i, n;
   double bright, duty;
   const double P20 = 1.2589;  // P20=100^(1/20); i.e., P20^20=100

   pwm_p->set_freq(50);
   for (n = 0; n < 3; n++) {
      bright = 1.0;
      for (i = 0; i < 20; i++) {
         bright = bright * P20;
         duty = bright / 100.0;
         pwm_p->set_duty(duty, n);
         pwm_p->set_duty(duty, n + 3);
         sleep_ms(100);
      }
      sleep_ms(300);
      pwm_p->set_duty(0.0, n);
      pwm_p->set_duty(0.0, n + 3);
   }
}

/**
 * Test debounced buttons
 *   - count transitions of normal and debounced button
 * @param db_p pointer to debouceCore instance
 */

void debounce_check(DebounceCore *db_p, GpoCore *led_p) {
   long start_time;
   int btn_old, db_old, btn_new, db_new;
   int b = 0;
   int d = 0;
   uint32_t ptn;

   start_time = now_ms();
   btn_old = db_p->read();
   db_old = db_p->read_db();
   do {
      btn_new = db_p->read();
      db_new = db_p->read_db();
      if (btn_old != btn_new) {
         b = b + 1;
         btn_old = btn_new;
      }
      if (db_old != db_new) {
         d = d + 1;
         db_old = db_new;
      }
      ptn = d & 0x0000000f;
      ptn = ptn | (b & 0x0000000f) << 4;
      led_p->write(ptn);
   } while ((now_ms() - start_time) < 5000);
}

/**
 * Test pattern in 7-segment LEDs
 * @param sseg_p pointer to 7-seg LED instance
 */

void sseg_check(SsegCore *sseg_p) {
   int i, n;
   uint8_t dp;

   //turn off led
   for (i = 0; i < 8; i++) {
      sseg_p->write_1ptn(0xff, i);
   }
   //turn off all decimal points
   sseg_p->set_dp(0x00);

   // display 0x0 to 0xf in 4 epochs
   // upper 4  digits mirror the lower 4
   for (n = 0; n < 4; n++) {
      for (i = 0; i < 4; i++) {
         sseg_p->write_1ptn(sseg_p->h2s(i + n * 4), 3 - i);
         sseg_p->write_1ptn(sseg_p->h2s(i + n * 4), 7 - i);
         sleep_ms(300);
      } // for i
   }  // for n
      // shift a decimal point 4 times
   for (i = 0; i < 4; i++) {
      bit_set(dp, 3 - i);
      sseg_p->set_dp(1 << (3 - i));
      sleep_ms(300);
   }
   //turn off led
   for (i = 0; i < 8; i++) {
      sseg_p->write_1ptn(0xff, i);
   }
   //turn off all decimal points
   sseg_p->set_dp(0x00);

}

/**
 * Test adxl362 accelerometer using SPI
 */

void gsensor_check(SpiCore *spi_p, GpoCore *led_p) {
   const uint8_t RD_CMD = 0x0b;
   const uint8_t PART_ID_REG = 0x02;
   const uint8_t DATA_REG = 0x08;
   const float raw_max = 127.0 / 2.0;  //128 max 8-bit reading for +/-2g

   int8_t xraw, yraw, zraw;
   float x, y, z;
   int id;

   spi_p->set_freq(400000);
   spi_p->set_mode(0, 0);
   // check part id
   spi_p->assert_ss(0);    // activate
   spi_p->transfer(RD_CMD);  // for read operation
   spi_p->transfer(PART_ID_REG);  // part id address
   id = (int) spi_p->transfer(0x00);
   spi_p->deassert_ss(0);
   uart.disp("read ADXL362 id (should be 0xf2): ");
   uart.disp(id, 16);
   uart.disp("\n\r");
   // read 8-bit x/y/z g values once
   spi_p->assert_ss(0);    // activate
   spi_p->transfer(RD_CMD);  // for read operation
   spi_p->transfer(DATA_REG);  //
   xraw = spi_p->transfer(0x00);
   yraw = spi_p->transfer(0x00);
   zraw = spi_p->transfer(0x00);
   spi_p->deassert_ss(0);
   x = (float) xraw / raw_max;
   y = (float) yraw / raw_max;
   z = (float) zraw / raw_max;
   uart.disp("x/y/z axis g values: ");
   uart.disp(x, 3);
   uart.disp(" / ");
   uart.disp(y, 3);
   uart.disp(" / ");
   uart.disp(z, 3);
   uart.disp("\n\r");
}

/*
 * read temperature from adt7420
 * @param adt7420_p pointer to adt7420 instance
 */
void adt7420_check(I2cCore *adt7420_p, GpoCore *led_p) {
   const uint8_t DEV_ADDR = 0x4b;
   uint8_t wbytes[2], bytes[2];
   //int ack;
   uint16_t tmp;
   float tmpC;

   // read adt7420 id register to verify device existence
   // ack = adt7420_p->read_dev_reg_byte(DEV_ADDR, 0x0b, &id);

   wbytes[0] = 0x0b;
   adt7420_p->write_transaction(DEV_ADDR, wbytes, 1, 1);
   adt7420_p->read_transaction(DEV_ADDR, bytes, 1, 0);
   uart.disp("read ADT7420 id (should be 0xcb): ");
   uart.disp(bytes[0], 16);
   uart.disp("\n\r");
   //debug("ADT check ack/id: ", ack, bytes[0]);
   // read 2 bytes
   //ack = adt7420_p->read_dev_reg_bytes(DEV_ADDR, 0x0, bytes, 2);
   wbytes[0] = 0x00;
   adt7420_p->write_transaction(DEV_ADDR, wbytes, 1, 1);
   adt7420_p->read_transaction(DEV_ADDR, bytes, 2, 0);

   // conversion
   tmp = (uint16_t) bytes[0];
   tmp = (tmp << 8) + (uint16_t) bytes[1];
   if (tmp & 0x8000) {
      tmp = tmp >> 3;
      tmpC = (float) ((int) tmp - 8192) / 16;
   } else {
      tmp = tmp >> 3;
      tmpC = (float) tmp / 16;
   }
   uart.disp("temperature (C): ");
   uart.disp(tmpC);
   uart.disp("\n\r");
   led_p->write(tmp);
   sleep_ms(1000);
   led_p->write(0);
}

void ps2_check(Ps2Core *ps2_p) {
   int id;
   int lbtn, rbtn, xmov, ymov;
   char ch;
   unsigned long last;

   uart.disp("\n\rPS2 device (1-keyboard / 2-mouse): ");
   id = ps2_p->init();
   uart.disp(id);
   uart.disp("\n\r");
   last = now_ms();
   do {
      if (id == 2) {  // mouse
         if (ps2_p->get_mouse_activity(&lbtn, &rbtn, &xmov, &ymov)) {
            uart.disp("[");
            uart.disp(lbtn);
            uart.disp(", ");
            uart.disp(rbtn);
            uart.disp(", ");
            uart.disp(xmov);
            uart.disp(", ");
            uart.disp(ymov);
            uart.disp("] \r\n");
            last = now_ms();

         }   // end get_mouse_activitiy()
      } else {
         if (ps2_p->get_kb_ch(&ch)) {
            uart.disp(ch);
            uart.disp(" ");
            last = now_ms();
         } // end get_kb_ch()
      }  // end id==2
   } while (now_ms() - last < 5000);
   uart.disp("\n\rExit PS2 test \n\r");

}

/**
 * play primary notes with ddfs
 * @param ddfs_p pointer to ddfs core
 * @note: music tempo is defined as beats of quarter-note per minute.
 *        60 bpm is 1 sec per quarter note
 * @note "click" sound due to abrupt stop of a note
 *
 */
void ddfs_check(DdfsCore *ddfs_p, GpoCore *led_p) {
   int i, j;
   float env;

   //vol = (float)sw.read_pin()/(float)(1<<16),
   ddfs_p->set_env_source(0);  // select envelop source
   ddfs_p->set_env(0.0);   // set volume
   sleep_ms(500);
   ddfs_p->set_env(1.0);   // set volume
   ddfs_p->set_carrier_freq(262);
   sleep_ms(2000);
   ddfs_p->set_env(0.0);   // set volume
   sleep_ms(2000);
   // volume control (attenuation)
   ddfs_p->set_env(0.0);   // set volume
   env = 1.0;
   for (i = 0; i < 1000; i++) {
      ddfs_p->set_env(env);
      sleep_ms(10);
      env = env / 1.0109; //1.0109**1024=2**16
   }
   // frequency modulation 635-912 800 - 2000 siren sound
   ddfs_p->set_env(1.0);   // set volume
   ddfs_p->set_carrier_freq(635);
   for (i = 0; i < 5; i++) {               // 10 cycles
      for (j = 0; j < 30; j++) {           // sweep 30 steps
         ddfs_p->set_offset_freq(j * 10);  // 10 Hz increment
         sleep_ms(25);
      } // end j loop
   } // end i loop
   ddfs_p->set_offset_freq(0);
   ddfs_p->set_env(0.0);   // set volume
   sleep_ms(1000);
}

/**
 * play primary notes with ddfs
 * @param adsr_p pointer to adsr core
 * @param ddfs_p pointer to ddfs core
 * @note: music tempo is defined as beats of quarter-note per minute.
 *        60 bpm is 1 sec per quarter note
 *
 */
void adsr_check(AdsrCore *adsr_p, GpoCore *led_p, GpiCore *sw_p) {
   const int melody[] = { 0, 2, 4, 5, 7, 9, 11 };
   int i, oct;

   adsr_p->init();
   // no adsr envelop and  play one octave
   adsr_p->bypass();
   for (i = 0; i < 7; i++) {
      led_p->write(bit(i));
      adsr_p->play_note(melody[i], 3, 500);
      sleep_ms(500);
   }
   adsr_p->abort();
   sleep_ms(1000);
   // set and enable adsr envelop
   // play 4 octaves
   adsr_p->select_env(sw_p->read());
   for (oct = 3; oct < 6; oct++) {
      for (i = 0; i < 7; i++) {
         led_p->write(bit(i));
         adsr_p->play_note(melody[i], oct, 500);
         sleep_ms(500);
      }
   }
   led_p->write(0);
   // test duration
   sleep_ms(1000);
   for (i = 0; i < 4; i++) {
      adsr_p->play_note(0, 4, 500 * i);
      sleep_ms(500 * i + 1000);
   }
}

/**
 * core test
 * @param led_p pointer to led instance
 * @param sw_p pointer to switch instance
 */
void show_test_id(int n, GpoCore *led_p) {
   int i, ptn;

   ptn = n; //1 << n;
   for (i = 0; i < 20; i++) {
      led_p->write(ptn);
      sleep_ms(30);
      led_p->write(0);
      sleep_ms(30);
   }
}
double map_to_duty(double in, double in_min, double in_max) {
	double min_duty = 0.0;
	double max_duty = 1.0;
	return (in - in_min) * (max_duty - min_duty) / (in_max - in_min) + min_duty;
}

void spectrum_set(PwmCore *pwm_p, double volt) {
	pwm_p->set_freq(50);
	double volt_adj = volt*6;
	//bit 0 is blue, bit 1 is green, bit 2 is red (check Nexys xdc file)
	if(volt_adj >= 0.0 && volt_adj <= 1.0){
		pwm_p->set_duty(1.0,2);
		pwm_p->set_duty(map_to_duty(volt_adj, 0.0, 1.0),1);
		pwm_p->set_duty(0.0,0);
	}
	if(volt_adj > 1.0 && volt_adj <= 2.0){
		pwm_p->set_duty(map_to_duty(1.0 + 2.0 - volt_adj, 1.0, 2.0),2);
		pwm_p->set_duty(1.0,1);
		pwm_p->set_duty(0.0,0);
	}
	if(volt_adj > 2.0 && volt_adj <= 3.0){
		pwm_p->set_duty(0.0,2);
		pwm_p->set_duty(1.0,1);
		pwm_p->set_duty(map_to_duty(volt_adj, 2.0, 3.0),0);
	}
	if(volt_adj > 3.0 && volt_adj <= 4.0){
		pwm_p->set_duty(0.0,2);
		pwm_p->set_duty(map_to_duty(3.0 + 4.0 - volt_adj, 3.0, 4.0),2);
		pwm_p->set_duty(1.0,0);
	}
	if(volt_adj > 4.0 && volt_adj <= 5.0){
		pwm_p->set_duty(map_to_duty(volt_adj, 4.0, 5.0),2);
		pwm_p->set_duty(0.0,1);
		pwm_p->set_duty(1.0,0);
	}
	if(volt_adj > 5.0 && volt_adj <= 6.0){
		pwm_p->set_duty(1.0,2);
		pwm_p->set_duty(0.0,1);
		pwm_p->set_duty(map_to_duty(5.0 + 6.0 - volt, 5.0, 6.0),2);
	}
}

void chip_init(I2cCore *i2c) //calibration/initialization (I2cCore *i2c, )
{
    //chip init.
    const uint8_t DEV_ADDR = 0x57;
    uint8_t wbytes[2];
    wbytes[0] = 0x10;
    wbytes[1] = 0x04; // Initialization  optional
    i2c -> write_transaction(DEV_ADDR, wbytes, 2, 0); 
    wbytes[0] = 0x11;
    wbytes[1] = 0x6E;
    i2c -> write_transaction(DEV_ADDR, wbytes, 2, 0);
    wbytes[0] = 0x13;
    wbytes[1] = 0x71;
    i2c -> write_transaction(DEV_ADDR, wbytes, 2, 0); //note: this sets up ss
    wbytes[0] = 0x60;
    wbytes[1] = 0x01;
    i2c -> write_transaction(DEV_ADDR, wbytes, 2, 0); //note: sets up interupts
    wbytes[0] = 0x18;
    wbytes[1] = 0x22; 
    i2c -> write_transaction(DEV_ADDR, wbytes, 2, 0);
    wbytes[0] = 0x19; 
    wbytes[1] = 0x22; 
    i2c -> write_transaction(DEV_ADDR, wbytes, 2, 0);
    wbytes[0] = 0x90; //The wbytes[1] from GitHub
    wbytes[1] = 0x0F;
    i2c -> write_transaction(DEV_ADDR, wbytes, 2, 0);
    wbytes[0] = 0x91;
    wbytes[1] = 0xFF;
    i2c -> write_transaction(DEV_ADDR, wbytes, 2, 0);
}

double distance_measurement(I2cCore *i2c)   // Double distance measurements (I2cCore *i2c)
{
    const uint8_t DEV_ADDR = 0x57;
    uint8_t wbytes[2], bytes[2];            // <- bytes may be more or less based on how many I plan to read

    wbytes[0] = 0x69;                       // Interrupt clear
    i2c -> write_transaction(DEV_ADDR, wbytes, 1, 1);
    i2c -> read_transaction(DEV_ADDR, bytes, 1, 0);

    wbytes[0] = 0xB0;
    wbytes[1] = 0x49;                    // Soft start instead of physical
    i2c -> write_transaction(DEV_ADDR, wbytes, 2, 0);    // SS = 0, init. a dis. measurement

    wbytes[0] = 0xD1;
    i2c -> write_transaction(DEV_ADDR, wbytes, 1, 1);
    i2c -> read_transaction(DEV_ADDR, bytes, 2, 0);

    double distance = 0.0;
    distance = (((double)bytes[0] * 256 + (double)bytes[1])/65536 * 33.31) - 2.0; // Distance in meters (m)
    return distance;
}


void display_double(SsegCore *sseg_p, double d)
// how to display numbr on seg here (seg core, double number)
{
    int i;
    double distance = d;

    //turn off led
    for (i = 0; i < 4; i++) 
    {
        sseg_p->write_1ptn(0xff, i+4);
    }
   
   //turn off all decimal points
    sseg_p->set_dp(0x00);
    sseg_p->write_1ptn(sseg_p->h2s((int)distance), 3);
    sseg_p->write_1ptn(sseg_p->h2s((int)((distance - (int)distance)*10)), 2);
    sseg_p->write_1ptn(sseg_p->h2s((int)((distance*10 - (int)(distance*10))*10)), 1);
    sseg_p->write_1ptn(sseg_p->h2s((int)((distance*100 - (int)(distance*100))*10)), 0);
}

void display_double2(SsegCore *sseg_p, double d)
// how to display numbr on seg here (seg core, double number)
{
    int i;
    double distance = d;

    //turn off led
    for (i = 0; i < 4; i++) 
    {
        sseg_p->write_1ptn(0xff, i+4);
    }
   
   //turn off all decimal points
    sseg_p->set_dp(0x00);
    sseg_p->write_1ptn(sseg_p->h2s((int)distance), 7);
    sseg_p->write_1ptn(sseg_p->h2s((int)((distance - (int)distance)*10)), 6);
    sseg_p->write_1ptn(sseg_p->h2s((int)((distance*10 - (int)(distance*10))*10)), 5);
    sseg_p->write_1ptn(sseg_p->h2s((int)((distance*100 - (int)(distance*100))*10)), 4);

}


XadcCore adc(get_slot_addr(BRIDGE_BASE, S5_XDAC));
PwmCore pwm(get_slot_addr(BRIDGE_BASE, S6_PWM));
DebounceCore btn(get_slot_addr(BRIDGE_BASE, S7_BTN));
SpiCore spi(get_slot_addr(BRIDGE_BASE, S9_SPI));
I2cCore adt7420(get_slot_addr(BRIDGE_BASE, S10_I2C));
Ps2Core ps2(get_slot_addr(BRIDGE_BASE, S11_PS2));
DdfsCore ddfs(get_slot_addr(BRIDGE_BASE, S12_DDFS));
AdsrCore adsr(get_slot_addr(BRIDGE_BASE, S13_ADSR), &ddfs);


int mouse_betting(GpoCore *led_p, Ps2Core *ps2_p)
{
    static bool initialization = true; 
    if (initialization == true)
    {
        ps2_p -> init();
        initialization = false;
    }
    
    int lbtn, rbtn, xmov, ymov;

    if (ps2_p->get_mouse_activity(&lbtn, &rbtn,&xmov, &ymov))
    {
        if(lbtn)
        {
            uart.disp("LEFT CLICKED \n\r");
            return 1;
        }
        else if(rbtn)
        {
            uart.disp("RIGHT CLICKED \n\r");
            return 2;
        }
    }
}

uint8_t char_to_7seg(char c) 
{
    switch (c) 
    {
        case 'u': return 0x43; // "u"
        case 'w': return 0x61; // "w"
        case 'I': return ~0x06; // "I"
        case 'n': return ~0x54; // "n"
        case 'E': return ~0x79; // "E"
        case 'r': return ~0x50; // "r"
        default:  return ~0xff; // Blank
    }
}
void display_uuInnEr(SsegCore *sseg_p) 
{
    // Clear all segments
    for (int i = 0; i < 8; i++) 
    {
        sseg_p->write_1ptn(0xff, i+4);
    }

    // Write each character to the corresponding segment
    sseg_p->write_1ptn(char_to_7seg('u'), 6); // Segment 0
    sseg_p->write_1ptn(char_to_7seg('w'), 5); // Segment 0
    sseg_p->write_1ptn(char_to_7seg('I'), 4); // Segment 1
    sseg_p->write_1ptn(char_to_7seg('n'), 3); // Segment 2
    sseg_p->write_1ptn(char_to_7seg('n'), 2); // Segment 3
    sseg_p->write_1ptn(char_to_7seg('E'), 1); // Segment 4
    sseg_p->write_1ptn(char_to_7seg('r'), 0); // Segment 5
}


int main() 
{
    frame.bypass(1);
    bar.bypass(1);
    gray.bypass(1);
    lever.bypass(1);
    ghost.bypass(1);
    ghost2.bypass(1);
    ghost3.bypass(1);
    osd.bypass(1);
    sleep_ms(3000);

    uart.disp("BUILT \n\r");
    chip_init(&adt7420);

    double dist = 0;
    double jackpot= 0;
    bool winner = false;
    int roll = 0;
    
    int mouse_action;
    
    //place osd stuff here and ghost initializaiton
    screen_init(&ghost, &ghost2, &ghost3, &lever, &osd); ///.....


    while (winner == false) 
    { 
        uart.disp("loop \n\r");

        dist = distance_measurement(&adt7420);

        display_double(&sseg, dist); //right
        display_double2(&sseg, jackpot); //left
        
        mouse_action = mouse_betting(&led, &ps2);
        
        if (mouse_action == 1) //left click, select amount to bet
        {
            jackpot += dist;
            roll += 1;

            if (jackpot > 9.999) 
            {
                jackpot = 9.999;
            }

            //this is where the action starts and the colors start changing and the lever is moved..., use roll to know if fail or when success
            // note: the random colors will not be random and will be based on what roll number we are on.
            gambling_screen(&ghost, &ghost2, &ghost3, &lever, roll);

            if (roll == 3)
            {
                winner = true;
            }
        }
        else if(mouse_action == 2) // right click erase, to go, reset of jackpot, owner emptying jackpot
        {
            jackpot = 0;
        }

        sleep_ms(50);
    }

    if (winner == true)
    {
        display_uuInnEr(&sseg);
        for (int i = 0; i < 20; i++)
        {
            led_chaser(&led, &sw, 16);
            //pwm_3color_led_check(&pwm);
        }
        jackpot = 0;
        roll = 0;//for my gambling function to not break
        reset_screen(&ghost, &ghost2, &ghost3);//stop animation here for winning.
    }
}


void screen_init(SpriteCore *ghost_p, SpriteCore *ghost2_p, SpriteCore *ghost3_p, SpriteCore *lever_p, OsdCore *osd_p){ // note my lever is animated wrong but the way
    int x, y;

    ghost_p ->bypass(0);
    ghost_p ->wr_ctrl(0x04);//animate, red ghosts
    x = 159;
    y = 239;
    ghost_p ->move_xy(x, y);

    ghost2_p ->bypass(0);
    ghost2_p ->wr_ctrl(0x0c);//animate, pink ghosts
    x = 319;
    ghost2_p ->move_xy(x, y);

    ghost3_p ->bypass(0);
    ghost3_p ->wr_ctrl(0x14);//animate, orange ghosts
    x = 479;
    ghost3_p ->move_xy(x, y);

    lever_p ->bypass(0);
    lever_p ->wr_ctrl(0x02);//animate starting from initial phase
    x = 319;
    y = 300;
    lever_p ->move_xy(x, y);

    //osd stuff
    osd_p ->bypass(0);
    osd_p->clr_screen();
    osd_p->wr_char(314, 300, 71, 0); //G
    osd_p->wr_char(315, 300, 97, 0); //a
    osd_p->wr_char(316, 300, 109, 0); //m
    osd_p->wr_char(317, 300, 98, 0); //b
    osd_p->wr_char(318, 300, 108, 0); //l
    osd_p->wr_char(319, 300, 105, 0); //i
    osd_p->wr_char(320, 300, 110, 0); //n
    osd_p->wr_char(321, 300, 103, 0); //g
    osd_p->wr_char(322, 300, 0, 0); //(space)
    osd_p->wr_char(323, 300, 84, 0); //T
    osd_p->wr_char(324, 300, 105, 0); //i
    osd_p->wr_char(325, 300, 109, 0); //m
    osd_p->wr_char(326, 300, 101, 0); //e


    sleep_ms(2000);

    ghost_p ->wr_ctrl(0x00);
    ghost2_p ->wr_ctrl(0x00);
    ghost3_p ->wr_ctrl(0x00);
    lever_p ->wr_ctrl(0x00);
}

void gambling_screen(SpriteCore *ghost_p, SpriteCore *ghost2_p, SpriteCore *ghost3_p, SpriteCore *lever_p, int num_roll){
    ghost_p ->bypass(1);
    ghost2_p ->bypass(1);
    ghost3_p ->bypass(1);
    lever_p ->wr_ctrl(0x01);
    sleep_ms(500);

    if(num_roll == 3)
    {
        ghost_p ->wr_ctrl(0x14);
        ghost2_p ->wr_ctrl(0x14);
        ghost3_p ->wr_ctrl(0x14);
    }
    else if (num_roll == 2)
    {
        ghost_p ->wr_ctrl(0x00);
        ghost2_p ->wr_ctrl(0x00);
        ghost3_p ->wr_ctrl(0x08);
    }
    else if (num_roll == 1)
    {
        ghost_p ->wr_ctrl(0x10);
        ghost2_p ->wr_ctrl(0x18);
        ghost3_p ->wr_ctrl(0x00);
    }

    ghost_p ->bypass(0);
    ghost2_p ->bypass(0);
    ghost3_p ->bypass(0);
    lever_p ->wr_ctrl(0x00);
}

void reset_screen(SpriteCore *ghost_p, SpriteCore *ghost2_p, SpriteCore *ghost3_p)
{
    ghost_p ->wr_ctrl(0x00);
    ghost2_p ->wr_ctrl(0x00);
    ghost3_p ->wr_ctrl(0x00);
}

//my reference 
/*
int main() {
   while (1) {
      //test_start(&led);
      // bypass all cores
      frame.bypass(1);
      bar.bypass(1);
      gray.bypass(1);
      ghost.bypass(1);
      osd.bypass(1);
      mouse.bypass(1);
      sleep_ms(3000);

      // enable cores one by one
      //frame_check(&frame);
      //bar_check(&bar);
      //gray_check(&gray);
      //ghost_check(&ghost);
      //osd_check(&osd);
      //mouse_check(&mouse);
      while (sw.read(0)) {
         // test composition with different overlays if sw(0) is 1
         mouse.bypass(sw.read(1));
         osd.bypass(sw.read(2));
         ghost.bypass(sw.read(3));
         gray.bypass(sw.read(6));
         bar.bypass(sw.read(7));
         frame.bypass(sw.read(8));
         // set osd background color to transparent
         osd.set_color(0x0f0, sw.read(9));
         // set color/animation of ghost sprite
         ghost.wr_ctrl(sw.read() >> 11);
      } //while

    //the osd stuff
    //

   } // while
} //main
*/
