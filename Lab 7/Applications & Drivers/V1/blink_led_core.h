#ifndef _BLINK_H_INCLUDED
#define _BLINK_H_INCLUDED

#include "chu_init.h"

class BlinkingLedCore{
public:
    /* reg map*/
    enum {
        LED_REG_LEFT = 0,
        LED_REG_CENTER_LEFT = 1,
        LED_REG_CENTER_RIGHT = 2,
        LED_REG_RIGHT = 3
    };

    BlinkingLedCore(uint32_t core_base_addr);
    ~BlinkingLedCore();

    //list of functions/methods
    
    //This function writes to the register of my choice
    void write(int reg, uint32_t data);

//private variables
private:
    uint32_t base_addr;
    uint32_t wr_data;
};

#endif
