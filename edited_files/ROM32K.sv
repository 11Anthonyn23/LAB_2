// This file is part of CSCE-416
// Texas A&M University 2025
// File name: design/ROM32K.sv

module ROM32K  (
                input           clk        ,
                input           reset      ,
                input           DLPclk     ,
                input  [14 : 0] DLPaddress ,
                input  [15 : 0] DLPdatain  ,
                input  [14 : 0] address    ,
                output [15 : 0] out        ,
                output          at_EoT
               );

    reg [15 : 0] rom[int];
    reg [15 : 0] rom_reg;
    reg          at_last_PC;

    //ROM load from file
    bit[14:0] ROM_address = 0;
    bit[15:0] ROM_data;
    bit       ROM_loaded = 0;
    bit[14:0] last_PC = 0;

    assign out    = rom_reg;
    assign at_EoT = at_last_PC;

    //load ROM during reset via DLP
    always @(posedge DLPclk) begin
        if(reset && (ROM_loaded == 1'b0)) begin
            int fd_rt;
            int file_data;
            rom_reg <= 16'h0;
            at_last_PC <= 0;
            // open ROM.hack file
          fd_rt = $fopen("./HACK_DIV_rom.hack","r");
            if(fd_rt) begin
                $info("ROM32K : ROM.hack file was opened FD=%0d at time %t", fd_rt, $time());
                // read ROM.hack file
                while(!$feof(fd_rt)) begin
                    $fscanf(fd_rt,"%b\n",file_data);
                    ROM_data = file_data & 32'h0000FFFF;
                    rom[ROM_address] = ROM_data;
                    $info("ROM32K : ROM written at address %0d with data 0x%x at time %t", ROM_address, ROM_data, $time());
                    ROM_address = ROM_address + 1;
                end
                ROM_loaded = 1'b1;
                last_PC = ROM_address - 1;
                $info("ROM32K : ROM load completed at last_PC 0x%x at time %t", last_PC, $time());
            end
            else begin
                $error("ROM32K : *ERROR ROM.hack was NOT opened FD=%0d at time %t",fd_rt, $time());
            end
            // close ROM.hack file
            $fclose(fd_rt);
        end
    end

    always @(negedge clk) begin
        if(reset) begin
           rom_reg <= 16'h0;
           at_last_PC <= 0;
        end
        else begin
            if(rom.exists(address)) begin
                rom_reg <= rom[address];
            end
            else begin 
                rom_reg <= address[1] ? 16'hdead : 16'hbeef;
            end                                     
            if(last_PC === address) begin
                at_last_PC <= 1;
                $info("ROM32K : ROM accessed at last_PC 0x%x at time %t", last_PC, $time());
            end
        end
    end

endmodule    

