module mdu(data1, data2, mdu_op, d_out_hi, d_out_lo);
    input [31:0] data1;
    input [31:0] data2;
    input [1:0]  mdu_op;
    output reg [31:0] d_out_hi;
    output reg [31:0] d_out_lo;

    wire [63:0] signed_prod   = $signed(data1)*$signed(data2);
    wire [63:0] unsigned_prod = $unsigned(data1)*$unsigned(data2);

    always @(*) begin
        case (mdu_op) 
            2'b00 : d_out_hi <= $signed(data1)/$signed(data2);
            2'b01 : d_out_hi <= $unsigned(data1)/$unsigned(data2);
            2'b10 : d_out_hi <= signed_prod[63:32];
            2'b11 : d_out_hi <= unsigned_prod[63:32];
        endcase 
    end

    always @(*) begin
        case (mdu_op) 
            2'b00 : d_out_lo <= $signed(data1)%$signed(data2);
            2'b01 : d_out_lo <= $unsigned(data1)%$unsigned(data2);
            2'b10 : d_out_lo <= signed_prod[31:0];
            2'b11 : d_out_lo <= unsigned_prod[31:0];
        endcase 
    end

endmodule