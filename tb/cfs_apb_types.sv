`ifndef CFS_APB_TYPES_SV
    `define CFS_APB_TYPES_SV

    // virtual interface
    typedef virtual cfs_apb_if cfs_apb_vif; 

    // apb directin
    typedef enum bit {CFS_APB_READ = 0, CFS_APB_WRITE = 1} cfs_apb_dir; 
    // apd address
    typedef bit [`CFS_APB_MAX_ADDR_WIDTH-1:0] cfs_apb_addr;
    // apb data
    typedef bit [`CFS_APB_MAX_DATA_WIDTH-1:0] cfs_apb_data;
    // monitor response 
    typedef enum bit {CFS_APB_OKAY = 0, CFS_APB_ERR = 1} cfs_apb_response;
    
`endif