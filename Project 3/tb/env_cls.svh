`ifndef __ENV_CLS__
`define __ENV_CLS__
//------------------------------------------------------------------------------
`include "gen_cls.svh"
`include "drv_cls.svh"
`include "dat_cls.svh"
//------------------------------------------------------------------------------
class env_cls;
//------------------------------------------------------------------------------

    // Virtual Interfaces
    //-------------------------------
    virtual clkrstn_if clkrstn_vif;
    virtual fifo_if.wm fifo_wr_vif;
    virtual fifo_if.rm fifo_rd_vif;
    //-------------------------------

    // Declare Generator
    //-------------------------------
    gen_cls    fifo_gen;

    // Declare Driver
    //-------------------------------
    drv_cls    fifo_drv;

    // Declare Mailbox
    //-------------------------------
    mailbox    mbox;


    // Constructor
    //-----------------------------------------------
    function new(   virtual clkrstn_if clkrstn_vif,
                    virtual fifo_if.wm fifo_wr_vif,
                    virtual fifo_if.rm fifo_rd_vif);
    //-----------------------------------------------
    begin
        this.clkrstn_vif = clkrstn_vif;
        this.fifo_wr_vif = fifo_wr_vif;
        this.fifo_rd_vif = fifo_rd_vif;

        // Create mailbox
        //-------------------------------
        mbox = new();

        // Create generator
        //-------------------------------
        fifo_gen = new( this.mbox, 40);

        // Create driver
        //-------------------------------
        fifo_drv = new( this.mbox,
                        this.clkrstn_vif,
                        this.fifo_rd_vif,
                        this.fifo_wr_vif);

    end
    //-----------------------------------------------
    endfunction

    task run;
    //-----------------------------------------------
    begin
        fork
            begin : fork_generator
                fifo_gen.main();
            end
            begin : fork_driver
                fifo_drv.main();
            end
        join
    end
    //-----------------------------------------------
    endtask

//------------------------------------------------------------------------------
endclass : env_cls
//------------------------------------------------------------------------------
`endif