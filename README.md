# Computer-Organisation-Assignments-EE2003
EE2003: Computer Organisation
=============================

DISCLAIMER: These are only for reference and are to be used only for understanding/learning. These assignments should not be turned in as your own original work.

Tools
-----
* iverilog
* gtkwave
* rv32i toolchain
* yosys
* Xilinx Vivado 2020.1

The tools are not provided as part of this repository and are to be built from source for latest features, and for easy management of tools.

Setup
-----
This setup assumes that you like to keep your global .profile clean and would like to add project-specific ENV_VARS and tools you normally wouldn't use for any other purpose, to a separate file(directory) in the project. For this, direnv[4] is recommended. The .envrc present here assumes that you install the required tools in tools/ directory here.

DroneCI requires you to keep DRONE_TOKEN and DRONE_SERVER as ENV_VARS. Please add your DRONE_TOKEN credential to .envrc as:

    export DRONE_TOKEN=<insert token>

Assignments
-----------
a1 - Sequential multiplier using verilog
