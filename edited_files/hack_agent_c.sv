// This file is part of CSCE-416 
// Texas A&M University 2025
// File name: uvm/hack_agent_c.sv

class hack_agent_c extends uvm_agent;

// Active/passive setting
    protected uvm_active_passive_enum is_active = UVM_ACTIVE;

// Handles
    hack_driver_c    driver;
//  no monitor at this time
    hack_sequencer_c sequencer;   // ADDED

// UVM registration
    `uvm_component_utils_begin(hack_agent_c)
        `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
    `uvm_component_utils_end

// Constructor
    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

// Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(is_active == UVM_ACTIVE) begin
            // Create driver
            driver = hack_driver_c::type_id::create("driver", this);

            // Create sequencer
            sequencer = hack_sequencer_c::type_id::create("sequencer", this);
        end

    endfunction : build_phase

// Connect phase
    function void connect_phase(uvm_phase phase);

        if(is_active == UVM_ACTIVE) begin
            // Connect driver to sequencer
            driver.seq_item_port.connect(sequencer.seq_item_export);
        end

    endfunction : connect_phase

endclass: hack_agent_c