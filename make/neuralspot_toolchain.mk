# Makefile include for common toolchain definitions

# Enable printing explicit commands with 'make VERBOSE=1'
ifneq ($(VERBOSE),1)
Q:=@
endif

.PRECIOUS: %.o

#### Required Executables ####
CC = $(TOOLCHAIN)-gcc
GCC = $(TOOLCHAIN)-gcc
CPP = $(TOOLCHAIN)-cpp
LD = $(TOOLCHAIN)-ld
CP = $(TOOLCHAIN)-objcopy
OD = $(TOOLCHAIN)-objdump
RD = $(TOOLCHAIN)-readelf
AR = $(TOOLCHAIN)-ar
SIZE = $(TOOLCHAIN)-size
RM = $(shell which rm 2>/dev/null)
DOX = doxygen


CFLAGS+= -mthumb -mcpu=$(CPU) -mfpu=$(FPU) -mfloat-abi=$(FABI)
CFLAGS+= -ffunction-sections -fdata-sections -fomit-frame-pointer -fno-exceptions
CCFLAGS+= -fno-use-cxa-atexit
CFLAGS+= -MMD -MP -Wall
CONLY_FLAGS+= -std=c99 
CFLAGS+= -g -O3
#CFLAGS+= -g -O0
CFLAGS+= 

LFLAGS = -mthumb -mcpu=$(CPU) -mfpu=$(FPU) -mfloat-abi=$(FABI)
LFLAGS+= -nostartfiles -static -lstdc++ -fno-exceptions
LFLAGS+= -Wl,--gc-sections,--entry,Reset_Handler,-Map,$(BINDIR)/output.map
LFLAGS+= -Wl,--start-group -lm -lc -lgcc -lnosys $(libraries) $(lib_prebuilt) -Wl,--end-group
LFLAGS+=

CPFLAGS = -Obinary
ODFLAGS = -S

$(info Building for $(PART)_$(EVB))
DEFINES+= PART_$(PART)
ifeq ($(PART),apollo4b)
DEFINES+= AM_PART_APOLLO4B
endif
ifeq ($(PART),apollo4p)
DEFINES+= AM_PART_APOLLO4P
endif
DEFINES+= AM_PACKAGE_BGA
DEFINES+= __FPU_PRESENT
DEFINES+= gcc
DEFINES+= TF_LITE_STATIC_MEMORY
# Enable ML Debug and Symbols with 'make MLDEBUG=1'
ifneq ($(MLDEBUG),1)
DEFINES+= TF_LITE_STRIP_ERROR_STRINGS
endif