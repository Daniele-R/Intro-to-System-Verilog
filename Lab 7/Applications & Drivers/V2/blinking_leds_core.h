#ifndef SRC_BLINKING_LEDS_CORE_H_
#define SRC_BLINKING_LEDS_CORE_H_

#include "chu_io_rw.h"
#include "chu_io_map.h"

class BlinkLEDCore 
{
public:

   BlinkLEDCore(uint32_t core_base_addr);
   ~BlinkLEDCore();     

   void blink_set(int bit_pos, int delay);

private:
   uint32_t base_addr;
   uint32_t wr_data;                         // same as GPO core data reg
};

#endif
