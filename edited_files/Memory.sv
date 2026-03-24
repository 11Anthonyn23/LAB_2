// This file is part of CSCE-416
// Texas A&M University 2025
// File name: design/Memory.sv

module Memory  (
                input           clk        ,
                input           reset      ,
                input           DLPclk     ,
                input  [14 : 0] DLPaddress ,
                input  [15 : 0] DLPdatain  ,
                input           DRPclk     ,
                input  [14 : 0] DRPaddress ,
                output [15 : 0] DRPdataout ,
                inout  [15 : 0] in         ,
                input           load       ,
                input  [14 : 0] address    ,
                output [15 : 0] out     
               );

    reg [15 : 0] mem[int];
    reg [15 : 0] mem_reg;
    reg [15 : 0] DRP_mem_reg;
    
    //RAM load from file
    bit[14:0] RAM_address = 0;
    bit[15:0] RAM_data;
    bit       RAM_loaded = 0;

    assign out        = mem_reg;
    assign DRPdataout = DRP_mem_reg;
    
    //load RAM during reset via DLP
    always @(posedge DLPclk) begin
        if(reset && (RAM_loaded == 1'b0)) begin
            int fd_rt;
            int file_data;
            // open RAM.hack file
          fd_rt = $fopen("./HACK_DIV_ram.hack","r");
            if(fd_rt) begin
                $info("Memory : RAM.hack file was opened FD=%0d at time %t", fd_rt, $time());
                // read RAM.hack file
                while(!$feof(fd_rt)) begin
                    $fscanf(fd_rt,"%b\n",file_data);
                    RAM_address = file_data & 32'h00007FFF;
                    $fscanf(fd_rt,"%b\n",file_data);
                    RAM_data = file_data & 32'h0000FFFF;
                    mem[RAM_address] = RAM_data;
                    $info("Memory : RAM written at address %0d with data 0x%x at time %t", RAM_address, RAM_data, $time());
                end
                RAM_loaded = 1'b1;
            end
            else begin
                $error("Memory : *ERROR RAM.hack was NOT opened FD=%0d at time %t",fd_rt, $time());
            end
            // close RAM.hack file
            $fclose(fd_rt);
        end
    end

    //read RAM via DRP
    always @(posedge DRPclk) begin
        DRP_mem_reg <= mem[DRPaddress];
    end

    always @(negedge clk) begin
        if(reset) begin   // reset
            mem_reg <= 16'h0;
        end
        else if(!load) begin   // read
            if(mem.exists(address)) begin
                mem_reg <= mem[address];
            end                
            else begin 
                mem_reg <= address[1] ? 16'hdead : 16'hbeef;
            end                                     
        end
        else if(load) begin   // write 
            mem[address] = in;
        end
    end

endmodule    

