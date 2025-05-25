`ifndef __FIFO_TEST__
`define __FIFO_TEST__
//-----------------------------------------------------------------------------
`include "fifo_if.sv"
`include "env_cls.svh"
`include "gen_cls.svh"
`include "drv_cls.svh"
//-----------------------------------------------------------------------------
module fifo_test(
//-----------------------------------------------------------------------------
    clkrstn_if      clkrstn,
    fifo_if.rm      fifo_read,
    fifo_if.wm      fifo_write
);
//-----------------------------------------------------------------------------
/**
 * Declare Environment
 */
env_cls fifo_env;
/**
 * Declare synchronization event
 */
//-----------------------------------------------------------------------------
initial begin
    //-----------------------------------------
    $info("[info] Fifo test started");
    //-----------------------------------------
    /**
     * Instantiate environement
     */
    fifo_env = new(clkrstn,
                   fifo_write,
                   fifo_read);
    //-----------------------------------------
    fork
        begin
            /**
             * Run Test
             */
            fifo_env.run();
        end
    //-----------------------------------------
        begin
            /**
             * Temp. delay
             */
            repeat (100) begin @(posedge clkrstn.clk); end
        end
    join_any
    //-----------------------------------------
    $info("[info] Fifo test ended");
    //-----------------------------------------
    $finish;
end
//-----------------------------------------------------------------------------
endmodule
//-----------------------------------------------------------------------------
`endif