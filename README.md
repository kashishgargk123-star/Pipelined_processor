# 4-Stage Pipelined Processor

## Project Overview

This project is a basic 4-stage pipelined processor designed using Verilog HDL.

The purpose of this project is to understand how pipelining works inside a processor and how instructions can be processed in different stages simultaneously.

The processor supports three instructions:

- ADD
- SUB
- LOAD

The design was simulated using Icarus Verilog, and GTKWave was used to observe the internal signals and verify the working of the processor.

---

## Objective

The main objective of this project is to implement a simple processor using a four-stage pipeline.

Instead of completing one instruction completely before starting another, the processor divides instruction execution into four stages:

```text
IF → ID → EX → WB

Pipeline Structure
The processor contains the following four stages.
Stage 1 – Instruction Fetch (IF)
In this stage, the processor fetches an instruction from the instruction memory.
The Program Counter (PC) is used to select the instruction.
PC
 ↓
Instruction Memory
 ↓
Fetched Instruction
The fetched instruction is stored in the IF/ID pipeline register.
Stage 2 – Instruction Decode (ID)
The instruction fetched in the previous stage is decoded here.
The processor identifies:
- Opcode
- Destination register
- Source register 1
- Source register 2
- Immediate value
The required register values are also read during this stage.
The decoded information is then passed to the Execute stage.
Stage 3 – Execute (EX)
The required operation is performed in this stage.
For an ADD instruction:
R1 = R2 + R3
For a SUB instruction:
R4 = R5 - R6
For a LOAD instruction, the required memory location is accessed and the data is obtained.
The result is then passed to the Write Back stage.
Stage 4 – Write Back (WB)
The final result is written into the destination register in this stage.
For example, after executing:
ADD R1, R2, R3
the result is written into R1.
Pipeline Operation
The main advantage of pipelining is that several instructions can be processed at the same time.
For example:
             Cycle
             1    2    3    4    5    6

ADD          IF   ID   EX   WB
SUB               IF   ID   EX   WB
LOAD                   IF   ID   EX   WB
While the ADD instruction is being executed, the next instructions can already be fetched and decoded.
This improves the overall instruction throughput of the processor.
Instruction Set
The processor supports three basic instructions.
ADD
The ADD instruction adds two register values.
ADD R1, R2, R3
Operation:
R1 = R2 + R3
Test values:
R2 = 10
R3 = 20
Result:
R1 = 30
SUB
The SUB instruction subtracts one register value from another.
SUB R4, R5, R6
Operation:
R4 = R5 - R6
Test values:
R5 = 30
R6 = 10
Result:
R4 = 20
LOAD
The LOAD instruction reads a value from data memory.
For testing:
R7 = 4
Memory[4] = 100
Therefore, the LOAD instruction produces:
R0 = 100
Processor Architecture
The basic flow of the processor is:
             +-------------------+
             | Instruction       |
             | Memory            |
             +---------+---------+
                       |
                       v
                +-------------+
                |     IF      |
                | Fetch       |
                +------+------+ 
                       |
                   IF/ID
                       |
                       v
                +-------------+
                |     ID      |
                | Decode      |
                | Register    |
                | Read        |
                +------+------+ 
                       |
                   ID/EX
                       |
                       v
                +-------------+
                |     EX      |
                | Execute     |
                | / Memory    |
                +------+------+ 
                       |
                   EX/WB
                       |
                       v
                +-------------+
                |     WB      |
                | Write Back  |
                +------+------+
                       |
                       v
                 Register File
Instruction Format
A 16-bit instruction is used in this processor.
+---------+----------+----------+---------+---------+
| Opcode  |    RD    |   RS1    |   RS2   |   IMM   |
+---------+----------+----------+---------+---------+
  2 bits     3 bits     3 bits     3 bits    5 bits
The fields are:
Field	Description
Opcode	Defines the instruction type
RD	Destination register
RS1	First source register
RS2	Second source register
IMM	Immediate value


Hardware Details
The processor contains:
- 8 general-purpose registers
- 8-bit register width
- 16 instruction memory locations
- 16 data memory locations
- 16-bit instructions
- 4-bit Program Counter
- Four pipeline stages
Register File
The processor contains eight 8-bit registers:
R0 – R7
The registers are initialized with values required for testing the instructions.
Instruction Memory
Instruction memory stores the instructions that are executed by the processor.
The test program contains:
ADD
SUB
LOAD
Data Memory
Data memory is used by the LOAD instruction.
For testing:
Memory[4] = 100
Test Instructions
The following instructions are used during simulation:
ADD  R1, R2, R3
SUB  R4, R5, R6
LOAD R0, 0(R7)
Initial values:
R2 = 10
R3 = 20

R5 = 30
R6 = 10

R7 = 4

Memory[4] = 100
Expected results:
R1 = 30
R4 = 20
R0 = 100
Simulation
The design was simulated using Icarus Verilog.
The testbench provides:
- Clock signal
- Reset signal
- Simulation time
A VCD file is generated during simulation, which can be opened in GTKWave.
The simulation verifies that all three supported instructions produce the expected results.
Simulation Result
Instruction	Operation	Result
ADD	10 + 20	R1 = 30
SUB	30 - 10	R4 = 20
LOAD	Memory[4]	R0 = 100


The obtained results match the expected results.
Therefore, the basic functionality of the processor was successfully verified.
Waveform Analysis
The processor waveform was viewed using GTKWave.
Important signals observed during simulation include:
clk
reset
pc
if_instruction
id_opcode
id_data1
id_data2
ex_opcode
ex_rd
ex_result
wb_rd
wb_result
wb_valid
These signals help in understanding how an instruction moves from one pipeline stage to another.
The ex_result signal shows the results of the operations:
ADD  → 30
SUB  → 20
LOAD → 100
The Program Counter also increases as new instructions are fetched.

How to Simulate
1. Compile the Design
Open the terminal in the project folder and run:
iverilog -o processor_sim pipelined_processor.v tb_pipelined_processor.v
2. Run the Simulation
vvp processor_sim
The terminal should display results similar to:
====================================
      PIPELINED PROCESSOR RESULT
====================================
R0 = 100
R1 =  30
R4 =  20
====================================
3. View the Waveform
Run:
gtkwave processor.vcd
The generated waveform can then be used to observe the different pipeline stages.
Project Files
4-Stage-Pipelined-Processor/
│
├── pipelined_processor.v
├── tb_pipelined_processor.v
├── waveform.png
├── block_diagram.png
└── README.md
pipelined_processor.v
Contains the main RTL implementation of the processor.
tb_pipelined_processor.v
Contains the testbench used for simulation and verification.
waveform.png
Contains the GTKWave simulation result.
block_diagram.png
Contains the processor architecture diagram.
README.md
Contains the project documentation.
Tools Used
- Verilog HDL
- VS Code
- Icarus Verilog
- GTKWave
- GitHub
What I Learned
Working on this project helped me understand:
- How a processor executes instructions
- Basic pipelining concepts
- Four-stage pipeline architecture
- Instruction Fetch and Decode
- Execute and Write Back stages
- Pipeline registers
- Register files
- Instruction memory
- Data memory
- Basic ALU operations
- Verilog RTL design
- Testbench development
- Simulation using Icarus Verilog
- Waveform analysis using GTKWave
Conclusion
A simple 4-stage pipelined processor was successfully designed and simulated using Verilog HDL.
The processor was able to execute ADD, SUB, and LOAD instructions correctly. The simulation results matched the expected values, and the GTKWave waveform was used to verify the movement of instructions through the pipeline stages.
This project provided a practical understanding of processor pipelining and RTL design.
Internship Task
Task 3 – 4-Stage Pipelined Processor
Domain: VLSI / Digital Design
Author
Kashish Garg
B.Tech – Electronics and VLSI Engineering
