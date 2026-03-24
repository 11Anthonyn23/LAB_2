// This file is part of CSCE-416
// Texas A&M University 2025
// File name: uvm/hack_test_interface.sv

interface hack_test_interface(input clk);

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    parameter ADDR_WID_HACK  = 15                   ;
    parameter DATA_WID_HACK  = 16                   ;

    //Inputs from Computer.sv
    wire  [ADDR_WID_HACK - 1   : 0] ROMaddress      ;
    wire  [DATA_WID_HACK - 1   : 0] RAM_DRP_dataout ;
    wire                            EndOfTest       ;

    //Outputs to Computer.sv
    logic                           reset           ;
    logic                           ROM_DLP_clk     ;
    logic [ADDR_WID_HACK - 1   : 0] ROM_DLP_address ;
    logic [DATA_WID_HACK - 1   : 0] ROM_DLP_datain  ;
    logic                           RAM_DLP_clk     ;
    logic [ADDR_WID_HACK - 1   : 0] RAM_DLP_address ;
    logic [DATA_WID_HACK - 1   : 0] RAM_DLP_datain  ;
    logic                           RAM_DRP_clk     ;
    logic [ADDR_WID_HACK - 1   : 0] RAM_DRP_address ;

    // initialization
    initial begin
      reset           = 1'b1;
      ROM_DLP_clk     = 1'b0;
      ROM_DLP_address = 15'h0000;
      ROM_DLP_datain  = 16'h0000;
      RAM_DLP_clk     = 1'b0;
      RAM_DLP_address = 15'h0000;
      RAM_DLP_datain  = 16'h0000;
      RAM_DRP_clk     = 1'b0;
      RAM_DRP_address = 15'h0000;
    end

//Assertions

//CoverGroups

endinterface
