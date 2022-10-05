include make/helpers.mk
include make/neuralspot_config.mk
include make/neuralspot_toolchain.mk
include make/jlink.mk

BENCHMARK:=keyword_spotting
MLPERF:=1
MLDEBUG:=0
ENERGY_MODE:=0

ifeq ($(MLPERF),1)
DEFINES+= AM_MLPERF_PERFORMANCE_MODE
endif
DEFINES+= EE_CFG_ENERGY_MODE=$(ENERGY_MODE)

local_app_name := $(BENCHMARK)
sources := $(wildcard src/*.c)
sources += $(wildcard src/*.cc)
sources += $(wildcard src/*.cpp)
sources += $(wildcard src/*.s)

# MLPerf Specific Things
sources += $(wildcard src/am_utils/*.c)
sources += $(wildcard src/api/*.cc)
sources += $(wildcard src/benchmarks/$(BENCHMARK)/*.cc)
sources += $(wildcard src/benchmarks/$(BENCHMARK)/api/*.cc)
sources += $(wildcard src/benchmarks/$(BENCHMARK)/model/*.cc)
sources += $(wildcard src/benchmarks/$(BENCHMARK)/ic/*.cc)
ifeq ($(BENCHMARK),person_detection)
sources += $(wildcard src/training/visual_wake_words/trained_models/vww/*.cc)
endif

VPATH+=$(dir $(sources))

targets  := $(BINDIR)/$(local_app_name).axf
targets  += $(BINDIR)/$(local_app_name).bin
mains    += $(BINDIR)/$(local_app_name).o

objs      = $(call source-to-object2,$(sources))
objects   = $(objs:%=$(BINDIR)/%)
dependencies = $(subst .o,.d,$(objects))

ifeq ($(TF_VERSION),b04cd98)
	INCLUDES += extern/AmbiqSuite/R4.3.0/boards/apollo4p_evb/bsp extern/AmbiqSuite/R4.3.0/CMSIS/ARM/Include extern/AmbiqSuite/R4.3.0/CMSIS/AmbiqMicro/Include extern/AmbiqSuite/R4.3.0/devices extern/AmbiqSuite/R4.1.0/mcu/apollo4p extern/AmbiqSuite/R4.1.0/mcu/apollo4p/hal/mcu extern/AmbiqSuite/R4.1.0/utils  extern/tensorflow/b04cd98/. extern/tensorflow/b04cd98/third_party extern/tensorflow/b04cd98/tensorflow/lite/micro/tools/make/downloads/flatbuffers/include neuralspot/ns-harness/includes-api neuralspot/ns-peripherals/includes-api
	libraries += libs/ambiqsuite.a libs/ns-peripherals.a libs/libam_hal.a libs/libam_bsp.a libs/libtensorflow-microlite-optimizednew.a
else
	INCLUDES += extern/AmbiqSuite/R4.1.0/boards/apollo4p_blue_evb/bsp extern/AmbiqSuite/R4.1.0/CMSIS/ARM/Include extern/AmbiqSuite/R4.1.0/CMSIS/AmbiqMicro/Include extern/AmbiqSuite/R4.1.0/devices extern/AmbiqSuite/R4.1.0/mcu/apollo4p extern/AmbiqSuite/R4.1.0/mcu/apollo4p/hal/mcu extern/AmbiqSuite/R4.1.0/utils  extern/tensorflow/R2.3.1/tensorflow extern/tensorflow/R2.3.1/third_party extern/tensorflow/R2.3.1/third_party/flatbuffers/include neuralspot/ns-harness/includes-api neuralspot/ns-peripherals/includes-api
	libraries += libs/ambiqsuite.a libs/ns-peripherals.a libs/libam_hal.a libs/libam_bsp.a libs/libtensorflow-microlite-oldopt.a
endif

# MLPerf Model Specific Stuff
# Benchmark includes
LOCAL_INCLUDES=  src
LOCAL_INCLUDES+= src/util
LOCAL_INCLUDES+= src/am_utils
LOCAL_INCLUDES+= src/api
LOCAL_INCLUDES+= src/benchmarks/$(BENCHMARK)/api
LOCAL_INCLUDES+= src/benchmarks/$(BENCHMARK)/model
ifeq ($(BENCHMARK),image_classification)
LOCAL_INCLUDES+= src/benchmarks/$(BENCHMARK)/ic
endif
# Person-detect includes, paths, and sources
ifeq ($(BENCHMARK),person_detection)
LOCAL_INCLUDES+= src/training/visual_wake_words/trained_models
LOCAL_INCLUDES+= src/training/visual_wake_words/trained_models/vww
endif

CFLAGS     += $(addprefix -D,$(DEFINES))
CFLAGS     += $(addprefix -I includes/,$(INCLUDES))
CFLAGS     += $(addprefix -I , $(LOCAL_INCLUDES))
LINKER_FILE := libs/linker_script.ld

all: $(BINDIR) $(objects) $(targets)

.PHONY: clean
clean:
ifeq ($(OS),Windows_NT)
	@echo "Windows_NT"
	@echo $(Q) $(RM) -rf $(BINDIR)/*
	$(Q) $(RM) -rf $(BINDIR)/*
else
	$(Q) $(RM) -rf $(BINDIR) $(JLINK_CF)
endif

ifneq "$(MAKECMDGOALS)" "clean"
  include $(dependencies)
endif

$(BINDIR):
	@mkdir -p $@

$(BINDIR)/%.o: %.cc
	@echo " ********CC Compiling $(COMPILERNAME) $< to make $@"
	@mkdir -p $(@D)
	$(Q) $(CC) -c $(CFLAGS) $(CCFLAGS) $< -o $@

$(BINDIR)/%.o: %.cpp $(BINDIR)/%.d
	@echo " ********CPP Compiling $(COMPILERNAME) $< to make $@"
	@mkdir -p $(@D)
	$(Q) $(CC) -c $(CFLAGS) $(CCFLAGS) $< -o $@

$(BINDIR)/%.o: %.c
	@echo " ********C Compiling $(COMPILERNAME) $< to make $@"
	@mkdir -p $(@D)
	$(Q) $(CC) -c $(CFLAGS) $(CONLY_FLAGS) $< -o $@

$(BINDIR)/%.o: %.s $(BINDIR)/%.d
	@echo " Assembling $(COMPILERNAME) $<"
	@mkdir -p $(@D)
	$(Q) $(CC) -c $(CFLAGS) $< -o $@


$(BINDIR)/$(local_app_name).axf: $(objects)
	@echo " Linking $(COMPILERNAME) $@"
	@mkdir -p $(@D)
	$(Q) $(CC) -Wl,-T,$(LINKER_FILE) -o $@ $(objects) $(LFLAGS)

$(BINDIR)/$(local_app_name).bin: $(BINDIR)/$(local_app_name).axf 
	@echo " Copying $(COMPILERNAME) $@..."
	@mkdir -p $(@D)
	$(Q) $(CP) $(CPFLAGS) $< $@
	$(Q) $(OD) $(ODFLAGS) $< > $*.lst
	$(Q) $(SIZE) $(objects) $(lib_prebuilt) $< > $*.size

$(JLINK_CF):
	@echo " Creating JLink command sequence input file..."
	$(Q) echo "ExitOnError 1" > $@
	$(Q) echo "Reset" >> $@
	$(Q) echo "LoadFile $(BINDIR)/$(TARGET).bin, $(JLINK_PF_ADDR)" >> $@
	$(Q) echo "Exit" >> $@

.PHONY: deploy
deploy: $(JLINK_CF)
	@echo " Deploying $< to device (ensure JLink USB connected and powered on)..."
	$(Q) $(JLINK) $(JLINK_CMD)

.PHONY: view
view:
	@echo " Printing SWO output (ensure JLink USB connected and powered on)..."
	$(Q) $(JLINK_SWO) $(JLINK_SWO_CMD)

%.d: ;
