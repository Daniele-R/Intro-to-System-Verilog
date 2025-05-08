# lab-6-chasing-leds-the-multiplexers

## Chasing LEDs (10.10.1)

The `led_check()` function of the test program sequentially turns on and off individual LEDs, making the lit LED appear to "chase" along the strip. The **Chasing LEDs** program enhances this function as follows:

### Program Specifications

1. **LED Output**:
   - All 16 discrete LEDs are used as output, with one LED lit at a time.

2. **LED Movement**:
   - The lit LED moves sequentially in either direction along the strip.
   - It changes direction when it reaches either the rightmost or leftmost position.

3. **Initialization with Switch (sw0)**:
   - The slide switch 0 (`sw0`) on the Nexys 4 DDR board is used to initialize the process.
   - When `sw0` is set to `1`, the lit LED is moved to the rightmost position.

4. **Chasing Speed Control (sw1 to sw5)**:
   - The next five slide switches (`sw1` to `sw5`) control the chasing speed of the LED.
   - The maximum speed should be slow enough to allow visual inspection.

5. **Speed Change Message**:
   - When the chasing speed is adjusted, a one-line message is transmitted to the console via the UART core.
   - The format of the message is:  
     `"current speed: ddd"`  
     where `ddd` is the value represented by the five speed-setting switches.

### Development Tasks

- **Software Development**: Develop software to implement the specified behavior.
- **Verification**: Verify the operation of the software to ensure the functionality of the chasing LEDs and speed control.
