module ext( d_in16, d_out32, ext_op );
    input  ext_op;
    input  [15:0] d_in16;
    output [31:0] d_out32;

    always @(*) begin
        case (ext_op) 
            1'b0 : d_out32 = {16'b0, d_in16};
            1'b1 : d_out32 = {{16{d_in16[15]}}, d_in16};
        endcase
    end
endmodule