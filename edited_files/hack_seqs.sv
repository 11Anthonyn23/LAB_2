// This file is part of CSCE-416
// Texas A&M University 2025
// File name: uvm/hack_seqs.sv

class hack_base_seq extends uvm_sequence #(hack_transaction_c);
    `uvm_object_utils(hack_base_seq)
    
    function new (string name = "hack_base_seq");
        super.new(name);
    endfunction

    virtual task body();
        `uvm_info(get_type_name(), "executing default HACK transactions", UVM_LOW)
        `uvm_do_with(req, {request_type == RUN_TEST; access_cache_type == ROM_ACC; address == 15'h0000;})
        `uvm_do_with(req, {request_type == TEST_RAM; access_cache_type == RAM_ACC; address == 15'h0000; exp_data == 16'h0000;})
    endtask

    task pre_body();
        if(starting_phase != null) begin
            starting_phase.raise_objection(this, get_type_name());
            `uvm_info(get_type_name(), "raise_objection", UVM_LOW)
        end
    endtask : pre_body

    task post_body();
        if(starting_phase != null) begin
            starting_phase.drop_objection(this, get_type_name());
            `uvm_info(get_type_name(), "drop_objection", UVM_LOW)
        end
    endtask : post_body

endclass : hack_base_seq

class hack_add_trans_seq extends uvm_sequence #(hack_transaction_c);
//used for HACK_ADD test
    `uvm_object_utils(hack_add_trans_seq)

    function new (string name = "hack_add_trans_seq");
        super.new(name);
    endfunction

    virtual task body();
        `uvm_info(get_type_name(), "executing HACK_ADD transactions", UVM_LOW)
        `uvm_do_with(req, {request_type == RUN_TEST; access_cache_type == ROM_ACC; address == 15'h0000;})
        `uvm_do_with(req, {request_type == TEST_RAM; access_cache_type == RAM_ACC; address == 15'h0000; exp_data == 16'h0005;})
    endtask

    task pre_body();
        if(starting_phase != null) begin
            starting_phase.raise_objection(this, get_type_name());
            `uvm_info(get_type_name(), "raise_objection", UVM_LOW)
        end
    endtask : pre_body

    task post_body();
        if(starting_phase != null) begin
            starting_phase.drop_objection(this, get_type_name());
            `uvm_info(get_type_name(), "drop_objection", UVM_LOW)
        end
    endtask : post_body

endclass : hack_add_trans_seq

class hack_max_trans_seq extends uvm_sequence #(hack_transaction_c);
//used for HACK_MAX test
    `uvm_object_utils(hack_max_trans_seq)

    function new (string name = "hack_max_trans_seq");
        super.new(name);
    endfunction

    virtual task body();
        `uvm_info(get_type_name(), "executing HACK_MAX transactions", UVM_LOW)
        `uvm_do_with(req, {request_type == RUN_TEST; access_cache_type == ROM_ACC; address == 15'h0000;})
        `uvm_do_with(req, {request_type == TEST_RAM; access_cache_type == RAM_ACC; address == 15'h0002; exp_data == 16'h0005;})

    endtask

    task pre_body();
        if(starting_phase != null) begin
            starting_phase.raise_objection(this, get_type_name());
            `uvm_info(get_type_name(), "raise_objection", UVM_LOW)
        end
    endtask : pre_body

    task post_body();
        if(starting_phase != null) begin
            starting_phase.drop_objection(this, get_type_name());
            `uvm_info(get_type_name(), "drop_objection", UVM_LOW)
        end
    endtask : post_body

endclass : hack_max_trans_seq

class hack_max2_trans_seq extends uvm_sequence #(hack_transaction_c);
//used for HACK_MAX2 test
    `uvm_object_utils(hack_max2_trans_seq)

    function new (string name = "hack_max2_trans_seq");
        super.new(name);
    endfunction

    virtual task body();
        `uvm_info(get_type_name(), "executing HACK_MAX2 transactions", UVM_LOW)
        `uvm_do_with(req, {request_type == RUN_TEST; access_cache_type == ROM_ACC; address == 15'h0000;})
        `uvm_do_with(req, {request_type == TEST_RAM; access_cache_type == RAM_ACC; address == 15'h0002; exp_data == 16'h5BA0;})
    endtask

    task pre_body();
        if(starting_phase != null) begin
            starting_phase.raise_objection(this, get_type_name());
            `uvm_info(get_type_name(), "raise_objection", UVM_LOW)
        end
    endtask : pre_body

    task post_body();
        if(starting_phase != null) begin
            starting_phase.drop_objection(this, get_type_name());
            `uvm_info(get_type_name(), "drop_objection", UVM_LOW)
        end
    endtask : post_body

