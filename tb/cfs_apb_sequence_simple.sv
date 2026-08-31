`ifndef CFS_APB_SEQUENCE_SIMPLE_SV
    `define CFS_APB_SEQUENCE_SIMPLE_SV

    class  cfs_apb_sequence_simple extends cfs_apb_sequence_base;
        
        rand cfs_apb_item_drv item;

        `uvm_object_utils(cfs_apb_sequence_simple)
        
        function new(string name = "");
            super.new(name);
            item = cfs_apb_item_drv::type_id::create("item");
        endfunction


        virtual task body();
        // can be replaced with `uvm_send(item) macro 

            // asking for sequencer permission to send an item
            start_item(item);
            // passing the item to the driver
            finish_item(item);
        endtask

    endclass

`endif