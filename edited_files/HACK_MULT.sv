// This file is part of CSCE-416
// Texas A&M University 2025
// File name: test/HACK_MULT.sv

class HACK_MULT extends base_test;

    //component macro
    `uvm_component_utils(HACK_MULT)

    //Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    //UVM build phase
    function void build_phase(uvm_phase phase);
        uvm_config_wrapper::set(this,"tb.hack.sequencer.run_phase","default_sequence",hack_mult_trans_seq::type_id::get());
        super.build_phase(phase);
    endfunction : build_phase

    //UVM run phase()
    task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "Executing HACK_MULT test" , UVM_LOW)
        // link to HACK_MULT rom and ram hack files for loading
        $system($sformatf("ln -fs ../test/HACK_MULT_rom.hack ROM.hack"));
        $system($sformatf("ln -fs ../test/HACK_MULT_ram.hack RAM.hack"));
    endtask : run_phase

endclass : HACK_MULT