// This file is part of CSCE-416
// Texas A&M University 2025
// File name: uvm/hack_driver_c.sv

`define TIME_OUT_VAL 100

class hack_driver_c extends uvm_driver #(hack_transaction_c);

    parameter ADDR_WID_HACK = 15 ;
    parameter DATA_WID_HACK = 16 ;

    // UVM registration
    `uvm_component_utils(hack_driver_c)

    // Virtual interface
    virtual interface hack_test_interface vi_hack_test_if;

    // constructor
    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    // declare tasks & functions
    extern function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
    extern protected task get_and_drive();
    extern task send_to_dut(hack_transaction_c transaction);
    extern protected task run_test_trans(bit [ADDR_WID_HACK-1:0] addr);

    
    extern protected task test_RAM_trans(
        bit [ADDR_WID_HACK-1:0] addr,
        bit [DATA_WID_HACK-1:0] exp_data
    );

endclass : hack_driver_c


// IMPLEMENTATIONS 

// build_phase
function void hack_driver_c::build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(virtual hack_test_interface)::get(this, "","vif", vi_hack_test_if))
        `uvm_fatal("NO_VIF",{" *ERROR virtual interface must be set for: ",get_full_name(),".vif"});
endfunction: build_phase


// run_phase
task hack_driver_c::run_phase(uvm_phase phase);
    `uvm_info(get_type_name(), "RUN Phase", UVM_LOW)
    get_and_drive();
endtask: run_phase


// get_and_drive
task hack_driver_c::get_and_drive();
    forever begin
        seq_item_port.get_next_item(req);
        send_to_dut(req);
        seq_item_port.item_done();
    end
endtask: get_and_drive


// send_to_dut
task hack_driver_c::send_to_dut(hack_transaction_c transaction);

    `uvm_info(get_type_name(), 
        $sformatf("Input Data to Send:\n%s", transaction.sprint()),
        UVM_LOW
    );

    // reset interface signals
    vi_hack_test_if.ROM_DLP_clk     <= 1'b0;
    vi_hack_test_if.ROM_DLP_address <= {ADDR_WID_HACK{1'b0}};
    vi_hack_test_if.ROM_DLP_datain  <= {DATA_WID_HACK{1'b0}};

    vi_hack_test_if.RAM_DLP_clk     <= 1'b0;
    vi_hack_test_if.RAM_DLP_address <= {ADDR_WID_HACK{1'b0}};
    vi_hack_test_if.RAM_DLP_datain  <= {DATA_WID_HACK{1'b0}};

    vi_hack_test_if.RAM_DRP_clk     <= 1'b0;
    vi_hack_test_if.RAM_DRP_address <= {ADDR_WID_HACK{1'b0}};

    if(transaction.request_type == RUN_TEST)
        run_test_trans(transaction.address);
    else if(transaction.request_type == TEST_RAM)
        test_RAM_trans(transaction.address, transaction.exp_data);
    else
        `uvm_error(get_type_name()," *ERROR Invalid request type")

    `uvm_info(get_type_name(), "Ended Driving transaction", UVM_LOW)

endtask : send_to_dut


// run_test_trans
task hack_driver_c::run_test_trans(bit [ADDR_WID_HACK-1:0] addr);

    $info("COMPUTER : Driving RUN_TEST transaction at time %t", $time());

    #1 vi_hack_test_if.ROM_DLP_clk <= 1'b1;
       vi_hack_test_if.RAM_DLP_clk <= 1'b1;

    #1 vi_hack_test_if.ROM_DLP_clk <= 1'b0;
       vi_hack_test_if.RAM_DLP_clk <= 1'b0;

    #7 vi_hack_test_if.reset <= 1'b0;

    @(posedge vi_hack_test_if.clk);

    fork
        @(posedge vi_hack_test_if.EndOfTest);
        begin
            repeat(`TIME_OUT_VAL) @(posedge vi_hack_test_if.clk);
        end
    join_any

    disable fork;

    if(vi_hack_test_if.EndOfTest !== 1'b1) begin
        `uvm_error(get_type_name(),
            $sformatf("COMPUTER : *ERROR RUN_TEST transaction timed-out at time %t", $time()));
    end

    @(posedge vi_hack_test_if.clk);

endtask: run_test_trans


//  FILLED LAB7 TASK 

// test_RAM_trans
task hack_driver_c::test_RAM_trans(
    bit [ADDR_WID_HACK-1:0] addr,
    bit [DATA_WID_HACK-1:0] exp_data
);

    $info("COMPUTER : Driving TEST_RAM transaction at time %t", $time());

    // Drive RAM read port
    vi_hack_test_if.RAM_DRP_address <= addr;
    #1 vi_hack_test_if.RAM_DRP_clk  <= 1'b1;
    #1 vi_hack_test_if.RAM_DRP_clk  <= 1'b0;

    @(posedge vi_hack_test_if.clk);

    $info("COMPUTER : TEST_RAM transaction dataout at address 0x%x is 0x%x at time %t",
          addr, vi_hack_test_if.RAM_DRP_dataout, $time());

    // Check expected value
    if(vi_hack_test_if.RAM_DRP_dataout !== exp_data) begin
        `uvm_error(get_type_name(),
            $sformatf("COMPUTER : *ERROR TEST_RAM transaction dataout at address 0x%x is not 0x%x at time %t",
            addr, exp_data, $time()));
    end

    @(posedge vi_hack_test_if.clk);

endtask: test_RAM_trans