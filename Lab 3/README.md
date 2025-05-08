# lab-3-early-debouncer-the-multiplexers

## Early Detection Debouncing Circuit Lab

This lab is based on section 5.5.2, covering the early detection debouncing scheme.

## Overview

We discussed early and delayed detection debouncing schemes in class, with the output timing diagram shown below. In this lab, we will be building the **early detection scheme**, where:
- When the input changes from `0` to `1`, the FSM responds immediately.
- The FSM then ignores the input for approximately 20 ms to avoid glitches.
- After this time, the FSM begins checking the input for the falling edge.

Follow the FSM design procedure to implement the early debouncing scheme.

### Tasks

1. **State Diagram and ASM Chart**
   - Derive the state diagram for the circuit.
   - Create the Algorithmic State Machine (ASM) chart.

2. **HDL Code Implementation**
   - Derive the HDL code based on the state diagram and/or ASM chart.

3. **Simulation and Testbench**
   - Create a testbench and use simulation to verify the operation of your code.

4. **Oscilloscope Verification**
   - Display the switch signal and the debounced signal on the oscilloscope.

5. **Optional Enhancement**: Edge Count Testing Circuit
   - The circuit diagram provided is an interesting way to test the debouncer. It counts the number of rising edges both with and without the debouncer and shows the count on a 7-segment display.
   - **Build this circuit** to enhance your debouncer testing if desired.

## Submission Requirements

Include the following items in your lab submission:

- **State Diagram**: Provide a diagram showing your FSM.
- **Video Demonstration**: Upload a short video (no more than 5 minutes) showing the functioning circuit.
  

**Diagram:**

<p align="center"> <img width="263" alt="p2" src="https://github.com/user-attachments/assets/57518a84-c988-46ab-92b6-fb9e989d26d5"> </p>

**ASM Chart:**

<p align="center"> <img width="269" alt="p1" src="https://github.com/user-attachments/assets/0f5df0ff-fd33-4d8b-9b21-7ea5dbf3ad79"> </p>

**Oscilloscope:**

<p align="center"> <img width="564" alt="image" src="https://github.com/user-attachments/assets/41364bd5-b758-4986-947a-45ddd4ce3789"> </p>
