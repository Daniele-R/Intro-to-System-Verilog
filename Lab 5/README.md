# lab-5-asymmetric-fifo-buffer-the-multiplexers
## 7.7.3 FIFO with data width conversion

Context:
In some applications, the widths of the write port and read port of a FIFO buffer may not be the
same. For example, a subsystem may write 16-bit data into the FIFO buffer and another
subsystem only reads and removes 8-bit data at a time. Such FIFO buffers are called asymmetric
buffers. Assume that the width of the write port is twice the width of the read port. Redesign the
FIFO with a modified controller and register file and verify its operation.
The DATA_WIDTH generic parameter should be the width of the read port and should be used as
the DATA_WIDTH of the register file.

**DEMO:**

<img width="924" alt="image" src="https://github.com/user-attachments/assets/1b15e6f8-26f4-4a34-ae97-ab9f8df2d6cd">
