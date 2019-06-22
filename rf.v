module rf( clk, rst, 
        rf_wr, wr_data, wr_reg,
        rd_data1, rd_reg1,
        rd_data2, rd_reg2 );
        
    reg [31:0] rg_fl[31:0];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rg_fl[0] = 0;
            rg_fl[1] = 0;
            rg_fl[2] = 0;
            rg_fl[3] = 0;
            rg_fl[4] = 0;
            rg_fl[5] = 0;
            rg_fl[6] = 0;
            rg_fl[7] = 0;
            rg_fl[8] = 0;
            rg_fl[9] = 0;
            rg_fl[10] = 0;
            rg_fl[11] = 0;
            rg_fl[12] = 0;
            rg_fl[13] = 0;
            rg_fl[14] = 0;
            rg_fl[15] = 0;
            rg_fl[16] = 0;
            rg_fl[17] = 0;
            rg_fl[18] = 0;
            rg_fl[19] = 0;
            rg_fl[20] = 0;
            rg_fl[21] = 0;
            rg_fl[22] = 0;
            rg_fl[23] = 0;
            rg_fl[24] = 0;
            rg_fl[25] = 0;
            rg_fl[26] = 0;
            rg_fl[27] = 0;
            rg_fl[28] = 32'h0000_1800;
            rg_fl[29] = 32'h0000_2ffc;
            rg_fl[30] = 0;
            rg_fl[31] = 0;
        end
        if (rf_wr) begin
            rg_fl[wr_reg] <= wr_data;
        end
    end

    assign rd_data1 = rg_fl[rd_reg1];
    assign rd_data2 = rg_fl[rd_reg2];

endmodule