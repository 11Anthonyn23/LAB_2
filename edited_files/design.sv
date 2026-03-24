// This file is part of CSCE-416
// Texas A&M University 2025
// File name: uvm/Computer.sv

/**
 * The HACK Computer, including CPU, ROM and RAM.
 * When reset is 0, the program stored in the computer's ROM executes.
 * When reset is 1, the execution of the program restarts. 
 * Thus, to start a program's execution, reset must be pushed "up" (1)
 * and "down" (0). From this point onward the user is at the mercy of 
 * the software. 
 */
`include "hack_pkg.sv"
`include "CPU.svp"
`include "ALU.svp"
`include "ROM32K.sv"
`include "Memory.sv"
module Computer;

//Import the UVM library
    import uvm_pkg::*;
//Include the UVM macros
    `include "uvm_macros.svh"

    // import the CPU package
    import hack_pkg::*;

    //include the environment
    `include "env.sv"

    // include the test library
    `include "test_lib.svh"

    parameter ADDR_WID_HACK = 15 ;
    parameter DATA_WID_HACK = 16 ;

    reg           clk;
    wire          hack_test_if_reset;

    wire [15 : 0] RAMin;
    wire [14 : 0] RAMaddress;
    wire [15 : 0] RAMout;
    wire          loadRAM;
    wire [14 : 0] ROMaddress;
    wire [15 : 0] ROMout;
    wire          EndOfTest;

    // ROM Direct Load Port
    wire          ROM_DLP_clk;
    wire [14 : 0] ROM_DLP_address;
    wire [15 : 0] ROM_DLP_datain;

    // RAM Direct Load & Read Ports
    wire          RAM_DLP_clk;
    wire [14 : 0] RAM_DLP_address;
    wire [15 : 0] RAM_DLP_datain;
    wire          RAM_DRP_clk;
    wire [14 : 0] RAM_DRP_address;
    wire [15 : 0] RAM_DRP_dataout;

    // Instantiate the HACK_TEST interfaces
    hack_test_interface       inst_hack_test_if(clk);

    // Inputs from hack_test_interface
    assign ROM_DLP_clk     = inst_hack_test_if.ROM_DLP_clk;
    assign ROM_DLP_address = inst_hack_test_if.ROM_DLP_address;
    assign ROM_DLP_datain  = inst_hack_test_if.ROM_DLP_datain;
    assign RAM_DLP_clk     = inst_hack_test_if.RAM_DLP_clk;
    assign RAM_DLP_address = inst_hack_test_if.RAM_DLP_address;
    assign RAM_DLP_datain  = inst_hack_test_if.RAM_DLP_datain;
    assign RAM_DRP_clk     = inst_hack_test_if.RAM_DRP_clk;
    assign RAM_DRP_address = inst_hack_test_if.RAM_DRP_address;
    assign reset           = inst_hack_test_if.reset;
    // Outputs to hack_test_interface
    assign inst_hack_test_if.EndOfTest  = EndOfTest;
    assign inst_hack_test_if.RAM_DRP_dataout = RAM_DRP_dataout;
    assign inst_hack_test_if.ROMaddress = ROMaddress;

    // CPU
    CPU inst_CPU (
                      .clk(clk),
                      .reset(reset),
                      .inM         (RAMout    ),
                      .instruction (ROMout    ),
                      .writeM      (loadRAM   ),
                      .outM        (RAMin     ),
                      .addressM    (RAMaddress),
                      .pc          (ROMaddress)
                 );

    // RAM
    Memory inst_Memory (
                            .clk(clk),
                            .reset(reset),
                            .DLPclk    (RAM_DLP_clk    ),
                            .DLPaddress(RAM_DLP_address),
                            .DLPdatain (RAM_DLP_datain ),
                            .DRPclk    (RAM_DRP_clk    ),
                            .DRPaddress(RAM_DRP_address),
                            .DRPdataout(RAM_DRP_dataout),
                            .in        (RAMin     ),
                            .load      (loadRAM   ),
                            .address   (RAMaddress),
                            .out       (RAMout    )
                       );

    // ROM
    ROM32K inst_ROM32K (
                            .clk(clk),
                            .reset(reset),
                            .DLPclk    (ROM_DLP_clk    ),
                            .DLPaddress(ROM_DLP_address),
                            .DLPdatain (ROM_DLP_datain ),
                            .address   (ROMaddress     ),
                            .out       (ROMout         ),
                            .at_EoT    (EndOfTest      )
                       );

    // System clock generation
    initial begin
        clk = 1'b0;
//        #40; //delay to load ROM via DLP
        forever
            #5 clk = ~clk;
    end

    // System reset generation
    //initial begin
    //    reset = 1'b1;
    //    #10 reset = 1'b0;
    //end

//TB inital setup
    initial begin
        `uvm_info("COMPUTER","Starting UVM test", UVM_LOW)
//Set Virtual Interface,
        uvm_config_db#(virtual interface hack_test_interface)::set(null,"*.tb.hack.*","vif",inst_hack_test_if);
        run_test();
        `uvm_info("COMPUTER","DONE", UVM_LOW)
    end

endmodule
