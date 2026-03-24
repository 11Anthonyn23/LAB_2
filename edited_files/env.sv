// This file is part of CSCE-416 
// Texas A&M University 2025
// File name: uvm/env.sv

class env extends uvm_env;

//component macro
    `uvm_component_utils(env)

//Declare handles of components within the tb
    hack_agent_c hack;

//Constructor
    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

//UVM build phase method
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // CREATED hack agent
        hack = hack_agent_c::type_id::create("hack", this);

    endfunction : build_phase

//UVM connect phase method
    function void connect_phase(uvm_phase phase);
        // nothing yet
    endfunction : connect_phase

endclass: env
