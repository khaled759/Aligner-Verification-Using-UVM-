REPORTS := ./reports
UCDB := ./reports/cov.ucdb
COVTXT := ./reports/coverage.txt

TEST := cfs_algn_test_reg_access

all: coverage

rundofile: 
	vsim -c -do ./scripts/run.tcl

coverage: rundofile
	vcover report -details -output $(COVTXT) $(UCDB)

open_wave: rundofile
	vsim -view vsim.wlf -do .\scripts\cfs_apb_wave.tcl


