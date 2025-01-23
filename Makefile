# Environment Variables
TESTS   = reset_test mm2s_enable_test s2mm_enable_test read_test raw_test boundary_test data_realignment_test read_introut_test write_introut_test rs_test soft_reset_test halted_write_test idle_state_test slave_error_test decode_error_test buffer_overflow_test random_reg_test random_stream_read_test random_tkeep_test
RTL     := rtl
TB      := verif
SIM     := sim
SHELL   := /bin/bash
TEST_NAME ?= reset_test
export TEST_NAME

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
	@mkdir -p $(SIM_DIR)/$(TEST_NAME)
	@echo "Running simulation for test: $(TEST_NAME)"
	@cd $(SCRIPT_DIR) && TEST_NAME=$(TEST_NAME) ./sim.sh -testplusarg UVM_TESTNAME=$(TEST_NAME) | tee $(SIM_DIR)/$(TEST_NAME)/simulate.log
	@cp $(SCRIPT_DIR)/dump.vcd $(SIM_DIR)/$(TEST_NAME)/dump.vcd || echo "dump.vcd not found for $(TEST_NAME), skipping copy."
	@cp -r $(SCRIPT_DIR)/xsim.covdb $(SIM_DIR)/$(TEST_NAME)/xsim.covdb || echo "xsim.covdb not found for $(TEST_NAME), skipping copy."
	@cp -r $(SCRIPT_DIR)/axi_dma_tb_top_behav.wdb $(SIM_DIR)/$(TEST_NAME) || echo "Waveform.wdb File not found for $(TEST_NAME), skipping copy."
	@cp -r $(SCRIPT_DIR)/xsim.dir $(SIM_DIR)/$(TEST_NAME)/ || echo "xsim.dir not found for $(TEST_NAME), skipping copy."
	@xcrg -report_format html -dir $(SIM_DIR)/$(TEST_NAME)/xsim.covdb -report_dir $(COVERAGE_DIR)/$(TEST_NAME)
	@echo "Simulation complete for test: $(TEST_NAME)"
	
# Regression Target
regress: $(REGRESS_DIR)
	@mkdir -p $(REGRESS_DIR)
	@echo "Starting regression..."
	@for t in $(TESTS); do \
		echo "Running test: $$t"; \
		$(MAKE) simulate TEST_NAME=$$t; \
		mkdir -p $(REGRESS_DIR)/$$t; \
		cp -r $(SIM_DIR)/$$t/* $(REGRESS_DIR)/$$t/; \
	done
	# Merge all individual coverage databases into a single merged report
	@echo "Merging coverage data..."
	xcrg -report_format html -dir $(REGRESS_DIR) -report_dir $(COVERAGE_DIR)/merged_report || echo "Error merging coverage data."
	@echo "Regression complete. Merged coverage report available in $(COVERAGE_DIR)/merged_report."


# Clean Target
clean:
	@echo "Cleaning simulation files..."
	@rm -rf $(OUT_DIR) $(COVERAGE_DIR) xcrg.log xsim.covdb

# Phony Targets
.PHONY: main compile elaborate simulate regress clean
