VFLAGS_DEP += -y. -I. -y$(DSP_DIR) -I$(DSP_DIR) -y$(CORDIC_DIR)
VFLAGS += -I. -y. -y$(DSP_DIR) -I$(DSP_DIR) -y$(CORDIC_DIR) -I$(AUTOGEN_DIR)

VVP_FLAGS += +trace

TEST_BENCH = beam_tb outer_prod_tb resonator_tb a_compress_tb cav_mode_tb cav_elec_tb

TGT_ := $(TEST_BENCH)

NO_CHECK =

#CHK_ = $(filter-out $(NO_CHECK), $(TEST_BENCH:%_tb=%_check))
CHK_ += a_comp_check resonator_check cav_mode_check

BITS_ :=

VFLAGS_cav_mode_tb += -DLB_DECODE_cav_mode
VFLAGS_cav_elec_tb = -DLB_DECODE_cav_elec


%_s6.bit: %.v $(DEPDIR)/%.bit.d blank_s6.ucf
	PART=xc6slx45t-fgg484-3
	CLOCK_PIN=$(CLOCK_PIN) PART=$(PART) $(ISE_SYNTH) $* $(SYNTH_OPT) $^ && mv _xilinx/$@ $@

%_a7.bit: %.v $(DEPDIR)/%.bit.d blank_a7.ucf
	PART=xc7a100t-fgg484-2
	CLOCK_PIN=$(CLOCK_PIN) PART=$(PART) $(ISE_SYNTH) $* $(SYNTH_OPT) $^ && mv _xilinx/$@ $@

cordicg_b22.v: $(CORDIC_DIR)/cordicgx.py
	$(PYTHON) $< 22 > cordicg_b22.v

cav_mode_tb: cordicg_b22.v

a_comp_check: a_compress.py a_compress.dat
	$(PYTHON) a_compress.py -c

resonator_check: resonator_tb resonator_check.m resonator.dat
	$(OCTAVE) resonator_check.m resonator.dat

cav_mode_check: cav_check1.m cav_mode.dat
	$(OCTAVE) $<

LB_AW = 14 # Set the Local Bus Address Width for test benches

CLEAN += $(TGT_) $(CHK_) *.bit *.in *.vcd *.dat cordicg_b22.v

CLEAN_DIRS += _xilinx

.PHONY: targets checks bits check_all clean_all
targets: $(TGT_)
checks: $(CHK_)
check_all: $(CHK_)
bits: $(BITS_)
