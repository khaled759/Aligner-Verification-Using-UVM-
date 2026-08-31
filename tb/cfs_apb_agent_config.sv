`ifndef CFS_APB_AGENT_CONFIG_SV
    `define CFS_APB_AGENT_CONFIG_SV

    class cfs_apb_agent_config extends uvm_component;

        // local interface 
        local cfs_apb_vif vif;
        // var to determine if the agent is active or passive
        local uvm_active_passive_enum active_passive;

        `uvm_component_utils(cfs_apb_agent_config)

        function new(string name = "", uvm_component parent);
            super.new(name, parent);
            active_passive = UVM_ACTIVE;
        endfunction 

        // interface getter function
        virtual function cfs_apb_vif get_vif();
            return vif;
        endfunction

        //interface setter function 
        virtual function void set_vif(cfs_apb_vif value);
            if (vif == null) begin
                vif = value;
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