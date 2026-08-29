`ifndef CFS_APB_ITEM_DRV_SV
    `define CFS_APB_ITEM_DRV_SV

    class cfs_apb_item_drv extends cfs_apb_item_base;

        rand cfs_apb_dir dir;
        rand cfs_apb_addr addr;
        rand cfs_apb_data data;
        
        rand int unsigned pre_drive_delay;
        rand int unsigned post_drive_delay;

        constraint pre_drive_delay_defult {
            soft pre_drive_delay <= 5;
        }

        constraint post_drive_delay_defult {
            soft post_drive_delay <= 5;
        }
        
        
        
        `uvm_object_utils(cfs_apb_item_drv)

        function new(string name = "");
            super.new(name);
        endfunction

        virtual function string convert2string();
            string result = $sformatf("dir: %0s, addr: %0x", dir.name(), addr);
            
            if(dir == CFS_APB_WRITE) begin
                result = $sformatf("%s, data: %0x", result, data);
            end
            
            result = $sformatf("%s, pre_drive_delay: %0d, post_drive_delay: %0d", 
                                result, pre_drive_delay, post_drive_delay);
            
            return result;
        endfunction

    endclass
`endif