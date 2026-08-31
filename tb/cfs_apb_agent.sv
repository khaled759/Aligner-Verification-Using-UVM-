`ifndef CFS_APB_AGENT_SV
  `define CFS_APB_AGENT_SV

    class cfs_apb_agent extends uvm_agent;

        // creating a configuration instance & handler 
        cfs_apb_agent_config agent_config;
        cfs_apb_sequencer sequencer;
        cfs_apb_driver driver;

        `uvm_component_utils(cfs_apb_agent)

        function new(string name = "", uvm_component parent);
            super.new(name, parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            agent_config = cfs_apb_agent_config::type_id::create("agent_config", this);

            // build sequencer and driver if active agent
            if (agent_config.get_active_passive() == UVM_ACTIVE) begin
                sequencer = cfs_apb_sequencer::type_id::create("sequencer", this);
                driver = cfs_apb_driver::type_id::create("driver", this);
            end
        endfunction

        virtual function void connect_phase(uvm_phase phase);
            
            cfs_apb_vif vif;
            string vif_name = "vif";

            super.connect_phase(phase);

            // getting the vif from the db and set it to config class
            if (!uvm_config_db#(cfs_apb_vif)::get(this, "", vif_name, vif)) begin
                `uvm_fatal("APB_NO_VIF", $sformatf("Could not get from the database the
                 APB virtual interface using name \"%0s\"", vif_name))
            end
            else begin
                agent_config.set_vif(vif);
            end

            // connecting the driver and the sequencer ports
            if (agent_config.get_active_passive() == UVM_ACTIVE) begin
                driver.agent_config = agent_config;
                driver.seq_item_port.connect(sequencer.seq_item_export);
            end
        endfunction

    endclass

`endif