# ALU Verilog Implementation

## Faaltu ki cheezien
Hello, if you are reading this, massive respect to the dedication. I am Harsh (duh), and this is the submission for assignment 1 of IPA course. Hehe, fun fact this entire thing was made in 30 minutes by a coffee high version of me, at 2 am in the morning, so if any errors made or any inappropriate comments are found please ignore. So buckle up ladies and gents, because in short 3 files and some 400 lines I am going to implement a thing or two that I leanred myself about 2 hours ago. So sit down, shut up, and enjoy my 2 am coffee induced, self hatred fueled extravagaza.

## Overview
This repository contains the Verilog implementation of a 64-bit Arithmetic Logic Unit (ALU) along with its testbench. The ALU supports arithmetic and logical operations based on input function select signals (`funct3` and `funct7`). The inputs are based on the registers (`rs1` and `rs2`) and same for output (`rd`).

## File Descriptions

### 1. `alu.v`
This file contains the Verilog implementation of the ALU and its supporting modules:

#### **FULL_ADDER**
A single-bit full adder module used to construct larger arithmetic circuits.
- **Inputs:**
  - `a`: First operand bit
  - `b`: Second operand bit
  - `cin`: Carry-in bit
- **Outputs:**
  - `sum`: Sum output
  - `cout`: Carry-out bit

#### **ADD_64**
A 64-bit adder that adds two 64-bit numbers using an array of `FULL_ADDER` modules.
- **Inputs:**
  - `A`: 64-bit first operand
  - `B`: 64-bit second operand
- **Outputs:**
  - `Sum`: 64-bit result
  - `Cout`: Carry-out bit

#### **SUB_64**
A 64-bit subtractor that computes the difference using two’s complement arithmetic.
- **Inputs:**
  - `A`: 64-bit first operand
  - `B`: 64-bit second operand
- **Outputs:**
  - `Diff`: 64-bit difference (2's complement)
  - `Cout`: Carry-out bit (borrow bit)

#### **AND_64**
A 64-bit and gate that computes the bitwise `AND` operation.
- **Inputs:**
  - `A`: 64-bit first operand
  - `B`: 64-bit second operand
- **Outputs:**
  - `Y`: 64-bit output of operation

#### **OR_64**
A 64-bit or gate that computes the bitwise `OR` operation.
- **Inputs:**
  - `A`: 64-bit first operand
  - `B`: 64-bit second operand
- **Outputs:**
  - `Y`: 64-bit output of operation

#### **XOR_64**
A 64-bit xor gate that computes the bitwise `XOR` operation.
- **Inputs:**
  - `A`: 64-bit first operand
  - `B`: 64-bit second operand
- **Outputs:**
  - `Y`: 64-bit output of operation


#### **ALU Module**
Implements various arithmetic and logical operations based on `funct3` and `funct7` values.
- **Inputs:**
  - `funct3`: 3-bit control signal for operation selection
  - `funct7`: 7-bit function modifier for arithmetic operations
  - `rs1`: First 64-bit operand
  - `rs2`: Second 64-bit operand
- **Output:**
  - `rd`: 64-bit result

Operations Implemented:
| Operation | `funct3` |  `funct7` |      Description       |
|-----------|----------|-----------|------------------------|
|    ADD    |  `000`   | `0000000` | Adds `rs1` and `rs2`   |
|    SUB    |  `000`   | `0100000` | Subs `rs2` from `rs1`  |
|    AND    |  `111`   | `0000000` | Bitwise AND            |
|    OR     |  `110`   | `0000000` | Bitwise OR             |
|    XOR    |  `100`   | `0000000` | Bitwise XOR            |
|    SLL    |  `001`   | `0000000` | Shift left logical     |
|    SRL    |  `101`   | `0000000` | Shift right logical    |
|    SRA    |  `101`   | `0100000` | Shift right arithmetic |

---

### 2. `alu_tb.v`
This is the testbench file for verifying ALU functionality.

- **Inputs:**
  - `funct3`, `funct7`: Control signals for ALU operation
  - `rs1`, `rs2`: Test input values
- **Output:**
  - `rd`: ALU computation result

#### **Test Cases:**
1. **Addition Test**
   - `funct3 = 000`, `funct7 = 0000000`
   - `rs1 = 1`, `rs2 = 2`
   - Expected Output: `rd = 3`

2. **Subtraction Test**
   - `funct3 = 000`, `funct7 = 0100000`
   - `rs1 = 5`, `rs2 = 3`
   - Expected Output: `rd = 2`

3. **Bitwise AND Test**
   - `funct3 = 111`
   - `rs1 = 0xF0F0F0F0F0F0F0F0`, `rs2 = 0x0F0F0F0F0F0F0F0F`
   - Expected Output: `rd = 0x0000000000000000`

4. **Bitwise OR Test**
   - `funct3 = 110`
   - `rs1 = 0xF0F0F0F0F0F0F0F0`, `rs2 = 0x0F0F0F0F0F0F0F0F`
   - Expected Output: `rd = 0xFFFFFFFFFFFFFFFF`

---

## Compilation and Simulation
To compile and run the testbench using Icarus Verilog:

```sh
# Compile the ALU and testbench
iverilog -o alu_ff alu.v alu_tb.v

# Run the simulation
vvp alu_ff

# View the waveform using GTKWave
gtkwave alu_ff.vcd
```

## Conclusion
This project demonstrates a functional ALU capable of performing arithmetic and logical operations. The testbench validates the implementation using various test cases. When I wrote this, only God and I understood what was written, now God only knows, so you'll have to go ask him for any and all explanantions. With this Harsh Kapoor signing off.