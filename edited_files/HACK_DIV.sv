// This file is part of CSCE-416
// Texas A&M University 2025
// File name: test/HACK_DIV.sv

class HACK_DIV extends base_test;

    //component macro
    `uvm_component_utils(HACK_DIV)

    //Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    //UVM build phase
    function void build_phase(uvm_phase phase);
        uvm_config_wrapper::set(this,"tb.hack.sequencer.run_phase","default_sequence",hack_div_trans_seq::type_id::get());
        super.build_phase(phase);
    endfunction : build_phase

    //UVM run phase()
    task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "Executing HACK_DIV test" , UVM_LOW)
        // link to HACK_DIV rom and ram hack files for loading
        $system($sformatf("ln -fs ../test/HACK_DIV_rom.hack ROM.hack"));
        $system($sformatf("ln -fs ../test/HACK_DIV_ram.hack RAM.hack"));
    endtask : run_phase

endclass : HACK_DIV