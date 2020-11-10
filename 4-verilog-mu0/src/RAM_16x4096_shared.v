/*  Implements a 16-bit x 4K RAM, with variable delay read.
    This is synthesisable, but will have relatively high
    resource usage and combinatorial delay.
*/
module RAM_16x4096_shared(
    input logic clk,
    input logic[11:0] address,
    input logic write,
    input logic read,
    input logic[15:0] writedata,
    output logic[15:0] readdata
);
    parameter RAM_INIT_FILE = "";
    parameter DELAY = "delay0";


    reg [15:0] memory [4095:0];

    initial begin
        integer i;
        /* Initialise to zero by default */
        for (i=0; i<4096; i++) begin
            memory[i]=0;
        end
        /* Load contents from file if specified */
        if (RAM_INIT_FILE != "") begin
            $display("RAM : INIT : Loading RAM contents from %s", RAM_INIT_FILE);
            $readmemh(RAM_INIT_FILE, memory);
        end
    end

    /* Combinatorial read path. */
    if(DELAY=="delay0") begin
        assign readdata = read ? memory[address] : 16'hxxxx;
    end

    /* Synchronous write path */
    always @(posedge clk) begin
        //$display("RAM : INFO : read=%h, addr = %h, mem=%h", read, address, memory[address]);
        if (write) begin
            memory[address] <= writedata;
        end
        if(DELAY=="delay1") begin
            readdata <= readdata;
        end
    end
endmodule
