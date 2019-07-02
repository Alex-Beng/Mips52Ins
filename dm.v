module dm( clk, rst, addr, dm_wr, dm_wr_op, dm_rd_op, d_in, d_out );
    input  clk;
    input  rst;
    input  dm_wr;
    input  [1:0] dm_wr_op;
    input  [2:0] dm_rd_op;
    input  [9:0] addr;
    input  [31:0] d_in;
    output reg [31:0] d_out;

    reg [7:0] d_mem[512:0];

    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin 
            for (i=0; i<512; i=i+1) begin:bit
                d_mem[i] <= 8'b0;
            end
        end
        if (dm_wr) begin
            case(dm_wr_op)
                2'b00 : d_mem[addr+3]   <= d_in[7:0];
                2'b01 : begin
                    d_mem[addr+2] <= d_in[15:8];
                    d_mem[addr+3] <= d_in[7:0];
                end       
                2'b10 : begin
                    d_mem[addr]   <= d_in[31:24];
                    d_mem[addr+1] <= d_in[23:16];
                    d_mem[addr+2] <= d_in[15:8];
                    d_mem[addr+3] <= d_in[7:0];
                end
            endcase
            // d_mem[addr] <= d_in;
        end
    end

    // assign d_out = d_mem[addr];
    wire [8:0] addr_bits = d_mem[addr];
    wire s = addr_bits[0];
    always @(*) begin
        case(dm_rd_op) 
            3'b000 : d_out <= {24'b0, d_mem[addr+3]};
            3'b001 : d_out <= {{24{d_mem[addr+3][0]}}, d_mem[addr+3]};
            3'b010 : d_out <= {16'b0, d_mem[addr+2], d_mem[addr+3]};
            3'b011 : d_out <= {{16{d_mem[addr+2][0]}}, d_mem[addr+2], d_mem[addr+3]};
            3'b100 : d_out <= {d_mem[addr], d_mem[addr+1], d_mem[addr+2], d_mem[addr+3]};
        endcase
    end 
endmodule