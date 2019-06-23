module alu( data1, data2, alu_op, d_out, zero_flag, EXP_overflow );
    input [31:0] data1;
    input [31:0] data2;
    input [1:0]  alu_op;
    output reg [31:0] d_out;
    output zero_flag;
    output EXP_overflow;

    wire [32:0] op1 = {data1[31], data1};
    wire [32:0] op2 = {data2[31], data2};
    reg [32:0] op_out;

    always @(*) begin
        case(alu_op)
            2'b00 : op_out <= op1+op2;
            2'b01 : op_out <= op1-op2;
        endcase
    end

    always @(*) begin
        case(alu_op)
            2'b00 : d_out <= op_out[31:0];
            2'b01 : d_out <= op_out[31:0];
            2'b10 : d_out <= data1|data2;
            default: d_out <= 0;
        endcase
    end

    assign zero_flag = (data1==data2);
    assign EXP_overflow = (op_out[32]^op_out[31]);
endmodule