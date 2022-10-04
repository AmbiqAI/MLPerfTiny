
##### Toolchain Defaults #####
TOOLCHAIN ?= arm-none-eabi
COMPILERNAME := gcc
BINDIR := build
SHELL  :=/bin/bash

##### Target Hardware Defaults #####
BOARD  :=apollo4p
EVB    :=evb
PART   = $(BOARD)
CPU    = cortex-m4
FPU    = fpv4-sp-d16
FABI     = hard

##### Extern Library Defaults #####
AS_VERSION := R4.3.0
TF_VERSION := b04cd98

##### Application Defaults #####
# default target for binary-specific operations such as 'deploy' 
TARGET      := main

##### Common AI Precompiler Directives #####
MLDEBUG     := 0    # 1 = load TF library with debug info, turn on TF debug statements
ENERGY_MODE := 0    # 1 = enable energy measurements via UART1