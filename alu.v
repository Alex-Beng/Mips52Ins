module alu( data1, data2, alu_op, d_out, EXP_overflow );
    input [31:0] data1;
    input [31:0] data2;
    input [2:0]  alu_op;
    output reg [31:0] d_out;
    output reg EXP_overflow;

    wire [32:0] op1 = {data1[31], data1};
    wire [32:0] op2 = {data2[31], data2};
    reg [32:0] op_out;

    always @(*) begin
        case(alu_op)
            3'b000 : op_out <= op1+op2;
            3'b001 : op_out <= op1-op2;
        endcase
    end

    always @(*) begin
        case(alu_op)
            3'b000 : d_out <= op_out[31:0];
            3'b001 : d_out <= op_out[31:0];
            3'b010 : d_out <= data1|data2;
            3'b011 : d_out <= ($signed(data1) < $signed(data2))?1:0;
            3'b100 : d_out <= (data1 < data2)?1:0;
            3'b101 : d_out <= data1&data2;
            3'b110 : d_out <= ~(data1|data2);
            3'b111 : d_out <= data1^data2;
            default: d_out <= 0;
        endcase
    end


    always @(*) begin
        if (alu_op == 3'b000
        |   alu_op == 3'b001) begin
            EXP_overflow <= (op_out[32]^op_out[31]);
        end
        else begin
            EXP_overflow <= 1'b0;
        end
    end
endmodule