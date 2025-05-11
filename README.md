# Single-Cycle MIPS (SCI) Implementation

A Verilog-based, single-cycle CPU implementing a subset of the MIPS ISA. This repo includes all RTL modules, memory files, and a testbench for functional verification.

---
## Overview
This single-cycle MIPS core executes each instruction in one clock cycle, integrating:

- **PC**: Program Counter
- **IMEM**: Word-addressable instruction memory
- **RF**: 32×32 register file with 2 reads + 1 write per cycle
- **ALU**: Arithmetic and logic operations
- **DMEM**: Word-addressable data memory
- **CU**: Control unit decoding opcodes
- **SignExtend**: Immediate sign-extension

It supports the following instructions:

| Type   | Instruction | Description                              |
|--------|-------------|------------------------------------------|
| **R**  | `add`       | Add two registers                       |
|        | `sub`       | Subtract two registers                  |
|        | `and`       | Bitwise AND                             |
|        | `or`        | Bitwise OR                              |
|        | `slt`       | Set if less than                        |
|        | `srl`       | Logical shift right                     |
| **I**  | `lw`        | Load word                               |
|        | `sw`        | Store word                              |
|        | `beq`       | Branch if equal                         |
|        | `bne`       | Branch if not equal                     |
|        | `sltiu`     | Set if less than immediate (unsigned)   |
|        | `lhu`       | Load halfword unsigned                  |
| **J**  | `j`         | Jump                                    |
|        | `jal`       | Jump and link                           |

---

## Simulation

### Prerequisites
- Verilog simulator (Icarus, ModelSim, Vivado, etc.)