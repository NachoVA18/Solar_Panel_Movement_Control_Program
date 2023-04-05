#Solar Panel Movement Control Program
This is a single-file assembly program written in RISC-V for the "Computer Architecture and Design" course. The program controls the movement of a solar panel to capture the maximum amount of light as the sun moves across the sky in the simulator.

##Requirements
To run this program, you will need:

A RISC-V simulator, such as Spike or QEMU
A RISC-V assembler, such as GNU Assembler (GAS) or RISC-V Toolchain
A basic understanding of RISC-V assembly language and computer architecture

##Usage
Clone or download this repository to your local machine.
Assemble the program using your chosen assembler. For example, using GAS:
typescript
Copy code
$ riscv64-unknown-elf-as -march=rv32i -o solar_panel.o solar_panel.s
Link the program to create an executable file. For example, using GCC:
ruby
Copy code
$ riscv64-unknown-elf-gcc -march=rv32i -o solar_panel solar_panel.o
Run the program in your chosen RISC-V simulator. For example, using Spike:
ruby
Copy code
$ spike pk solar_panel
Follow the instructions in the program to control the movement of the solar panel.

##License
This program is licensed under the MIT License. You are free to use, modify, and distribute the code as you see fit. Please see the LICENSE file for more information.

##Contributing
If you find a bug or would like to contribute to this project, please feel free to submit a pull request. We welcome contributions from the community and are happy to work with you to make this project even better.

##Contact
If you have any questions or comments about this project, please feel free to contact us at our email address: [email protected]