endclass : hack_max2_trans_seq

class hack_rect_trans_seq extends uvm_sequence #(hack_transaction_c);
//used for HACK_RECT test
    `uvm_object_utils(hack_rect_trans_seq)

    function new (string name = "hack_rect_trans_seq");
        super.new(name);
    endfunction

    virtual task body();
        `uvm_info(get_type_name(), "executing HACK_RECT transactions", UVM_LOW)
        `uvm_do_with(req, {request_type == RUN_TEST; access_cache_type == ROM_ACC; address == 15'h0000;})
        `uvm_do_with(req, {request_type == TEST_RAM; access_cache_type == RAM_ACC; address == 15'h4000; exp_data == 16'hFFFF;})
        `uvm_do_with(req, {request_type == TEST_RAM; access_cache_type == RAM_ACC; address == 15'h4020; exp_data == 16'hFFFF;})
        `uvm_do_with(req, {request_type == TEST_RAM; access_cache_type == RAM_ACC; address == 15'h4040; exp_data == 16'hFFFF;})
        `uvm_do_with(req, {request_type == TEST_RAM; access_cache_type == RAM_ACC; address == 15'h4060; exp_data == 16'hFFFF;})
    endtask

    task pre_body();
        if(starting_phase != null) begin
            starting_phase.raise_objection(this, get_type_name());
            `uvm_info(get_type_name(), "raise_objection", UVM_LOW)
        end
    endtask : pre_body

    task post_body();
        if(starting_phase != null) begin
            starting_phase.drop_objection(this, get_type_name());
            `uvm_info(get_type_name(), "drop_objection", UVM_LOW)
        end
    endtask : post_body

endclass : hack_rect_trans_seq
class hack_mult_trans_seq extends uvm_sequence #(hack_transaction_c);
//used for HACK_MULT test
    `uvm_object_utils(hack_mult_trans_seq)

    function new (string name = "hack_mult_trans_seq");
        super.new(name);
    endfunction

    virtual task body();
        `uvm_info(get_type_name(), "executing HACK_MULT transactions", UVM_LOW)
        `uvm_do_with(req, {request_type == RUN_TEST; access_cache_type == ROM_ACC; address == 15'h0000;})
        `uvm_do_with(req, {request_type == TEST_RAM; access_cache_type == RAM_ACC; address == 15'h0000; exp_data == 16'h0002;})
    endtask

    task pre_body();
        if(starting_phase != null) begin
            starting_phase.raise_objection(this, get_type_name());
            `uvm_info(get_type_name(), "raise_objection", UVM_LOW)
        end
    endtask : pre_body

    task post_body();
        if(starting_phase != null) begin
            starting_phase.drop_objection(this, get_type_name());
            `uvm_info(get_type_name(), "drop_objection", UVM_LOW)
        end
    endtask : post_body     
  endclass : hack_mult_trans_seq


class hack_div_trans_seq extends uvm_sequence #(hack_transaction_c);
      
//used for HACK_DIV test
    `uvm_object_utils(hack_div_trans_seq)

    function new (string name = "hack_div_trans_seq");
        super.new(name);
    endfunction

    virtual task body();
        `uvm_info(get_type_name(), "executing HACK_DIV transactions", UVM_LOW)
        `uvm_do_with(req, {request_type == RUN_TEST; access_cache_type == ROM_ACC; address == 15'h0000;})
        `uvm_do_with(req, {request_type == TEST_RAM; access_cache_type == RAM_ACC; address == 15'h0000; exp_data == 16'h0000;})
    endtask

    task pre_body();
        if(starting_phase != null) begin
            starting_phase.raise_objection(this, get_type_name());
            `uvm_info(get_type_name(), "raise_objection", UVM_LOW)
        end
    endtask : pre_body

    task post_body();
        if(starting_phase != null) begin
            starting_phase.drop_objection(this, get_type_name());
            `uvm_info(get_type_name(), "drop_objection", UVM_LOW)
        end
    endtask : post_body

endclass : hack_div_trans_seq
  




