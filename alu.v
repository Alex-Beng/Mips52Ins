module alu( data1, data2, alu_op, d_out, EXP_overflow );
    input [31:0] data1;
    input [31:0] data2;
    input [3:0]  alu_op;
    output reg [31:0] d_out;
    output reg EXP_overflow;

    wire [32:0] op1 = {data1[31], data1};
    wire [32:0] op2 = {data2[31], data2};
    reg [32:0] op_out;

    always @(*) begin
        case(alu_op)
            4'b0000 : op_out <= op1+op2;
            4'b0001 : op_out <= op1-op2;
        endcase
    end

    always @(*) begin
        case(alu_op)
            4'b0000 : d_out <= op_out[31:0];
            4'b0001 : d_out <= op_out[31:0];
            4'b0010 : d_out <= data1|data2;
            4'b0011 : d_out <= ($signed(data1) < $signed(data2))?1:0;
            4'b0100 : d_out <= (data1 < data2)?1:0;
            4'b0101 : d_out <= data1&data2;
            4'b0110 : d_out <= ~(data1|data2);
            4'b0111 : d_out <= data1^data2;
            4'b1000 : d_out <= ($signed(data1) > $signed(data2))?1:0;
            default: d_out <= 0;
        endcase
    end


    always @(*) begin
        if (alu_op == 4'b0000
        |   alu_op == 4'b0001) begin
            EXP_overflow <= (op_out[32]^op_out[31]);
        end
        else begin
            EXP_overflow <= 1'b0;
        end
    end
endmodule