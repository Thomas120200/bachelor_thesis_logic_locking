

PROJECT_NAME=top

LOG_FILE=BUILD_$(shell date '+%d.%m.%y-%H_%M_%S').log
PROJECT_DIR=$(shell pwd)
OUTPUT_DIR=$(PROJECT_DIR)/$(PROJECT_NAME)
SOF_FILE=output_files/$(PROJECT_NAME).sof

all: 


# starts the quartus GUI and loads the quartus project
quartus_gui:
	quartus --64bit $(PROJECT_NAME).qpf &


quartus: $(PROJECT_NAME).qsf $(PROJECT_NAME).qpf 
	@echo ""
	@echo "---------------------------------------------" >> $(LOG_FILE)
	@echo "-                  QUARTUS                  -" >> $(LOG_FILE)
	@echo "---------------------------------------------" >> $(LOG_FILE)
	quartus_sh --flow compile $(PROJECT_NAME) 2>&1 | tee -a $(LOG_FILE)
	@echo "---------------------------------------------" 
	@echo "--      Errors and Warnings Overview        -"
	@echo "--    (for more details see build log)      -"
	@echo "---------------------------------------------"
	@cat $(LOG_FILE)  | grep -e "^Warning [\(][0-9]*[\)]:" || true
	@cat $(LOG_FILE)  | grep -e "^Critical Warning [\(][0-9]*[\)]:" || true
	@cat $(LOG_FILE)  | grep -e "^Error [\(][0-9]*[\)]:" || true
	
download:
	quartus_pgm -m jtag -o"p;$(SOF_FILE)"

clean:
	rm -f $(PROJECT_NAME).sopcinfo
	rm -f $(PROJECT_NAME).html
	rm -f $(PROJECT_NAME).cmp
	rm -f *.rpt
	rm -f *.qws
	rm -fr $(OUTPUT_DIR)
	rm -fr output_files
	rm -fr db
	rm -f *.bsf
	rm -f *.dpf
	rm -f *.srf
	rm -fr incremental_db
	rm -f *.jdi
	rm -f *.html
	rm -f *.smsg
	rm -f *.summary
	rm -f *.qdf
	rm -fr greybox_tmp
	rm -fr simulation
	rm -f *.sof *.done
	rm -f *.pin
	rm -f *.sld
	

.PHONY: quartus
.PHONY: quartus_gui
.PHONY: download
.PHONY: clean

