

VCOM_ARGS=-2008 -work work -suppress 1236
VSIM_ARGS=-msgmode both

# The order is important!
VHDL_FILES = \
        ../top/src/top.vhd\
        ../ssd_counter/ssd_cnt.vhd\
        ../top/src/pll.vhd\
        ../ssd_counter/cnt_unit.vhd\
        ../ssd_bin_to_dec/ssd_bin_to_dec.vhd

TB_FILES = \
	./tb_ssd_bin_to_dec.vhd

TIME_RESOLUTION = 1ps
TB = ssd_bin_to_dec_tb

# For the simulation time -all can also be selected. Questa then simulates until no more singal changes occour.
SIM_TIME = 5us
WAVE_FILE = scripts/wave.do 

compile: $(VHDL_FILES) $(TB_FILES)
	rm -f log
	vlib work | tee log
	for i in $(VHDL_FILES); do \
		vcom $(VCOM_ARGS) $$i | tee -a log;\
	done;
	for i in $(TB_FILES); do \
		vcom $(VCOM_ARGS) $$i | tee -a log;\
	done;
	@echo "--------------------------------------------------------------"
	@echo "--              Error and Warning Summary                   --"
	@echo "--------------------------------------------------------------"
	@cat log | grep 'Warning\|Error'
	@if [[ $$(grep "Error:" -m 1 log) ]]; then \
		echo "Compilation had errors!" \
		exit 1; \
	fi;

list_sources:
	@for i in $(VHDL_FILES) $(TB_FILES); do \
		echo $$i;\
	done;

sim_gui: compile
	vsim -do "vsim $(TB) -t $(TIME_RESOLUTION) $(VSIM_ARGS); do $(WAVE_FILE);run $(SIM_TIME)" 

sim_gui_cl: compile
	vsim -do "vsim $(TB) -t $(TIME_RESOLUTION) $(VSIM_ARGS); run $(SIM_TIME);quit"

clean:
	rm -f transcript
	rm -f vsim.wlf
	rm -f log
	rm -fr work

.PHONY: clean
.PHONY: compile
.PHONY: sim_fifo
.PHONY: sim_fifo_cl

