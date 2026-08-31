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

        fork
          
          begin
            cfs_apb_sequence_simple seq_simple = cfs_apb_sequence_simple::type_id::create("seq_simple"); 
            void'(seq_simple.randomize() with {item.addr == 'h222;});

            // triger the body of the sequence and assign it to a sequencer
            seq_simple.start(env.apb_agent.sequencer);
          end

          // read write sequence
          begin
            cfs_apb_sequence_rw seq_rw = cfs_apb_sequence_rw::type_id::create("seq_rw"); 
            void'(seq_rw.randomize() with {
              addr == 'h4;
              });

            // triger the body of the sequence and assign it to a sequencer
            seq_rw.start(env.apb_agent.sequencer);
          end

          // random sequence sends random number of items
          begin
            cfs_apb_sequence_random seq_random = cfs_apb_sequence_random::type_id::create("seq_random"); 
            void'(seq_random.randomize() with {
              num_items == 3;
              });
            // triger the body of the sequence and assign it to a sequencer
            seq_random.start(env.apb_agent.sequencer);
          end

        join

        `uvm_info("DEBUG", "this is the end of the test", UVM_LOW)
      
        phase.drop_objection(this, "TEST_DONE"); 
    endtask
    
  endclass

`endif