# Midterm 2

## HDL

For this we were tasked to utilzie the Pmod ToF, which uses the I2C communication protocol. In order to do so, we created the respective signals in these files:

``mmio_sys_sample.sv``
``mcs_top_sampler.sv``

where these were:
```verilog
input logic tof_i2c_irq,
output logic tof_i2c_ss,
output tri scl,
inout  tri sda,
```

and we added the signals on the slot10 for I2C as well, so it looks like this:
```verilog
    slot 4: ToF
    chu_gpi #(.W(N_SW)) user_slot4 
    (
     .clk(clk),
     .reset(reset),
     .cs(cs_array[`S4_USER]),
     .read(mem_rd_array[`S4_USER]),
     .write(mem_wr_array[`S4_USER]),
     .addr(reg_addr_array[`S4_USER]),
     .rd_data(rd_data_array[`S4_USER]),
     .wr_data(wr_data_array[`S4_USER]),
     .din(sw)
     .scl(tof_i2c_scl),
     .sda(tof_i2c_sda)
     .irq(tof_i2c_irq),
     .ss(tof_i2c_ss)
     );
```
## Constrain
```
The next modification in our HDL was in the constrain, where we enabled the JB ports
[...]
set_property -dict {PACKAGE_PIN D14 IOSTANDARD LVCMOS33} [get_ports {tof_i2c_irq}]
set_property -dict {PACKAGE_PIN F16 IOSTANDARD LVCMOS33} [get_ports {tof_i2c_ss}]
set_property -dict {PACKAGE_PIN G16 IOSTANDARD LVCMOS33} [get_ports {tof_i2c_scl}]
set_property -dict {PACKAGE_PIN H14 IOSTANDARD LVCMOS33} [get_ports {tof_i2c_sda}]
[...]
```
## Drivers
After that, last step was to create the application driver that will enable the Pmod and the reading of it --> ``main_sampler_test.cpp``

## Main
Before starting with the functions, we had to initialize the Pmod and to create a read_distance (from the Pmod) so we can operate the future functions.

In order to do so, we translated the work from a previous user featured in the diligent website
- https://github.com/Digilent/vivado-hierarchies/blob/master/PmodToF/sdk_sources/PmodToF/PmodToF.c

and the firmware document/manual
- https://www.renesas.com/en/document/apn/an1724-isl29501-firmware-routines

Once that done, we created functions to obtained what we were asked, to utilize the PWM RGB light and the 7segment display. 

- The Pmod will read the distance and display it in the 7segmnets like this --> (meters) (.) (dms) (cms) (mms)
- The Pmod will read the distance and display a spectrum of light like in lab 9 --> yellow to red/pruple

Other functions were created to predict the midterm's request, such as the LED chasing lights that will increase from right to left based on the distance read by the Pmod
Switch 0x02 (2nd switch from the right) utilizes a similar process for the PWM, but due to some funny interactions with the room, I went with 0x08 (3rd switch from the right)
