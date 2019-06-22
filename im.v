module im( addr, d_out );
    input  [11:2]  addr;
    output [31:0]  d_out;

    reg [31:0] ins_mem[1023:0];

    assign d_out = ins_mem[addr];
endmodule