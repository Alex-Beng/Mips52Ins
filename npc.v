module npc( pc, d_ins26, d_ext32, npc_op, npc );
    input  [31:0] pc;
    input  [25:0] d_ins26;
    input  [31:0] d_ext32;
    input  [1:0]  npc_op;
    output reg [31:0] npc;

    always @(*) begin
        case (npc_op)
            2'b00: npc <= pc + 4;
            2'b01: npc <= pc + 4 + {d_ext32[29:0], 2'b00};
            2'b10: npc <= {pc[31:28], d_ins26, 2'b00};
        endcase
    end
endmodule