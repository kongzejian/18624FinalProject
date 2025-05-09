# Target executable
TARGET = simv

# Source files
SRC = chip_low_fre.sv TB.sv
SRC += $(wildcard *.sv)
SRC := $(sort $(SRC)) # Removes duplicates

# Set the number of threads to use for parallel compilation (2 * cores)
CORES = $(shell getconf _NPROCESSORS_ONLN)
THREADS = $(shell echo $$((2 * $(CORES))))

# VCS flags
VCSFLAGS = -full64 -sverilog -debug_all +lint=all +warn=all -j$(THREADS) +v2k
COMMON_FLAGS +=

# Simulator
SIM = vcs

# Altera FPGA library files (for simulation)
INC_V =
INC_V_FLAGS = $(addprefix -v , $(INC_V))
INC_SV =
INC_SV_FLAGS = $(addprefix -v , $(INC_SV))

# Copy common flags
VCSFLAGS += $(COMMON_FLAGS)

default : full

full : $(SRC)
	$(SIM) $(VCSFLAGS) $(INC_V_FLAGS) $(INC_SV_FLAGS) -o $(TARGET) $(SRC)

clean:
	-rm -rf csrc
	-rm -rf DVEfiles
	-rm -f $(TARGET)
	-rm -rf $(TARGET).daidir
	-rm -rf ucli.key
	-rm -rf inter.vpd

.PHONY : default full clean