# Signed Dadda Multiplier (Baugh–Wooley Architecture)

## Overview
This project implements a **signed Dadda multiplier** using the **Baugh–Wooley algorithm**, written in **structural Verilog HDL**.  
The design efficiently handles signed multiplication by transforming negative partial products into a form suitable for tree-based reduction.

Functional correctness has been verified using a dedicated testbench, and simulation results were analyzed using **GTKWave**.

---

## Key Highlights
- Signed 2’s complement multiplication
- Baugh–Wooley partial product generation
- Dadda tree reduction for fast accumulation
- Structural Verilog implementation
- Verified through waveform-based simulation

---

## Architecture
### Design Flow
1. **Partial Product Generation**
   - Baugh–Wooley technique applied for signed operands
2. **Partial Product Reduction**
   - Dadda reduction tree using half and full adders
3. **Final Addition**
   - Carry-propagate adder for final result

> The design emphasizes speed and regular structure, making it suitable for high-performance arithmetic units.
