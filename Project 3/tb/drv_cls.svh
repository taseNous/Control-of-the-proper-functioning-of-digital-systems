`ifndef __DRV_CLS__
`define __DRV_CLS__
//------------------------------------------------------------------------------
// FIFO interfaces declaration
//------------------------------------------------------------------------------
typedef virtual fifo_if.rm fifo_r_vif_i;
typedef virtual fifo_if.wm fifo_w_vif_o;
//------------------------------------------------------------------------------
class drv_cls;
//------------------------------------------------------------------------------

    virtual clkrstn_if   clkrstn_vif;
    fifo_r_vif_i         fifor_vif_i;
    fifo_w_vif_o         fifow_vif_o;
    //---------------------------------------------------------
    dat_cls              data_pkt;
    //---------------------------------------------------------

    // Mailbox
    //---------------------------------------------------------
    mailbox mbox;

    // Constructor
    //---------------------------------------------------------
    function new(         mailbox      mbox,
                  virtual clkrstn_if   clkrstn_vif,
                          fifo_r_vif_i fifor_vif_i,
                          fifo_w_vif_o fifow_vif_o );
    //---------------------------------------------------------
        this.mbox        = mbox;
        this.clkrstn_vif = clkrstn_vif;
        this.fifor_vif_i = fifor_vif_i;
        this.fifow_vif_o = fifow_vif_o;
    //---------------------------------------------------------
    endfunction : new

    task main;
    begin
        fork
            begin
                fifo_write();
            end
            begin
                fifo_read();
            end
        join
    end
    endtask : main
    //---------------------------------------------------------

    // fifo write
    //---------------------------------------------------------
    task fifo_write;
    //---------------------------------------------------------
    begin
        forever
        begin
            @(posedge clkrstn_vif.clk);
            if(!clkrstn_vif.rstn) begin
                fifow_vif_o.data <=  'd0;
                fifow_vif_o.req  <= 1'b0;
            end
            else begin
                if( !fifow_vif_o.req || ( fifow_vif_o.req && !fifow_vif_o.ack ))
                begin
                    if(mbox.num() > 'd0 ) begin
                        mbox.get(data_pkt);
                        data_pkt.show("drv");
                        fifow_vif_o.data <= data_pkt.data;
                        fifow_vif_o.req  <= 1'b1;
                    end
                    else begin
                        fifow_vif_o.data <=  'd0;
                        fifow_vif_o.req  <= 1'b0;
                    end
                end
            end
        end
    end
    //---------------------------------------------------------
    endtask : fifo_write
    //---------------------------------------------------------
    // FIFO Read
    //---------------------------------------------------------
    task fifo_read;
    //---------------------------------------------------------
    begin
        forever
        begin
            @(posedge clkrstn_vif.clk);
            if(!clkrstn_vif.rstn) begin
                fifor_vif_i.ack  <= 1'b0;
            end
            else begin
                fifor_vif_i.ack <= !fifor_vif_i.req;
                if(fifor_vif_i.ack&&!fifor_vif_i.req) begin
                    $display("pop data: 0x%0h",fifor_vif_i.data);
                end
            end
        end
    end
    //---------------------------------------------------------
    endtask : fifo_read
    //---------------------------------------------------------

//------------------------------------------------------------------------------
endclass: drv_cls
//------------------------------------------------------------------------------
`endif