`include "cfs_algn_test_pkg.sv"

module testbench();
    import uvm_pkg::*;
    import cfs_algn_test_pkg::*;


    parameter CLK_PERIOD = 10;
    
    // clock generation
    reg clk;
    initial begin
        clk = 0;
        forever begin
            #(CLK_PERIOD/2);
            clk = ~clk;
        end
    end

    // initial reset generation
    reg reset_n;
    initial begin
        reset_n = 1;
        #6ns;
        reset_n = 0;
        #30ns
        reset_n = 1;
    end


    // Begin Our UVM test
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    
        run_test("");
    end


    // DUT instantiation
    cfs_aligner dut (
        .clk(clk),
        .reset_n(reset_n)

    );
endmodule