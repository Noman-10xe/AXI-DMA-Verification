# Environment Variables
TESTS   = test1 test2 test3 test4
RTL     := dut
TB      := tb
SIM     := sim
SHELL	:=/bin/bash

# Static Parts
INT_PKG += ./tb/top/intf.sv ../ISP_2dnr_Verif/tb/top/2dnr_intf.sv ../ISP_BLC_Verif/tb/top/blc_intf.sv

# Simulation Options
SIM_OPT += +vcs+initreg+0 +UVM_VERBOSITY=UVM_MEDIUM

# Script Paths
SCRIPT_DIR := $(shell realpath ./rtl/axi_dma_verification_10xe_tcp/axi_dma_verification_10xe_tcp.sim/sim_1/behav/xsim)

# Output Directories
OUT_DIR := $(shell mkdir -p ./output && realpath ./output)
COMPILE_DIR := $(shell mkdir -p $(OUT_DIR)/compile && realpath $(OUT_DIR)/compile)
ELAB_DIR := $(shell mkdir -p $(OUT_DIR)/elaborate && realpath $(OUT_DIR)/elaborate)
SIM_DIR := $(shell mkdir -p $(OUT_DIR)/simulate && realpath $(OUT_DIR)/simulate)
REGRESS_DIR := $(shell mkdir -p $(OUT_DIR)/regression && realpath $(OUT_DIR)/regression)

# Ensure directories exist
$(OUT_DIR):
	@echo "Creating output directory: $@"
	@mkdir -p $@

$(COMPILE_DIR): $(OUT_DIR)
	@echo "Creating compile directory: $@"
	@mkdir -p $@

$(ELAB_DIR): $(OUT_DIR)
	@echo "Creating elaborate directory: $@"
	@mkdir -p $@

$(SIM_DIR): $(OUT_DIR)
	@echo "Creating simulate directory: $@"
	@mkdir -p $@

$(REGRESS_DIR): $(OUT_DIR)
	@echo "Creating regression directory: $@"
	@mkdir -p $@

# Main Targets
main: compile elaborate simulate

# Compilation Target
compile: $(COMPILE_DIR)
	@echo "Absolute compile directory: $(COMPILE_DIR)"
	@echo "Script directory: $(SCRIPT_DIR)"
	@echo "Contents of compile directory before running script:"
	@ls -ld $(COMPILE_DIR)
	@echo "Starting compile.sh in $(SCRIPT_DIR)..."
	@cd $(SCRIPT_DIR) && ./compile.sh > $(COMPILE_DIR)/compile.log 2>&1 || { echo "Failed to execute compile.sh"; exit 1; }
	
# Elaboration Target
elaborate: $(ELAB_DIR)
	@cd $(SCRIPT_DIR) && ./elaborate.sh > $(ELAB_DIR)/elaborate.log 2>&1
	cat $(ELAB_DIR)/elaborate.log

# Simulation Target
simulate: $(SIM_DIR)
	@cd $(SCRIPT_DIR) && ./simulate.sh $(SIM_OPT) > $(SIM_DIR)/simulate.log 2>&1
	@cp $(SCRIPT_DIR)/dump.vcd $(SIM_DIR)/dump.vcd || echo "dump.vcd not found, skipping copy."
	cat $(SIM_DIR)/simulate.log

# Regression Target
regress: $(REGRESS_DIR)
	@mkdir -p $(REGRESS_DIR)
	@for t in $(TESTS); do \
		$(MAKE) simulate SIM_OPT="$(SIM_OPT) +UVM_TESTNAME=$$t"; \
		mv $(SIM_DIR)/* $(REGRESS_DIR)/$$t/; \
	done

# Clean Target
clean:
	rm -rf $(OUT_DIR)

# Phony Targets
.PHONY: main compile elaborate simulate regress clean

