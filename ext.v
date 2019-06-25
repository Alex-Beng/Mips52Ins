module ext( d_in16, d_out32, ext_op );
    input  [1:0]  ext_op;
    input  [15:0] d_in16;
    output reg [31:0] d_out32;

    always @(*) begin
        case (ext_op) 
            2'b00 : d_out32 <= {16'b0, d_in16};
            2'b01 : d_out32 <= {{16{d_in16[15]}}, d_in16};
            2'b10 : d_out32 <= {d_in16, 16'b0};
        endcase
    end
endmodule