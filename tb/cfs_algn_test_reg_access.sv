`ifndef CFS_ALGN_TEST_REG_ACCESS_SV
  `define CFS_ALGN_TEST_REG_ACCESS_SV

  class cfs_algn_test_reg_access extends cfs_algn_test_base;

    `uvm_component_utils(cfs_algn_test_reg_access)
    
    function new(string name = "", uvm_component parent);
      super.new(name, parent);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this, "TEST_DONE");
        
        #(100ns);

        for(int i = 0; i < 10; i++) begin
            cfs_apb_item_drv item = cfs_apb_item_drv::type_id::create("item");

            if (item.randomize()) begin
                `uvm_info("DEBUG", $sformatf("[%0d] item: %0s", i, item.convert2string()), UVM_LOW)
            end
            else `uvm_fatal("RAND FAILED", "Transaction randomized failed")
        end
      
        `uvm_info("DEBUG", "this is the end of the test", UVM_LOW)
      
        phase.drop_objection(this, "TEST_DONE"); 
    endtask
    
  endclass

`endif