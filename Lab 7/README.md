# lab-7-blinking-leds-core-the-multiplexers
## 11.9.4 Blinking-LEDs core
A blinking-LED core can turn LEDs on and off at specific rates. The core has a four-bit output signal connected to four discrete LEDs. It has four 16-bit registers that specify the values of the individual blinking intervals in milliseconds. With the blinking-LED core, the processor only needs to write the registers. The basic design and verification procedure is as follows:
- Design the blinking circuit for one LED and duplicate it four times.
- Determine the register map and derive the wrapping circuit.
- Derive the HDL code.
- Derive the device driver.
- Expand the vanilla MMIO subsystem to include a blinking-LED core in slot 4.
- Modify the vanilla FPro system to connect the led signal to the blinking-LED core and synthesize the new system.
- Derive a testing program and verify its operation.
- An interesting test program is one where you can see a pattern of the regular binary numbers from 0 to 15 on the consecutive LEDs. This can be achieved by halving the delays on the consecutive LEDs. i.e. LED1 has a delay of x, LED2 has a delay of x/2, LED3 has a delay of x/4, and LED4 has a delay of x/8.
