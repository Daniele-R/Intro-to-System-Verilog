#include "blink_led_core.h"

BlinkingLedCore::BlinkingLedCore(uint32_t core_base_addr){
    base_addr = core_base_addr;
    wr_data = 0;
}

BlinkingLedCore::~BlinkingLedCore(){
}

void BlinkingLedCore::write(int reg, uint32_t data){
    wr_data = data;
    io_write(base_addr, reg, wr_data);
}