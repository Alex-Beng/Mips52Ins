module su( d_in, s, su_op, d_out );
    input [31:0] d_in;
    input [4:0]  s;
    input [1:0]  su_op;
    output reg [31:0] d_out;

    always @(*) begin
        case (su_op)
            2'b00 : d_out <= d_in<<s;
            2'b01 : d_out <= $signed(d_in)>>>s;
            // 2'b01 : d_out <= d_in>>>s;
            2'b10 : d_out <= d_in>>s;
        endcase
    end
endmodule