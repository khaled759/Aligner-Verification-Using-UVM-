REPORTS := ./reports
UCDB := ./reports/cov.ucdb
COVTXT := ./reports/coverage.txt

TEST := cfs_algn_test_reg_access

all: rundofile coverage  

rundofile: 
	vsim -c -do ./scripts/run.tcl

coverage: 
	vcover report -details -output $(COVTXT) $(UCDB)

open_wave: 
	vsim -view vsim.wlf -do .\scripts\cfs_apb_wave.tcl


