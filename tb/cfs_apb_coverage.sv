`ifndef CFS_APB_COVERAGE_SV
    `define CFS_APB_COVERAGE_SV

    `uvm_analysis_imp_decl(_item)


    virtual class cfs_apb_cover_index_wrapper_base extends uvm_component;
    
        function new(string name = "", uvm_component parent);
        super.new(name, parent);
        endfunction
        
        //Function used to sample the information
        pure virtual function void sample(int unsigned value);

    endclass

    // we want to make sure that each bit in the address and data bus has been 1 and 0 
    // this param class create BUS WIDTH bins for a specfic signal
    // we will create two instances of this class for each variable for 0 and 1
    // later we will loop at each bit of the bus and if its 0 we will sample the 0 class insatance  and so on
    // this method save  a lot of code effort and sure we cant make a coverage bin for every
    // possible value of a 16 data bus.
    class cfs_apb_cover_index_wrapper#(int unsigned MAX_VALUE_PLUS_1 = 16) extends cfs_apb_cover_index_wrapper_base;
    
        `uvm_component_param_utils(cfs_apb_cover_index_wrapper#(MAX_VALUE_PLUS_1))

        covergroup cover_index with function sample(int unsigned value);
        option.per_instance = 1;
        
        index : coverpoint value {
            option.comment = "Index";
            bins values[MAX_VALUE_PLUS_1] = {[0:MAX_VALUE_PLUS_1-1]};
        }
    
        endgroup
    
        function new(string name = "", uvm_component parent);
        super.new(name, parent);
        
        cover_index = new();
        cover_index.set_inst_name($sformatf("%s_cover_index", get_full_name()));
        endfunction
    
        //Function used to sample the information
        virtual function void sample(int unsigned value);
        cover_index.sample(value);
        endfunction
    
    endclass



    class cfs_apb_coverage extends uvm_component implements cfs_apb_reset_handler;

        uvm_analysis_imp_item #(cfs_apb_item_mon, cfs_apb_coverage) port_item;
        // factory registration
        `uvm_component_utils(cfs_apb_coverage)

        cfs_apb_agent_config agent_config;
        
        //Wrapper over the coverage group covering the indices in the PADDR signal
        //at which the bit of the PADDR was 0
        cfs_apb_cover_index_wrapper#(`CFS_APB_MAX_ADDR_WIDTH) wrap_cover_addr_0;

        //Wrapper over the coverage group covering the indices in the PADDR signal
        //at which the bit of the PADDR was 1
        cfs_apb_cover_index_wrapper#(`CFS_APB_MAX_ADDR_WIDTH) wrap_cover_addr_1;

        //Wrapper over the coverage group covering the indices in the PWDATA signal
        //at which the bit of the PWDATA was 0
        cfs_apb_cover_index_wrapper#(`CFS_APB_MAX_DATA_WIDTH) wrap_cover_wr_data_0;

        //Wrapper over the coverage group covering the indices in the PWDATA signal
        //at which the bit of the PWDATA was 1
        cfs_apb_cover_index_wrapper#(`CFS_APB_MAX_DATA_WIDTH) wrap_cover_wr_data_1;

        //Wrapper over the coverage group covering the indices in the PRDATA signal
        //at which the bit of the PRDATA was 0
        cfs_apb_cover_index_wrapper#(`CFS_APB_MAX_DATA_WIDTH) wrap_cover_rd_data_0;

        //Wrapper over the coverage group covering the indices in the PRDATA signal
        //at which the bit of the PRDATA was 1
        cfs_apb_cover_index_wrapper#(`CFS_APB_MAX_DATA_WIDTH) wrap_cover_rd_data_1;


        covergroup cover_item with function sample(cfs_apb_item_mon item);
            option.per_instance = 1;

            direction : coverpoint item.dir {
                option.comment = "Direction of the APB access";
            }
            
            trans_direction : coverpoint item.dir {
                option.comment = "Transitions of APB direction";
                bins direction_trans[] = (CFS_APB_READ, CFS_APB_WRITE => CFS_APB_READ, CFS_APB_WRITE);
            }

            response : coverpoint item.response {
                option.comment = "Response of the APB access";
            }
            
            length : coverpoint item.length {
                option.comment = "Length of the APB access";
                bins length_eq_2     = {2};
                bins length_le_10[] = {[3:10]};
                bins length_gt_10    = {[11:$]};
                
                illegal_bins length_lt_2 = {[$:1]};
            }
            
            prev_item_delay : coverpoint item.prev_item_delay {
                option.comment = "Delay, in clock cycles, between two consecutive APB accesses";
                bins back2back       = {0};
                bins delay_le_5[]   = {[1:5]};
                bins delay_gt_5      = {[6:$]};
            }
      
            response_x_direction : cross response, direction;

        endgroup    

        covergroup cover_reset with function sample(bit psel);
            option.per_instance = 1;
            
            access_ongoing : coverpoint psel {
                option.comment = "An APB access was ongoing at reset";
            }
        endgroup

        function new(string name = "", uvm_component parent);
            super.new(name, parent); 
            port_item = new("port_item", this);
            cover_item = new;
            cover_item.set_inst_name($sformatf("%s_cover_item", get_full_name()));   
            cover_reset = new;
            cover_reset.set_inst_name($sformatf("%s_cover_reset", get_full_name()));  
        endfunction

        virtual function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            wrap_cover_addr_0    = cfs_apb_cover_index_wrapper#(`CFS_APB_MAX_ADDR_WIDTH)::type_id::create("wrap_cover_addr_0",    this);
            wrap_cover_addr_1    = cfs_apb_cover_index_wrapper#(`CFS_APB_MAX_ADDR_WIDTH)::type_id::create("wrap_cover_addr_1",    this);
            wrap_cover_wr_data_0 = cfs_apb_cover_index_wrapper#(`CFS_APB_MAX_DATA_WIDTH)::type_id::create("wrap_cover_wr_data_0", this);
            wrap_cover_wr_data_1 = cfs_apb_cover_index_wrapper#(`CFS_APB_MAX_DATA_WIDTH)::type_id::create("wrap_cover_wr_data_1", this);
            wrap_cover_rd_data_0 = cfs_apb_cover_index_wrapper#(`CFS_APB_MAX_DATA_WIDTH)::type_id::create("wrap_cover_rd_data_0", this);
            wrap_cover_rd_data_1 = cfs_apb_cover_index_wrapper#(`CFS_APB_MAX_DATA_WIDTH)::type_id::create("wrap_cover_rd_data_1", this);
        endfunction

        virtual task run_phase(uvm_phase phase);
            cfs_apb_vif vif = agent_config.get_vif();

            // in the middle of a reset 
            @(negedge vif.preset_n);
            cover_reset.sample(vif.psel);
        endtask
    

        // implementation function of the port
        virtual function void write_item(cfs_apb_item_mon item);
            cover_item.sample(item);

            // sampling the address 
            for (int i = 0; i < `CFS_APB_MAX_ADDR_WIDTH; i++) begin
                if(item.addr[i]) begin
                    wrap_cover_addr_1.sample(i);
                end
                else begin
                    wrap_cover_addr_0.sample(i);
                end
            end

            for (int i = 0; i < `CFS_APB_MAX_DATA_WIDTH; i++) begin
                case(item.dir)
                    CFS_APB_WRITE: begin
                        if(item.data[i]) begin
                            wrap_cover_wr_data_1.sample(i);
                        end
                        else begin
                            wrap_cover_wr_data_0.sample(i);
                        end
                    end 


                    CFS_APB_READ: begin
                        if(item.data[i]) begin
                            wrap_cover_rd_data_1.sample(i);
                        end
                        else begin
                            wrap_cover_rd_data_0.sample(i);
                        end
                    end
                endcase
            end

        endfunction;

        //handle reset function to capture coverage during reset
        virtual function void handle_reset(uvm_phase phase);
            cfs_apb_vif vif = agent_config.get_vif();
        
            cover_reset.sample(vif.psel);
        endfunction


    endclass 

`endif