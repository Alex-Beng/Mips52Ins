module mips( clk, rst );
    input clk;
    input rst;

    // exception part
    reg IntegerOverflow;
    // exception end

    // decode part
    wire  [31:0] ins;

    wire addu  = (ins[31:26] == 6'b00_0000 && ~ins[1])? 1:0;
    wire subu  = (ins[31:26] == 6'b00_0000 && ins[1])? 1:0;
    wire ori   = (ins[31:26] == 6'b00_1101)? 1:0;
    wire lw    = (ins[31:26] == 6'b10_0011)? 1:0;
    wire sw    = (ins[31:26] == 6'b10_1011)? 1:0;
    wire beq   = (ins[31:26] == 6'b00_0100)? 1:0;
    wire jal   = (ins[31:26] == 6'b00_0011)? 1:0;
    // decode end

    // fsm part
    reg [3:0] state;

    parameter   Fetch   = 4'b0000,
                Decode  = 4'b0001,
                AluExe  = 4'b0010,
                AluWrRf = 4'b0011,
                DmExe   = 4'b0100,
                DmSw    = 4'b0101,
                DmLw    = 4'b0110,
                DmWrRf  = 4'b0111,
                BeqExe  = 4'b1000,
                JalExe  = 4'b1001;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= Fetch;
        end
        else begin
            case (state)
                Fetch :  state <= Decode;
                Decode: begin
                    if (addu | subu | ori) begin
                        state <= AluExe;
                    end
                    else if (lw | sw) begin
                        state <= DmExe;
                    end
                    else if (beq) begin
                        state <= BeqExe;
                    end
                    else if (jal) begin
                        state <= JalExe;
                    end
                    else begin
                        state <= Fetch;
                    end
                end
                AluExe  : state <= AluWrRf;
                AluWrRf : state <= Fetch;
                DmExe   : begin
                    if (sw) begin
                        state <= DmSw;
                    end
                    else if (lw) begin
                        state <= DmLw;
                    end
                    else begin
                        state <= Fetch;
                    end
                end
                BeqExe : state <= Fetch;
                JalExe : state <= Fetch;
                DmSw   : state <= Fetch;
                DmLw   : state <= DmWrRf;
                DmWrRf : state <= Fetch;
                default: ;
            endcase
        end
    end
    // fsm end

    // control signal part
    wire alu_zero_flag;         // alu两个op相等flag

    reg rf_wr;                  // 寄存器写使能
    reg pc_wr;                  // 程序计数器写使能
    reg ir_wr;                  // 指令寄存器写使能
    reg dm_wr;                  // 数据存储器写使能
    reg alu_op2_sel;            // alu第二个操作数前的mux控制信号
    reg [1:0] rf_wr_addr_sel;   // rf的写地址前的mux控制信号
    reg [1:0] rf_wr_data_sel;   // rf的写数据前的mux控制信号
    reg [1:0] alu_op;           // alu计算的控制信号
    reg [1:0] npc_op;           // npc计算的控制信号

    always @(*) begin
        if (state == JalExe 
        ||  state == AluWrRf
        ||  state == DmLw
        ||  state == DmWrRf) begin
            rf_wr <= 1'b1;
        end
        else begin
            rf_wr <= 1'b0;
        end
    end

    always @(*) begin
        if (state == JalExe
        ||  state == Fetch
        ||  (state == BeqExe && alu_zero_flag)) begin
            pc_wr <= 1'b1;
        end
        else begin
            pc_wr <= 1'b0;
        end
    end

    always @(*) begin
        if (state == Fetch) begin
            ir_wr <= 1'b1;
        end
        else begin
            ir_wr <= 1'b0;
        end
    end

    always @(*) begin
        if (state == DmSw) begin
            dm_wr <= 1'b1;
        end
        else begin
            dm_wr <= 1'b0;
        end
    end
    
    always @(*) begin
        if (state == DmExe
        || (state == AluExe && ori) ) begin
            alu_op2_sel <= 1'b1;
        end
        else begin
            alu_op2_sel <= 1'b0;
        end
    end
    
    always @(*) begin   
    // rf_wr_addr_sel
    // 0-rd[15:11] 1-rt[20:16] 2-1F
        if (state == JalExe) begin
            rf_wr_addr_sel <= 2'b10;
        end
        else if (state == AluWrRf) begin
            if (ori) begin
                rf_wr_addr_sel <= 2'b01;
            end
            else begin
                rf_wr_addr_sel <= 1'b00;
            end
        end
        else if (state == DmWrRf) begin
            rf_wr_addr_sel <= 2'b01;
        end
        else begin
            rf_wr_addr_sel <= 2'bxx;
        end
    end

    always @(*) begin
    // rf_wr_data_sel
    // 0-alu_dout 1-dm_dout 2-pc
        if (state == AluWrRf) begin
            rf_wr_data_sel <= 2'b00;
        end
        else if (state == DmWrRf
              || state == DmLw) begin
            rf_wr_data_sel <= 2'b01;
        end
        else if (state == JalExe) begin
            rf_wr_data_sel <= 2'b10;
        end
        else begin
            rf_wr_data_sel <= 2'bxx;
        end
    end
    
    always @(*) begin
    // alu_op
    // 0+ 1-  2|
        if (state == AluExe) begin
            if (ori) begin
                alu_op <= 2'b10;
            end
            else if (addu) begin
                alu_op <= 2'b00;
            end
            else if (subu) begin
                alu_op <= 2'b01;
            end
        end
        else if (state == DmExe) begin
            alu_op <= 2'b00;
        end
        else if (state == BeqExe) begin
            alu_op <= 2'b01;
        end
        else begin
            alu_op <= 2'bxx;
        end
    end

    always @(*) begin
    // npc_op
    // 0-plus four 1-beq 2-jal
        if (state == BeqExe && alu_zero_flag) begin
            npc_op <= 2'b01;
        end
        else if (state == JalExe) begin
            npc_op <= 2'b10;
        end
        else begin
            npc_op <= 2'b00;
        end
    end
    // contral signal end

    // pc part
    wire [31:0] npc;
    wire [31:0] pc;

    pc U_PC(
        .clk(clk), .rst(rst), .pc_wr(pc_wr), .n_pc(npc), .pc(pc)
    );
    // pc end


    // npc part
    wire [31:0] imm_ext32;
    npc U_NPC(
        .pc(pc), .d_ins26(ins[25:0], .d_ext32(imm_ext32), .npc_op(npc_op), .npc(npc));
    );
    // npc end

    // im part
    wire [31:0] im_dout_ins;
    im U_IM(
        .addr(pc[11:2]), d_out(im_dout_ins)
    );
    // im end

    // ir part
    reg [31:0] ins_reg;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ins_reg <= 0;
        end
        else if (state == Fetch) begin
            ins_reg <= im_dout_ins;
        end
    end

    assign ins = ins_reg;
    // ir end

    // rf part
    reg [31:0] dm_dout_reg;     // dm 数据寄存器
    reg [31:0] alu_dout_reg;    // alu 数据寄存器
    
    reg [4:0]   rf_wr_addr;      
    reg [31:0]  rf_wr_data;
    wire [31:0] rf_rd_data1;
    wire [31:0] rf_rd_data2;
        // mux before rf addr
        always @(*) begin
            if (rf_wr_addr_sel == 2'b10) begin
                rf_wr_addr <= 5'h1F;
            end
            else if (rf_wr_addr_sel == 2'b00) begin
                rf_wr_addr <= ins[15:11]
            end
            else begin
                rf_wr_addr <= ins[20:16];
            end
        end
        // mux before rf addr end

        // mux before rf data 
        always @(*) begin
            if (rf_wr_data_sel == 2'b01) begin
                rf_wr_data <= dm_dout_reg;
            end
            else if (rf_wr_data_sel == 2'b10) begin
                rf_wr_data <= pc;
            end
            else begin
                rf_wr_data <= alu_dout_reg;
            end
        end
        // mux before rf data end
    rf U_RF(
        .clk(clk), .rst(rst),
        .rf_wr(rf_wr), .wr_data(rf_wr_data), .wr_reg(rf_wr_addr),
        .rd_data1(rf_rd_data1), rd_reg1(ins[25:21]),
        .rd_data2(rf_rd_data2), rd_reg2(ins[20:16])
    );

    reg [31:0] rf_rd_data1_reg;
    reg [31:0] rf_rd_data2_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rf_rd_data1_reg <= 0;
        end
        else begin
            rf_rd_data1_reg <= rf_rd_data1;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rf_rd_data2_reg <= 0;
        end
        else begin
            rf_rd_data2_reg <= rf_rd_data2;
        end
    end
    // rf end

    // alu part
    reg [31:0] alu_op1;
    reg [31:0] alu_op2;
    wire [31:0] alu_dout;
    wire alu_exp_overflow;

    always @(*) begin
        alu_op1 <= rf_rd_data1_reg;
    end

    always @(*) begin
        if (alu_op2_sel == 1'b1) begin
            alu_op2 <= imm_ext32;
        end
        else begin
            alu_op2 <= rf_rd_data2_reg;
        end
    end

    alu U_ALU(
        .data1(alu_op1), .data2(alu_op2), .alu_op(alu_op), .d_out(alu_dout) .zero_flag(alu_zero_flag), .EXP_overflow(alu_exp_overflow)
    );

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            alu_dout_reg <= 0;
        end
        else begin
            alu_dout_reg <= alu_dout;
        end
    end
    // alu end

    // ext part
    ext U_EXT(
        .d_in16(ins[15:0]) .d_out32(imm_ext32)
    );
    // ext end

    // dm part
    wire [31:0] dm_dout;
    dm U_DM(
        .clk(clk), .addr(rf_rd_data2_reg), .dm_wr(dm_wr), .d_in(alu_dout_reg), .d_out(dm_dout)
    );

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            dm_dout_reg <= 0;
        end
        else begin
            dm_dout_reg <= dm_dout;
        end
    end
    // dm end
endmodule