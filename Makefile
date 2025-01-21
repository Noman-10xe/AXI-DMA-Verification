# Environment Variables
TESTS   = reset_test mm2s_enable_test s2mm_enable_test read_test raw_test boundary_test data_realignment_test read_introut_test write_introut_test rs_test soft_reset_test halted_write_test idle_state_test slave_error_test decode_error_test buffer_overflow_test
RTL     := rtl
TB      := verif
SIM     := sim
SHELL   := /bin/bash

# Simulation Options
SIM_OPT += +vcs+initreg+0 +UVM_VERBOSITY=UVM_MEDIUM

# Script Paths
SCRIPT_DIR := $(shell realpath ./rtl/axi_dma_verification_10xe_tcp/axi_dma_verification_10xe_tcp.sim/sim_1/behav/xsim)

# Output Directories
OUT_DIR := $(shell mkdir -p ./output && realpath ./output)
COMPILE_DIR := $(OUT_DIR)/compile
ELAB_DIR := $(OUT_DIR)/elaborate
SIM_DIR := $(OUT_DIR)/simulate
REGRESS_DIR := $(OUT_DIR)/regression

# Ensure directories exist
$(OUT_DIR) $(COMPILE_DIR) $(ELAB_DIR) $(SIM_DIR) $(REGRESS_DIR):
	@mkdir -p $@

# Main Targets
main: compile elaborate simulate

# Compilation Target
compile: $(COMPILE_DIR)
	@echo "Starting Compilation..."
	@cd $(SCRIPT_DIR) && ./compile.sh 2>&1 | tee $(COMPILE_DIR)/compile.log
	@echo "Compilation completed. Logs available in $(COMPILE_DIR)/compile.log."

# Elaboration Target
elaborate: $(ELAB_DIR)
	@echo "Starting Elaboration..."
	@cd $(SCRIPT_DIR) && ./elaborate.sh 2>&1 | tee $(ELAB_DIR)/elaborate.log
	@echo "Elaboration completed. Logs available in $(ELAB_DIR)/elaborate.log."

# Simulation Target
simulate: $(SIM_DIR)
	@echo "Starting Simulation..."
	@mkdir -p $(SIM_DIR)
	@cd $(SCRIPT_DIR) && ./simulate.sh $(SIM_OPT) 2>&1 | tee $(SIM_DIR)/simulate.log
	@cp $(SCRIPT_DIR)/dump.vcd $(SIM_DIR)/dump.vcd || echo "dump.vcd not found, skipping copy."
	@echo "Simulation completed. Logs available in $(SIM_DIR)/simulate.log."

# Regression Target
regress: $(REGRESS_DIR)
	@echo "Starting Regression..."
	@mkdir -p $(REGRESS_DIR)
	@for t in $(TESTS); do \
		echo "Running test: $$t"; \
		$(MAKE) simulate SIM_OPT="$(SIM_OPT) +UVM_TESTNAME=$$t"; \
		TEST_DIR=$(REGRESS_DIR)/$$t; \
		mkdir -p $$TEST_DIR; \
		mv $(SIM_DIR)/* $$TEST_DIR/; \
		echo "Logs and VCD for $$t saved in $$TEST_DIR."; \
	done
	@echo "Regression completed. Logs available in $(REGRESS_DIR)."

# Clean Target
clean:
	rm -rf $(OUT_DIR)

# Phony Targets
.PHONY: main compile elaborate simulate regress clean
