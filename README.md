# Verilog-Pong-Project
Verilog 2-Player Pong Group Project for Verilog Class
Pong, ascii, score, timer, debounce and vga modules authored by FPGADude found at:
https://github.com/FPGADude/Digital-Design/tree/main/FPGA%20Projects/VGA%20Projects/Pong%20pt2 

Modules modified by: Pokeyy, temoc024, morkeleb1, and Buyingbf

VGA Simulator supplied by: Buyingbf

Verilator run command:
``verilator -cc -O3 --x-assign fast --x-initial fast --noassert pong_top.v && cd obj_dir && make OPT_FAST="-O1 -fstrict-aliasing -march=native" -f Vpong_top.mk Vpong_top__ALL.a && cd ..``
