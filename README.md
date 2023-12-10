# Verilog-Pong-Project
Verilog Pong Group Project for Class

Verilator run command:
``verilator -cc -O3 --x-assign fast --x-initial fast --noassert pong_top.v && cd obj_dir && make OPT_FAST="-O1 -fstrict-aliasing -march=native" -f Vpong_top.mk Vpong_top__ALL.a && cd ..``