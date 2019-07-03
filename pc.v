module pc( clk, rst, pc_wr, n_pc, pc );
    input  clk;
    input  rst;
    input  pc_wr;
    input  [31:0] n_pc;
    output [31:0] pc;

    reg [31:0] cnt;

    always @(posedge clk) begin
        if (~rst) begin
            cnt <= 32'hbfc00000;
        end
        if (pc_wr) begin
            cnt <= n_pc;
        end
    end

    assign pc = cnt;
endmodule