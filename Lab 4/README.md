# lab-4-rom-based-temperature-conversion-the-multiplexers

## 7.7.2 ROM-based temperature conversion


Temperature can be measured in Celsius or Fahrenheit scale. Let c and f be a temperature
reading in Celsius and Fahrenheit scales. They are related by
<p align="center">
                                                            𝑓 = 9/5 × 𝑐 + 32
</p>
The conversion involves multiplication and division operations and direct implementation requires a significant amount of hardware resource. For a simple application, such as a digital thermometer, we can create a lookup table for conversion and store it in a ROM.
Consider a conversio circuit with following specification:
- The range is between 0°C and 100°C (32°F and 212°F).
- The input and output are in 8-bit unsigned format.
- A separate format signal indicates whether the input is in Celsius or Fahrenheit scale. The output is to be converted to the other scale.

We can create two lookup tables for the two conversions. Note that because of the small size of these tables, it is possible to store the two tables in a single BRAM module. Design the circuit and verify its operation.

*Notes:*
- Your FPGA implementation should show the input and output temperatures on the
seven-segment display
- If you input a number out of range (i.e., 5°F) the output should display 0
- Your implementation must use BRAM and the usage must not exceed 1 BRAM. (Technically, you can implement the whole system using 0.5 BRAM but 1 BRAM is acceptable)
- You should only use 1 ROM memory module (i.e., instantiate it as many times as you need but there is only one version). You can use my ROM code and modify it so the mem file name is parameterized)

**BRAM utilization:**
![image](https://github.com/user-attachments/assets/d5ae487c-76b5-4185-9820-1001530606b7)
