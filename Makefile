# Environment Variables
TESTS   = reset_test mm2s_enable_test s2mm_enable_test read_test raw_test boundary_test data_realignment_test read_introut_test write_introut_test rs_test soft_reset_test halted_write_test idle_state_test slave_error_test decode_error_test buffer_overflow_test
RTL     := rtl
TB      := verif
SIM     := sim
SHELL   := /bin/bash
TEST_NAME ?=

# Script Paths
SCRIPT_DIR := $(shell realpath ./rtl/axi_dma_verification_10xe_tcp/axi_dma_verification_10xe_tcp.sim/sim_1/behav/xsim)

# Output Directories
OUT_DIR := $(shell mkdir -p ./output && realpath ./output)
COMPILE_DIR := $(OUT_DIR)/compile
ELAB_DIR := $(OUT_DIR)/elaborate
SIM_DIR := $(OUT_DIR)/simulate
REGRESS_DIR := $(OUT_DIR)/regression
LOG_DIR := $(OUT_DIR)/logs
COVERAGE_DIR := $(shell mkdir -p ./coverage && realpath ./coverage)

# Ensure directories exist
$(OUT_DIR) $(COMPILE_DIR) $(ELAB_DIR) $(SIM_DIR) $(REGRESS_DIR) $(LOG_DIR) $(COVERAGE_DIR):
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
	@if [ -z "$(TEST_NAME)" ]; then TEST_NAME=reset_test; fi
	@mkdir -p $(SIM_DIR)/$(TEST_NAME)
	@echo "Running simulation for test: $(TEST_NAME)"
	xsim axi_dma_tb_top_behav \
	    -key {Behavioral:sim_1:Functional:axi_dma_tb_top} \
	    -tclbatch axi_dma_tb_top.tcl \
	    -view /home/xe-user106/10x-Engineers/SOC-DV/TCP/axi_dma_verification/rtl/axi_dma_tb_top_behav.wcfg \
	    -log $(SIM_DIR)/$(TEST_NAME)/simulate.log \
	    -testplusarg UVM_TESTNAME=$(TEST_NAME)
	@cp $(SCRIPT_DIR)/dump.vcd $(SIM_DIR)/$(TEST_NAME)/dump.vcd || echo "dump.vcd not found for $(TEST_NAME), skipping copy."
	@xcrg -report_format html -dir $(SCRIPT_DIR)/xsim.covdb -report_dir $(COVERAGE_DIR)/$(TEST_NAME)
	@echo "Simulation complete for test: $(TEST_NAME)"

# Regression Target
regress: $(REGRESS_DIR)
	@mkdir -p $(REGRESS_DIR)
	@echo "Starting regression..."
	@for t in $(TESTS); do \
		echo "Running test: $$t"; \
		$(MAKE) simulate TEST_NAME=$$t; \
		mkdir -p $(REGRESS_DIR)/$$t; \
		mv $(SIM_DIR)/$$t/* $(REGRESS_DIR)/$$t/; \
		xcrg -report_format html -dir $(SCRIPT_DIR)/xsim.covdb -report_dir $(COVERAGE_DIR)/$$t; \
	done
	# Merge all coverage data into a single report
	@xcrg -merge_dir $(COVERAGE_DIR)/merged -report_format html -dir $(SCRIPT_DIR)/xsim.covdb
	@echo "Regression complete. Merged coverage report available in $(COVERAGE_DIR)/merged."

# Clean Target
clean:
	@echo "Cleaning simulation files but preserving logs and coverage..."
	@rm -rf $(OUT_DIR) $(COVERAGE_DIR) xcrg.log xsim.covdb
	@echo "Logs and coverage preserved in $(LOG_DIR) and $(COVERAGE_DIR)."

# Phony Targets
.PHONY: main compile elaborate simulate regress clean
