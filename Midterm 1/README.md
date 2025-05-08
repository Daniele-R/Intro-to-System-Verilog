*Replicate the project's functionality (as shown in the class) by writing SystemVerilog code in mem_block.sv*

Technical Specifications:
- Create a new Vivado project and import these SystemVerilog files (and the constraint file)
- The module in mem_block.sv is supposed to implement a 4096x4 memory array; however, you are only allowed to use arrays of size 1024x4 to build the module.
- Your implementation must utilize 2 BRAM modules.
- You can write (or import) other modules; however, the mem_block.sv input/output interface should not be changed.
- To get credit for the exam, your submission must include:
- A Block Diagram and/or a State Diagram
- A working demo

General Guidelines:
- The deadline to submit all deliverables is on  Mon 9/30/2024 @ 1:30 PM 
- The midterm exam is an individual assignment and you should finish it on your own. No group work is allowed.
- The solution will be much easier if you start by designing the system then implementing it.
- You should only use SystemVerilog Code.
- If you use code snippets you found online, you need to reference the source.

Deliverables:
- Schematic/Block diagram and/or State Diagram of the memory block system. You do not need to show the details of the top-level system (i.e. no need to show the diagram of the top-level system I designed, which includes the time-multiplexed display).
- All SystemVerilog Code generated
- All testbenches generated (if any) along with their output timing diagrams 
- All deliverables should be submitted in GitHub
- A working demo should be shown in person

Added files:

- decoder_param.sv         (previous lab implementation)
- mux_4x1_nbits.sv         (proff's GitHub)
- bram_synch_one_port.sv   (proff's GitHub)
- mem_block.sv             (structure by proff, module connections by me)

Schematic:
![WhatsApp Image 2024-09-30 at 1 33 59 PM](https://github.com/user-attachments/assets/78094557-8f8f-4177-958b-561c4cfc734c)


BRAM utilization:
<img width="942" alt="image" src="https://github.com/user-attachments/assets/7ef6ba6d-3c4a-47c7-9bb8-2b29f27770c0">

