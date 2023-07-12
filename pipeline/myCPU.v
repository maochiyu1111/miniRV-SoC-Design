`timescale 1ns / 1ps

`include "defines.vh"

module myCPU (
    input  wire         cpu_rst,
    input  wire         cpu_clk,

    // Interface to IROM
    output wire [15:0]  inst_addr,
    input  wire [31:0]  inst
    

`ifdef RUN_TRACE
    ,
    // Interface to DRAM
    output wire [31:0] ram_addr,
    input  wire [31:0] ram_rdata,
    output wire        ram_wen,
    output wire [31:0] ram_wdata,

    // Debug Interface
    output reg         debug_wb_have_inst,
    output reg [31:0]  debug_wb_pc,
    output reg         debug_wb_ena,
    output reg [ 4:0]  debug_wb_reg,
    output reg [31:0]  debug_wb_value

`else
    ,
    //Interface to Bridge
    output wire [31:0]  Bus_addr,
    input  wire [31:0]  Bus_rdata,
    output wire         Bus_wen,
    output wire [31:0]  Bus_wdata

`endif
);

    //interface between functional parts
    wire [31:0] npc_IF_out;
    wire [31:0] pc_IF_out;

    wire [2:0] sext_op_ID_out;
    wire [31:0] B_EX_out;
    //wire [1:0] npc_op_ID_out;

    wire [24:0] sext_din_ID_in = inst_ID_in[31:7];

    wire [4:0] rR1_ID_in = inst_ID_in[19:15];
    wire [4:0] rR2_ID_in = inst_ID_in[24:20];
    wire [4:0] wR_ID_in  = inst_ID_in[11:7];

    wire ALU_F_EX_out;

    //controller to data hazard
    wire rR1_read;
    wire rR2_read;

    //data hazard detection unit output 
    wire RAW_A_rR1;
    wire RAW_A_rR2;
    wire RAW_B_rR1;
    wire RAW_B_rR2;
    wire RAW_C_rR1;
    wire RAW_C_rR2;
    wire nop_data;

    // forwarding unit output
    wire forward_en_rD1;
    wire forward_en_rD2;
    wire [31:0] forward_rD1;
    wire [31:0] forward_rD2;

    // control hazard
    wire pre_br;
    wire [31:0] br_pc;
    wire Flush_B;

    //jump related
    wire Flush_jump;
    wire B_jump;

    //NPCsel to NPC
    wire npc_op;
    wire [31:0] new_pc;


`ifdef RUN_TRACE
    //dram interface
    wire [31:0] rdo_MEM_out = ram_rdata;
    assign ram_addr = ALU_C_MEM_in;
    assign ram_wen = ram_we_MEM_in;
    assign ram_wdata = rD2_MEM_in;


    //irom interface
    assign inst_addr = pc_IF_out[17:2]; 

`else 
    //bridge interface
    wire [31:0] rdo_MEM_out = Bus_rdata;
    assign Bus_addr = ALU_C_MEM_in;
    assign Bus_wen = ram_we_MEM_in;
    assign Bus_wdata = rD2_MEM_in;

    //irom interface
    assign inst_addr = pc_IF_out[17:2]; 
`endif 

/*  pipeline registers interface  */

    // IF/ID
    wire [31:0] pc4_IF_out;
    wire [31:0] pc4_ID_in; 
    
    wire [31:0] inst_ID_in;

    // ID/EX
    wire [31:0] ext_ID_out;
    wire [31:0] ext_EX_in;

    wire [31:0] pc4_ID_out = pc4_ID_in;
    wire [31:0] pc4_EX_in;

    wire [4:0] wR_ID_out = wR_ID_in;
    wire [4:0] wR_EX_in;

    wire ram_we_ID_out;
    wire ram_we_EX_in;

    wire [2:0] alu_op_ID_out;
    wire [2:0] alu_op_EX_in;

    wire alub_sel_ID_out;
    wire alub_sel_EX_in;

    wire [1:0] rf_wsel_ID_out;
    wire [1:0] rf_wsel_EX_in;

    wire rf_we_ID_out;
    wire rf_we_EX_in;

    wire [2:0] br_op_ID_out;
    wire [2:0] br_op_EX_in;

    wire [31:0] rD1_ID_out;
    wire [31:0] rD1_EX_in;


    wire [31:0] rD2_ID_out;
    wire [31:0] rD2_EX_in;

    wire is_load_ID_out;
    wire is_load_EX_in;

    wire is_B_ID_out;
    wire is_B_EX_in;



    // EX/MEM
    wire [31:0] ext_EX_out = ext_EX_in;
    wire [31:0] ext_MEM_in;

    wire [31:0] pc4_EX_out = pc4_EX_in;
    wire [31:0] pc4_MEM_in;

    wire [4:0] wR_EX_out = wR_EX_in;
    wire [4:0] wR_MEM_in;

    wire ram_we_EX_out = ram_we_EX_in;
    wire ram_we_MEM_in;

    wire [1:0] rf_wsel_EX_out = rf_wsel_EX_in;
    wire [1:0] rf_wsel_MEM_in;

    wire rf_we_EX_out = rf_we_EX_in;
    wire rf_we_MEM_in;

    wire [31:0] rD2_EX_out = rD2_EX_in;
    wire [31:0] rD2_MEM_in;

    wire [31:0] ALU_C_EX_out;
    wire [31:0] ALU_C_MEM_in; 

    // MEM/WB

    wire [4:0] wR_MEM_out = wR_MEM_in;
    wire [4:0] wR_WB_in;


    wire rf_we_MEM_out = rf_we_MEM_in;
    wire rf_we_WB_in;

    wire [31:0] wD_MEM_out;
    wire [31:0] wD_WB_in; 

    wire [31:0] pc_ID_in;

    wire [31:0] pc_ID_out = pc_ID_in;
    wire [31:0] pc_EX_in;

    wire [31:0] pc_EX_out = pc_EX_in;
    wire [31:0] pc_MEM_in;

    wire [31:0] pc_MEM_out = pc_MEM_in;
    wire [31:0] pc_WB_in;


`ifdef RUN_TRACE


    wire inst_valid_ID_in;

    wire inst_valid_ID_out = inst_valid_ID_in;
    wire inst_valid_EX_in;

    wire inst_valid_EX_out = inst_valid_EX_in;
    wire inst_valid_MEM_in;

    wire inst_valid_MEM_out = inst_valid_MEM_in;
    wire inst_valid_WB_in;


`endif

/* 实例化 */

    // data hazard detection unit 
    DHDU data_hazard_detection_unit (
        .is_load(is_load_EX_in),

        .rR1_read(rR1_read),
        .rR2_read(rR2_read),

        .rR1_ID_in(rR1_ID_in),
        .rR2_ID_in(rR2_ID_in),

        .rf_we_EX_in(rf_we_EX_in),
        .rf_we_MEM_in(rf_we_MEM_in),
        .rf_we_WB_in(rf_we_WB_in),

        .wR_EX_in(wR_EX_in),
        .wR_MEM_in(wR_MEM_in),
        .wR_WB_in(wR_WB_in),

        .RAW_A_rR1(RAW_A_rR1),
        .RAW_A_rR2(RAW_A_rR2),
        .RAW_B_rR1(RAW_B_rR1),
        .RAW_B_rR2(RAW_B_rR2),
        .RAW_C_rR1(RAW_C_rR1),
        .RAW_C_rR2(RAW_C_rR2),
        .nop_data(nop_data)
    );

    //forwarding unit
    ForwardU forwarding_unit (
        .RAW_A_rR1(RAW_A_rR1),
        .RAW_A_rR2(RAW_A_rR2),
        .RAW_B_rR1(RAW_B_rR1),
        .RAW_B_rR2(RAW_B_rR2),
        .RAW_C_rR1(RAW_C_rR1),
        .RAW_C_rR2(RAW_C_rR2),

        .ALU_C_EX_out(ALU_C_EX_out),
        .ext_EX_out(ext_EX_out),
        .pc4_EX_out(pc4_EX_out),
        .rf_wsel_EX_out(rf_wsel_EX_out),

        .wD_MEM_out(wD_MEM_out),
        .wD_WB_in(wD_WB_in),

        .forward_en_rD1(forward_en_rD1),
        .forward_en_rD2(forward_en_rD2),
        .forward_rD1(forward_rD1),
        .forward_rD2(forward_rD2)
    );

    //branch predictor
    Br_Predictor br_predictor_inst (
        .cpu_rst(cpu_rst),
        .cpu_clk(cpu_clk),
        .is_B(is_B_EX_in),
        .real_br(ALU_F_EX_out),
        .pre_br(pre_br)
    );

    // branch misprediction handling unit
    BMHU bmhu_inst (
        .cpu_rst(cpu_rst),
        .cpu_clk(cpu_clk),

        .is_B(is_B_EX_in),
        .real_br(ALU_F_EX_out),
        .pre_br(pre_br),

        .pc_EX_out(pc_EX_out),
        .pc4_EX_out(pc4_EX_out),
        .ext_EX_out(ext_EX_out),

        .Flush_B(Flush_B),
        .br_pc(br_pc)
    );


    JumpDU jump_detection_unit (
        .is_jal(is_jal),
        .is_jalr(is_jalr),
        .is_B(is_B_ID_out),
        .pre_br(pre_br),
        .Flush_jump(Flush_jump),
        .B_jump(B_jump)
    );

    NPC_Sel npc_select (
        .is_jal(is_jal),
        .is_jalr(is_jalr),
        .Flush_B(Flush_B),
        .B_jump(B_jump),

        .br_pc(br_pc),
        .pc_ID_in(pc_ID_in),
        .ext_ID_out(ext_ID_out),
        .rD1_ID_out(rD1_ID_out),
        .forward_en_rD1(forward_en_rD1),
        .forward_rD1(forward_rD1),

        .new_pc(new_pc),
        .npc_op(npc_op)
    );

/* IF */

    PC pc_inst (
        .cpu_rst(cpu_rst),
        .cpu_clk(cpu_clk),
        .din(npc_IF_out),
        .nop_data(nop_data),

        .pc(pc_IF_out)
    );

    NPC npc_inst (

        .pc(pc_IF_out),
        .op(npc_op),
        .new_pc(new_pc),

        .npc(npc_IF_out),
        .pc4(pc4_IF_out)
    );


/* IF/ID */
    REG_IF_ID reg_if_id (
        .cpu_rst(cpu_rst),  
        .cpu_clk(cpu_clk),

        .pc4_IF_out(pc4_IF_out),
        .pc4_ID_in(pc4_ID_in),

        .inst_IF_out(inst),
        .inst_ID_in(inst_ID_in),

        .pc_IF_out(pc_IF_out),
        .pc_ID_in(pc_ID_in),

        .nop_data(nop_data),
        .Flush_B(Flush_B),
        .Flush_jump(Flush_jump)

`ifdef RUN_TRACE
        ,
        .inst_valid_ID_in(inst_valid_ID_in)

`endif 
    );


/* ID */
    // Instantiate the SEXT module
    SEXT sext_inst (
        .op(sext_op_ID_out),
        .din(sext_din_ID_in),
        .ext(ext_ID_out)
    );


    // Instantiate the RF module
    RF rf_inst (
        .cpu_clk(cpu_clk),
        .cpu_rst(cpu_rst),
        .rR1(rR1_ID_in),
        .rR2(rR2_ID_in),
        .wR(wR_WB_in),
        .we(rf_we_WB_in),
        .wD(wD_WB_in),
        .rD1(rD1_ID_out),
        .rD2(rD2_ID_out)
    );

    // Instantiate the Controller module
    Controller controller_inst (
        .inst(inst_ID_in),
        .sext_op(sext_op_ID_out),
        //.npc_op(npc_op_ID_out),
        .ram_we(ram_we_ID_out),
        .alu_op(alu_op_ID_out),
        .alub_sel(alub_sel_ID_out),
        .rf_we(rf_we_ID_out),
        .rf_wsel(rf_wsel_ID_out),
        .br_op(br_op_ID_out),
        .rR1_read(rR1_read),
        .rR2_read(rR2_read),
        .is_load(is_load_ID_out),
        .is_B(is_B_ID_out),
        .is_jal(is_jal),
        .is_jalr(is_jalr)
    );



/* ID/EX */
    REG_ID_EX reg_id_ex (
        .cpu_rst(cpu_rst),  // 输入信号
        .cpu_clk(cpu_clk),

        .ext_ID_out(ext_ID_out),
        .ext_EX_in(ext_EX_in),

        .pc4_ID_out(pc4_ID_out),
        .pc4_EX_in(pc4_EX_in),

        .wR_ID_out(wR_ID_out),
        .wR_EX_in(wR_EX_in),

        .ram_we_ID_out(ram_we_ID_out),
        .ram_we_EX_in(ram_we_EX_in),

        .alu_op_ID_out(alu_op_ID_out),
        .alu_op_EX_in(alu_op_EX_in),

        .alub_sel_ID_out(alub_sel_ID_out),
        .alub_sel_EX_in(alub_sel_EX_in),

        .rf_wsel_ID_out(rf_wsel_ID_out),
        .rf_wsel_EX_in(rf_wsel_EX_in),

        .rf_we_ID_out(rf_we_ID_out),
        .rf_we_EX_in(rf_we_EX_in),

        .br_op_ID_out(br_op_ID_out),
        .br_op_EX_in(br_op_EX_in),

        .rD1_ID_out(rD1_ID_out),
        .rD1_EX_in(rD1_EX_in),

        .rD2_ID_out(rD2_ID_out),
        .rD2_EX_in(rD2_EX_in),

        .forward_en_rD1(forward_en_rD1),
        .forward_en_rD2(forward_en_rD2),

        .forward_rD1(forward_rD1),
        .forward_rD2(forward_rD2),

        .is_load_ID_out(is_load_ID_out),
        .is_load_EX_in(is_load_EX_in),

        .is_B_ID_out(is_B_ID_out),
        .is_B_EX_in(is_B_EX_in),

        .pc_ID_out(pc_ID_out),
        .pc_EX_in(pc_EX_in),

        .nop_data(nop_data),
        .Flush_B(Flush_B)

`ifdef RUN_TRACE
        ,
        .inst_valid_ID_out(inst_valid_ID_out),
        .inst_valid_EX_in(inst_valid_EX_in)

`endif
    );






/* EX */


    // Instantiate the ALUB_MUX module
    ALUB_MUX alub_mux_inst (
        .alub_sel(alub_sel_EX_in),
        .rD2(rD2_EX_in),
        .ext(ext_EX_in),
        .B(B_EX_out)
    );

    // Instantiate the ALU module
    ALU alu_inst (
        .A(rD1_EX_in),
        .B(B_EX_out),
        .alu_op(alu_op_EX_in),
        .br_op(br_op_EX_in),
        .ALU_C(ALU_C_EX_out),
        .ALU_F(ALU_F_EX_out)
    );



/* EX/MEM */
    
    REG_EX_MEM reg_ex_mem (
    .cpu_rst(cpu_rst),
    .cpu_clk(cpu_clk),

    .ext_EX_out(ext_EX_out),
    .ext_MEM_in(ext_MEM_in),

    .pc4_EX_out(pc4_EX_out),
    .pc4_MEM_in(pc4_MEM_in),

    .wR_EX_out(wR_EX_out),
    .wR_MEM_in(wR_MEM_in),

    .ram_we_EX_out(ram_we_EX_out),
    .ram_we_MEM_in(ram_we_MEM_in),

    .rf_wsel_EX_out(rf_wsel_EX_out),
    .rf_wsel_MEM_in(rf_wsel_MEM_in),

    .rf_we_EX_out(rf_we_EX_out),
    .rf_we_MEM_in(rf_we_MEM_in),

    .rD2_EX_out(rD2_EX_out),
    .rD2_MEM_in(rD2_MEM_in),

    .ALU_C_EX_out(ALU_C_EX_out),
    .ALU_C_MEM_in(ALU_C_MEM_in),

    .pc_EX_out(pc_EX_out),
    .pc_MEM_in(pc_MEM_in)

`ifdef RUN_TRACE
    ,
    .inst_valid_EX_out(inst_valid_EX_out),
    .inst_valid_MEM_in(inst_valid_MEM_in)

`endif 

    );



/* MEM */
//DRAM IP
    RF_MUX rf_mux_inst (
        .rf_wsel(rf_wsel_MEM_in),
        .pc4(pc4_MEM_in),
        .ext(ext_MEM_in),
        .ALU_C(ALU_C_MEM_in),
        .rdo(rdo_MEM_out),
        .wD(wD_MEM_out)
    );

/* MEM/WB */
    REG_MEM_WB reg_mem_wb (
    .cpu_rst(cpu_rst),
    .cpu_clk(cpu_clk),

    .wR_MEM_out(wR_MEM_out),
    .wR_WB_in(wR_WB_in),

    .rf_we_MEM_out(rf_we_MEM_out),
    .rf_we_WB_in(rf_we_WB_in),

    .wD_MEM_out(wD_MEM_out),
    .wD_WB_in(wD_WB_in),

    .pc_MEM_out(pc_MEM_out),
    .pc_WB_in(pc_WB_in)


`ifdef RUN_TRACE
    ,
    .inst_valid_MEM_out(inst_valid_MEM_out),
    .inst_valid_WB_in(inst_valid_WB_in)
`endif 

);


/* WB */
    // Instantiate the RF_MUX module
    //regfile writeback

`ifdef RUN_TRACE
    // Debug Interface
    always @(posedge cpu_clk) begin
        debug_wb_have_inst <= inst_valid_WB_in ;
        debug_wb_pc        <= pc_WB_in ;
        debug_wb_ena       <= rf_we_WB_in ;
        debug_wb_reg       <= wR_WB_in ;
        debug_wb_value     <= wD_WB_in;
    end
`endif

endmodule
