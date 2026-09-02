`ifndef CFS_APB_AGENT_CONFIG_SV
    `define CFS_APB_AGENT_CONFIG_SV

    class cfs_apb_agent_config extends uvm_component;

        // local interface 
        local cfs_apb_vif vif;
        // var to determine if the agent is active or passive
        local uvm_active_passive_enum active_passive;

        // to enable the protocol checks
        bit has_checks; 
        
        //Number of clock cycles after which an APB transfer is considered
        //stuck and an error is triggered
        local int unsigned stuck_threshold;


        `uvm_component_utils(cfs_apb_agent_config)

        function new(string name = "", uvm_component parent);
            super.new(name, parent);
            active_passive = UVM_ACTIVE;
            has_checks = 1;
            stuck_threshold = 1000;
        endfunction 

        // interface getter function
        virtual function cfs_apb_vif get_vif();
            return vif;
        endfunction

        //interface setter function 
        virtual function void set_vif(cfs_apb_vif value);
            if (vif == null) begin
                vif = value;
                set_has_checks(get_has_checks());
            end 
            else begin
                `uvm_fatal("ALGORITHM_ISSUE", "Trying to set the APB virtual interface more than once")
            end
        endfunction


        // active passive getter function
        virtual function uvm_active_passive_enum get_active_passive();
            return active_passive;
        endfunction

        // active passive setter function 
        virtual function void set_active_passive(uvm_active_passive_enum value);
            active_passive = value;
        endfunction

        virtual function void set_has_checks(bit value);
            has_checks = value;

            if (vif != null) begin
                vif.has_checks = has_checks;
            end
        endfunction

        virtual function bit get_has_checks();
            return has_checks;
        endfunction

        
        virtual function int unsigned get_stuck_threshold();
            return stuck_threshold;
        endfunction

         
        virtual function void set_stuck_threshold(int unsigned value);
            if (value <= 2) begin
                `uvm_error("ALGORITHEM ISSUE", $sformatf("can not set stuck threshold to value %0d min APB transfer if 2", value))
            end
            stuck_threshold = value;
        endfunction

        virtual function void start_of_simulation_phase(uvm_phase phase);
            super.start_of_simulation_phase(phase);
        
            if(get_vif() == null) begin
                `uvm_fatal("ALGORITHM_ISSUE", "The APB virtual interface is not configured at \"Start of simulation\" phase")
            end
            else begin
                `uvm_info("APB_CONFIG", "The APB virtual interface is configured at \"Start of simulation\" phase", UVM_DEBUG)
            end
        endfunction

        virtual task run_phase(uvm_phase phase);
            forever begin
                // detect a change 
                @(vif.has_checks);
                // this code rule is to prevent any updates for has checks from the interface
                // it must be done using the setter function of the has_check attribute
                if (vif.has_checks != get_has_checks()) begin
                    `uvm_error("ALGORITHM ISSUE", $sformatf("Can not change \"has_checks\" from APB interface - use
                    %0s_set_has_checks", get_full_name()))
                end
            end
        endtask

    endclass

`endif