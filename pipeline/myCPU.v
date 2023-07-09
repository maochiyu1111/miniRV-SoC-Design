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

    // TODO: 完成你自己的单周期CPU设计
    wire [31:0] npc_out;
    wire [31:0] pc_out;
    wire [31:0] pc4;

    wire [2:0] sext_op;
    wire [1:0] npc_op;
    wire ram_we;
    wire [2:0] alu_op;
    wire alub_sel;
    wire rf_we;
    wire [1:0] rf_wsel;
    wire [2:0] br_op;

    wire [31:0] ALU_C;
    wire ALU_F;
    wire [31:0] B;

    wire [31:0] ext;
    wire [24:0] sext_din = inst[31:7];

    wire [4:0] rR1 = inst[19:15];
    wire [4:0] rR2 = inst[24:20];
    wire [4:0] wR  = inst[11:7];
    wire [31:0] wD;
    wire [31:0] rD1;
    wire [31:0] rD2;

`ifdef RUN_TRACE
    //dram interface
    wire [31:0] rdo = ram_rdata;
    assign ram_addr = ALU_C;
    assign ram_wen = ram_we;
    assign ram_wdata = rD2;


    //irom interface
    assign inst_addr = pc_out[17:2]; 

`else 
    //bridge interface
    wire [31:0] rdo = Bus_rdata;
    assign Bus_addr = ALU_C;
    assign Bus_wen = ram_we;
    assign Bus_wdata = rD2;

    //irom interface
    assign inst_addr = pc_out[15:2]; 
`endif 

    PC pc_inst (
        .cpu_rst(cpu_rst),
        .cpu_clk(cpu_clk),
        .din(npc_out),
        .pc(pc_out)
    );

    NPC npc_inst (
        .pc(pc_out),
        .op(npc_op),
        .baseadr(rD1),
        .offset(ext),
        .br(ALU_F),
        .npc(npc_out),
        .pc4(pc4)
    );

    // Instantiate the SEXT module
    SEXT sext_inst (
        .op(sext_op),
        .din(sext_din),
        .ext(ext)
    );


    // Instantiate the RF module
    RF rf_inst (
        .cpu_clk(cpu_clk),
        .cpu_rst(cpu_rst),
        .rR1(rR1),
        .rR2(rR2),
        .wR(wR),
        .we(rf_we),
        .wD(wD),
        .rD1(rD1),
        .rD2(rD2)
    );

    // Instantiate the RF_MUX module
    RF_MUX rf_mux_inst (
        .rf_wsel(rf_wsel),
        .pc4(pc4),
        .ext(ext),
        .ALU_C(ALU_C),
        .rdo(rdo),
        .wD(wD)
    );



    // Instantiate the ALU module
    ALU alu_inst (
        .A(rD1),
        .B(B),
        .alu_op(alu_op),
        .br_op(br_op),
        .ALU_C(ALU_C),
        .ALU_F(ALU_F)
    );

    // Instantiate the ALUB_MUX module
    ALUB_MUX alub_mux_inst (
        .alub_sel(alub_sel),
        .rD2(rD2),
        .ext(ext),
        .B(B)
    );


    // Instantiate the Controller module
    Controller controller_inst (
        .inst(inst),
        .sext_op(sext_op),
        .npc_op(npc_op),
        .ram_we(ram_we),
        .alu_op(alu_op),
        .alub_sel(alub_sel),
        .rf_we(rf_we),
        .rf_wsel(rf_wsel),
        .br_op(br_op)
    );


`ifdef RUN_TRACE
    // Debug Interface
    always @(posedge cpu_clk) begin
        debug_wb_have_inst <= 1'b1 ;
        debug_wb_pc        <= pc_out ;
        debug_wb_ena       <= rf_we ;
        debug_wb_reg       <= inst[11:7] ;
        debug_wb_value     <= wD;
    end
`endif

endmodule
