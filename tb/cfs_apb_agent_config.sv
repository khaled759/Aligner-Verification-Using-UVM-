`ifndef CFS_APB_AGENT_CONFIG_SV
    `define CFS_APB_AGENT_CONFIG_SV

    class cfs_apb_agent_config extends uvm_component;

        // local interface 
        local cfs_apb_vif vif;

        `uvm_component_utils(cfs_apb_agent_config)

        function new(string name = "", uvm_component parent);
            super.new(name, parent);
        endfunction 

        // getter function
        virtual function cfs_apb_vif get_vif();
            return vif;
        endfunction

        //setter function 
        virtual function void set_vif(cfs_apb_vif value);
            if (vif == null) begin
                vif = value;
            end 
            else begin
                `uvm_fatal("ALGORITHM_ISSUE", "Trying to set the APB virtual interface more than once")
            end
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
    

    endclass

`endif