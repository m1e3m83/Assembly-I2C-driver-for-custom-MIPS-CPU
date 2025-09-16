# I2C Driver Implementation in MIPS Assembly

## Overview

This project focuses on implementing an **I2C (Inter-Integrated Circuit) protocol bus** and its **driver** entirely in **MIPS assembly language**.

The I2C driver allows communication between multiple devices over just two wires—**SCL (clock line)** and **SDA (data line)**—and is implemented using memory-mapped I/O without any additional hardware controller logic.

## Key Features

- **Supports both Master and Slave roles** (Master implemented, Slave with address decoding).
- **Scalable design** for adding additional slaves (or masters if need be) by just designing and implementing the target devices IO I2C controller.
- **Memory-mapped I/O** access for SCL and SDA lines.
- **Custom communication functions**: `send_data` and `receive_data` for transferring null-terminated strings via the I2C bus. `send_data_byte` for sending of a single data byte.
- **FSM logic** at slave implementations for ACK/NACK handling and start/stop condition generation.
- Designed to work in a simulated environment (e.g., Logisim with ROM).
- Developed a self-sustaining **boot-level** MIPS assembly software capable of utlizing standard input and output IO devices and a minimal command-line interface. 
## Technical Details


- **SDA and SCL Lines**: Controlled indirectly using specific bits in memory-mapped registers.
- **ACK/NACK Handling**: Implemented through polling and bit manipulation.
- **Clock stretching and readiness checks** are not universally implemented devices due to simplified architecture.
- **Addressing**: 7-bit slave addressing is used, following I2C standards.

## File Structure

- `driver.asm` – Main MIPS assembly file containing the I2C driver logic.
- `main.asm` – Test and demonstration of sending and receiving data using the driver.
- `inst` – hex instructions to be loaded into ROM for Logisim simulation.
- `cpu.circ` – logisim implementation of the entire cpu along with the I2C bus and I2C slave devices. 
- `README.md` – Project description and instructions.

## How to Run

1. Load the provided ROM content into a **Logisim** circuit or your MIPS simulator.
2. Ensure SDA and SCL lines are connected to the appropriate memory-mapped bits.
3. Execute the simulation.
4. Enter any desired command inside keyboard module and wait for it to execute.

## Contributors

- Mohammad Esmaeil Marandi
- Mobin Ravan Nakhjavani
- Alireza Sarbaz
- Fatemeh Shafi'i

## Notes

- The implementation was completed as the projectof the *Computer Architecture* course at Sharif University of Technology.
- The driver uses **software-only techniques** on master (CPU) side to emulate I2C timing and logic. the slave side uses a solely hardware implementation to coordinate with the I2C master. A hardware implemention at the cpu side could result in a bus speed improvement but would add greatly to the circuit complexity.

## License

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT).


