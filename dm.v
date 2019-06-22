module dm( clk, addr, dm_wr, d_in, d_out );
    input  clk;
    input  dm_wr;
    input  [11:2] addr;
    input  [31:0] d_in;
    output [31:0] d_out;

    reg [31:0] d_mem[1023:0];

    always @(posedge clk) begin
        if (dm_wr) begin
            d_mem[addr] <= d_in;
        end
    end

    assign d_out = d_mem[addr];
endmodule