#include "blinking_leds_core.h"


BlinkLEDCore::BlinkLEDCore(uint32_t core_base_addr) 
{
   base_addr = core_base_addr;
   wr_data = 0;
}

BlinkLEDCore::~BlinkLEDCore() { }

void BlinkLEDCore::blink_set(int bit_pos, int delay) 
{
   io_write(base_addr, bit_pos, delay);
}
