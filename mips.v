module mips( clk, rst, 
             IntegerOverflow);
    input clk;
    input rst;
    output IntegerOverflow;

    // exception part
    reg IntegerOverflow;

    wire alu_exp_overflow;

    // exception end

    // decode part
    wire  [31:0] ins;

    wire add    = ( ins[31:26] == 6'b00_0000 && ins[10:6] == 5'b00_000 && ins[5:0] == 6'b100_000 )? 1:0;
    wire addi   = ( ins[31:26] == 6'b00_1000)? 1:0;
    wire addu   = ( ins[31:26] == 6'b00_0000 && ins[10:6] == 5'b00_000 && ins[5:0] == 6'b100_001 )? 1:0;            
    wire addiu  = ( ins[31:26] == 6'b00_1001)? 1:0;

    wire sub    = ( ins[31:26] == 6'b00_0000 && ins[10:6] == 5'b00_000 && ins[5:0] == 6'b100_010 )? 1:0;
    wire subu   = ( ins[31:26] == 6'b00_0000 && ins[10:6] == 5'b00_000 && ins[5:0] == 6'b100_011)? 1:0;

    wire slt    = ( ins[31:26] == 6'b00_0000 && ins[10:6] == 5'b00_000 && ins[5:0] == 6'b101_010)? 1:0;
    wire slti   = ( ins[31:26] == 6'b00_1010)? 1:0;
    wire sltu   = ( ins[31:26] == 6'b00_0000 && ins[10:6] == 5'b00_000 && ins[5:0] == 6'b101_011)? 1:0;
    wire sltiu  = ( ins[31:26] == 6'b00_1011)? 1:0;

    wire div    = ( ins[31:26] == 6'b00_0000 && ins[15:6]  == 10'b0_000_000_000 && ins[5:0] == 6'b011_010)? 1:0;
    wire divu   = ( ins[31:26] == 6'b00_0000 && ins[15:6]  == 10'b0_000_000_000 && ins[5:0] == 6'b011_011)? 1:0;

    wire mult   = ( ins[31:26] == 6'b00_0000 && ins[15:6]  == 10'b0_000_000_000 && ins[5:0] == 6'b011_000)? 1:0;
    wire multu  = ( ins[31:26] == 6'b00_0000 && ins[15:6]  == 10'b0_000_000_000 && ins[5:0] == 6'b011_001)? 1:0;

    wire annd   = ( ins[31:26] == 6'b00_0000 && ins[10:6] == 5'b00_000 && ins[5:0] == 6'b100_100 )? 1:0;
    wire anndi  = ( ins[31:26] == 6'b00_1100)? 1:0;

    wire lui    = ( ins[31:26] == 6'b00_1111 && ins[25:21] == 5'b00_000)? 1:0;

    wire noor   = ( ins[31:26] == 6'b00_0000 && ins[10:6] == 5'b00_000 && ins[5:0] == 6'b100_111 )? 1:0;

    wire oor    = ( ins[31:26] == 6'b00_0000 && ins[10:6] == 5'b00_000 && ins[5:0] == 6'b100_101 )? 1:0;

    wire ori    = ( ins[31:26] == 6'b00_1101)? 1:0;

    wire xoor   = ( ins[31:26] == 6'b00_0000 && ins[10:6] == 5'b00_000 && ins[5:0] == 6'b100_110 )? 1:0;

    wire xori   = ( ins[31:26] == 6'b00_1110)? 1:0;

    wire sllv   = ( ins[31:26] == 6'b00_0000 && ins[10:6]  == 5'b00_000 && ins[5:0] == 6'b000_100 )? 1:0;
    wire sll    = ( ins[31:26] == 6'b00_0000 && ins[25:21] == 5'b00_000 && ins[5:0] == 6'b000_000 )? 1:0;
    wire srav   = ( ins[31:26] == 6'b00_0000 && ins[10:6]  == 5'b00_000 && ins[5:0] == 6'b000_111 )? 1:0;
    wire sra    = ( ins[31:26] == 6'b00_0000 && ins[25:21] == 5'b00_000 && ins[5:0] == 6'b000_011 )? 1:0;
    wire srlv   = ( ins[31:26] == 6'b00_0000 && ins[10:6]  == 5'b00_000 && ins[5:0] == 6'b000_110 )? 1:0;
    wire srl    = ( ins[31:26] == 6'b00_0000 && ins[25:21] == 5'b00_000 && ins[5:0] == 6'b000_010 )? 1:0;

    wire beq    = ( ins[31:26] == 6'b00_0100)? 1:0;
    wire bne    = ( ins[31:26] == 6'b00_0101)? 1:0;
    wire bnez   = ( ins[31:26] == 6'b00_0001 && ins[20:16] == 5'b00_001)? 1:0;
    wire bgtz   = ( ins[31:26] == 6'b00_0111 && ins[20:16] == 5'b00_000)? 1:0;
    wire blez   = ( ins[31:26] == 6'b00_0110 && ins[20:16] == 5'b00_000)? 1:0;
    wire bltz   = ( ins[31:26] == 6'b00_0001 && ins[20:16] == 5'b00_000)? 1:0;
    wire bgezal = ( ins[31:26] == 6'b00_0001 && ins[20:16] == 5'b10_001)? 1:0;
    wire bltzal = ( ins[31:26] == 6'b00_0001 && ins[20:16] == 5'b10_000)? 1:0;

    wire j      = ( ins[31:26] == 6'b00_0010)? 1:0;
    wire jal    = ( ins[31:26] == 6'b00_0011)? 1:0;
    wire jr     = ( ins[31:26] == 6'b00_0000 && ins[20:6]  == 15'b000_000_000_000_000 && ins[5:0] == 6'b001_000)? 1:0;
    wire jalr   = ( ins[31:26] == 6'b00_0000 && ins[20:16] == 5'b00_000 && ins[10:6] == 5'b00_000 && ins[5:0] == 6'b001_001)? 1:0;

    wire mfhi   = ( ins[31:26] == 6'b00_0000 && ins[25:16] == 10'b0_000_000_000 && ins[10:6] == 5'b00_000 && ins[5:0] == 6'b010_000)? 1:0;
    wire mflo   = ( ins[31:26] == 6'b00_0000 && ins[25:16] == 10'b0_000_000_000 && ins[10:6] == 5'b00_000 && ins[5:0] == 6'b010_010)? 1:0;
    wire mthi   = ( ins[31:26] == 6'b00_0000 && ins[20:6]  == 15'b000_000_000_000_000  && ins[5:0] == 6'b010_001)? 1:0;
    wire mtlo   = ( ins[31:26] == 6'b00_0000 && ins[20:6]  == 15'b000_000_000_000_000  && ins[5:0] == 6'b010_011)? 1:0;

    wire lb     = ( ins[31:26] == 6'b10_0000)? 1:0;
    wire lbu    = ( ins[31:26] == 6'b10_0100)? 1:0;
    wire lh     = ( ins[31:26] == 6'b10_0001)? 1:0;
    wire lhu    = ( ins[31:26] == 6'b10_0101)? 1:0;
    wire lw     = ( ins[31:26] == 6'b10_0011)? 1:0;

    wire sb     = ( ins[31:26] == 6'b10_1000)? 1:0;
    wire sh     = ( ins[31:26] == 6'b10_1001)? 1:0;
    wire sw     = ( ins[31:26] == 6'b10_1011)? 1:0;
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
                JalExe  = 4'b1001,
                LuiWrRf = 4'b1010;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= Fetch;
        end
        else begin
            case (state)
                Fetch :  state <= Decode;
                Decode: begin
                    if ( add  | addi  | addu | addiu
                    |    sub  | subu 
                    |    slt  | slti  | sltu | sltiu
                    |    annd | anndi 
                    |    noor 
                    |    oor  | ori) begin
                        state <= AluExe;
                    end
                    else if (lui) begin
                        state <= LuiWrRf;
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
                LuiWrRf : state <= Fetch;
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
    reg [2:0] alu_op;           // alu计算的控制信号
    reg [1:0] npc_op;           // npc计算的控制信号
    reg [1:0] ext_op;           // ext计算的控制信号

    always @(*) begin
        if (state == JalExe 
        ||  state == AluWrRf
        ||  state == DmWrRf
        ||  state == LuiWrRf) begin
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
    // 1-立即数 0-寄存器data2
        if (state == DmExe) begin
            alu_op2_sel <= 1'b1;
        end
        else if (state == AluExe) begin
            if (addi  | addiu 
            |   slti  | sltiu
            |   anndi
            |   ori ) begin
                alu_op2_sel <= 1'b1;
            end
            else begin
                alu_op2_sel <= 1'b0;
            end
        end
        else if (state == BeqExe) begin
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
            if (addi  | addiu
            |   slti  | sltiu
            |   anndi
            |   lui
            |   ori) begin
                rf_wr_addr_sel <= 2'b01;
            end
            else begin
                rf_wr_addr_sel <= 2'b00;
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
    // 0->alu_dout 1->dm_dout 2->pc 3->imm_ext32
        if (state == AluWrRf) begin
            rf_wr_data_sel <= 2'b00;
        end
        else if (state == DmWrRf) begin
            rf_wr_data_sel <= 2'b01;
        end
        else if (state == JalExe) begin
            rf_wr_data_sel <= 2'b10;
        end
        else if (state == LuiWrRf) begin
            rf_wr_data_sel <= 2'b11;
        end
        else begin
            rf_wr_data_sel <= 2'bxx;
        end
    end
    
    always @(*) begin
    // alu_op
    // 0-plus 1-minus  2-or 3-sign-compare(op1<op2高有效)
    // 4-unsign-compare 
    // 5-and
    // 6-nor
        if (state == AluExe) begin
            if (oor | ori) begin
                alu_op <= 3'b010;
            end
            else if (add | addu | addi | addiu) begin
                alu_op <= 3'b000;
            end
            else if (sub | subu) begin
                alu_op <= 3'b001;
            end
            else if (slt | slti) begin
                alu_op <= 3'b011;
            end
            else if (sltu | sltiu) begin
                alu_op <= 3'b100; 
            end
            else if (annd | anndi) begin
                alu_op <= 3'b101;
            end
            else if (noor) begin
                alu_op <= 3'b110;
            end
        end
        else if (state == DmExe) begin
            alu_op <= 3'b000;
        end
        else if (state == BeqExe) begin
            alu_op <= 3'b001;
        end
        else begin
            alu_op <= 3'bxxx;
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

    always @(*) begin
    // ext_op
    // 0->unsign ext 1->sign ext 
    // 2->0-tail ext
        if (state == AluExe) begin
            if (anndi | ori) begin
                ext_op <= 2'b00;
            end
            else begin
                ext_op <= 2'b01;
            end
        end
        if (state == LuiWrRf) begin
            ext_op <= 2'b10;
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
        .pc(pc), .d_ins26(ins[25:0]), .d_ext32(imm_ext32), .npc_op(npc_op), .npc(npc)
    );
    // npc end

    // im part
    wire [31:0] im_dout_ins;
    im U_IM(
        .addr(pc[11:2]), .d_out(im_dout_ins)
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
                rf_wr_addr <= ins[15:11];
            end
            else begin
                rf_wr_addr <= ins[20:16];
            end
        end
        // mux before rf addr end

        // mux before rf data 
        always @(*) begin
            if (rf_wr_data_sel == 2'b00) begin
                rf_wr_data <= alu_dout_reg;
            end
            else if (rf_wr_data_sel == 2'b01) begin
                rf_wr_data <= dm_dout_reg;
            end
            else if (rf_wr_data_sel == 2'b10) begin
                rf_wr_data <= pc;
            end
            else if (rf_wr_data_sel == 2'b11) begin
                rf_wr_data <= imm_ext32;
            end
        end
        // mux before rf data end
    rf U_RF(
        .clk(clk), .rst(rst),
        .rf_wr(rf_wr), .wr_data(rf_wr_data), .wr_reg(rf_wr_addr),
        .rd_data1(rf_rd_data1), .rd_reg1(ins[25:21]),
        .rd_data2(rf_rd_data2), .rd_reg2(ins[20:16])
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
        .data1(alu_op1), .data2(alu_op2), .alu_op(alu_op), .d_out(alu_dout), .zero_flag(alu_zero_flag), .EXP_overflow(alu_exp_overflow)
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
        .d_in16(ins[15:0]), .d_out32(imm_ext32), .ext_op(ext_op)
    );
    // ext end

    // dm part
    wire [31:0] dm_dout;
    dm U_DM(
        .clk(clk), .d_in(rf_rd_data2_reg), .dm_wr(dm_wr), .addr(alu_dout_reg[11:2]), .d_out(dm_dout)
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

    // exp part
    always @(*) begin
        if (add | addi 
        |sub) begin
            if (alu_exp_overflow) begin
                IntegerOverflow <= 1'b1;
            end 
        end
        else begin
            IntegerOverflow <= 1'b0;
        end
    end

    // exp end
endmodule