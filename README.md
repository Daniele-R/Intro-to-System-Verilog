# lab-1-barrel-shifter-the-multiplexers

## Parametrized Multi-Function Barrel Shifter Lab

This lab is based on sections 3.12.1 and 3.12.2 from the textbook.

## Parameterized Barrel Shifter

The barrel shifter covered in the lecture accepts 8-bit input signals only. We want to construct a parameterized version, which accepts an input width specified by a parameter. To simplify the design, we assume:
- The width of an input is `2^N`
- `N` is used as the parameter

### Tasks

1. **Design a Parameterized Rotate-Right Barrel Shifter**
   - Derive the SystemVerilog code.
   - Call the module `param_right_shifter`.

2. **Design a Parameterized Rotate-Left Barrel Shifter**
   - Derive the SystemVerilog code.
   - Call the module `param_left_shifter`.

3. **Verification Through Testbench**
   - Write a testbench to verify the operation of both shifters.
   - You can test both shifters with a single testbench (i.e., instantiate both shifters to display both outputs together).

## Multi-Function Barrel Shifter

A multi-function barrel shifter can rotate right or rotate left based on the value of a 1-bit control signal `lr`.

### Tasks

1. **Design a Parameterized Multi-Function Barrel Shifter Using Mux**
   - Use one rotate-right circuit, one rotate-left circuit, and a 2-to-1 multiplexer to select the desired result.
   - Call the module `multi_barrel_shifter_mux`.

2. **Design a Multi-Function Shifter with Reversing Circuits**
   - Implement the shifter using one rotate-right circuit with pre-and post-reversing circuits.
   - A reversing circuit either passes the original input or reverses the input bitwise (e.g., for an 8-bit input `a7a6a5a4a3a2a1a0`, the reversed result becomes `a0a1a2a3a4a5a6a7`).
   - Call the module `multi_barrel_shifter_reverser`.

## FPGA Implementation

1. **Verify `multi_barrel_shifter_mux` Functionality**
   - Synthesize and program it on the FPGA board (Specify `N = 3`, use 8 switches to specify the input, and another switch for the control bit `lr`).
   - Check the report files and record the number of logic cells used and any other interesting metrics (e.g., propagation delays).

2. **Verify `multi_barrel_shifter_reverser` Functionality**
   - Repeat the verification process for `multi_barrel_shifter_reverser`.
   - Record the number of logic cells used.

3. **Video Demonstration**
   - Upload a short video (no more than 5 minutes) demonstrating a functioning circuit.
   - Include a link to the video in the `README.md` file.

4. **Document Logic Cell Usage**
   - Include the number of logic cells for both implementations in a table inside the `README.md`.

**Demo:**

![image](https://github.com/user-attachments/assets/6c821729-466e-4b00-93f2-d837311f9073)

![image](https://github.com/user-attachments/assets/652ddca3-f865-4d48-ad01-ab544aaf4a87)
![image](https://github.com/user-attachments/assets/549ec9d3-615e-4985-a893-97ea8eb4a5f4)

Thus, we used 24 LUT for both top files (multi_barrel_shifter_mux/reverser)
