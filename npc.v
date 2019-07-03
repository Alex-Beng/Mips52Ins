module npc( pc, d_ins26, d_ext32, d_rfrs32, d_btypc, npc_op, npc );
    input  [31:0] pc;
    input  [25:0] d_ins26;
    input  [31:0] d_ext32;
    input  [31:0] d_rfrs32;
    input  [31:0] d_btypc;
    input  [1:0]  npc_op;
    output reg [31:0] npc;

    always @(*) begin
        case (npc_op)
            2'b00 : npc <= pc + 4;
            2'b01 : npc <= d_btypc;
            2'b10 : npc <= {pc[31:28], d_ins26, 2'b00};
            2'b11 : npc <= d_rfrs32;
        endcase
    end
endmodule