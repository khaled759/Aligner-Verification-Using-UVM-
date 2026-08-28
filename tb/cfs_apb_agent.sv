`ifndef CFS_APB_AGENT_SV
  `define CFS_APB_AGENT_SV

    class cfs_apb_agent extends uvm_agent;

        // creating a configuration instance 
        cfs_apb_agent_config agent_config;

        `uvm_component_utils(cfs_apb_agent)

        function new(string name = "", uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            agent_config = cfs_apb_agent_config::type_id::create("agent_config", this);
        endfunction

        virtual function void connect_phase(uvm_phase phase);
            
            cfs_apb_vif vif;
            string vif_name = "vif";

            super.connect_phase(phase);

            if (!uvm_config_db#(cfs_apb_vif)::get(this, "", vif_name, vif)) begin
                `uvm_fatal("APB_NO_VIF", $sformatf("Could not get from the database the
                 APB virtual interface using name \"%0s\"", vif_name))
            end
            else begin
                agent_config.set_vif(vif);
            end
        endfunction

    endclass


`endif