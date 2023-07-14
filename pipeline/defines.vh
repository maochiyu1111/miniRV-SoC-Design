// Annotate this macro before synthesis
//`define RUN_TRACE

// TODO: 在此处定义你的宏
// npc_op
`define NPC_PC4   2'b0
`define NPC_new   2'b1

// sext_op
`define IMM_I   3'b000
`define IMM_S   3'b001
`define IMM_B   3'b010
`define IMM_U   3'b011
`define IMM_J   3'b100

//rf_we
`define WB_EN   1'b1
`define WB_DIS  1'b0

//rf_wsel
`define WB_ALU  2'b00
`define WB_MEM  2'b01
`define WB_PC4  2'b10
`define WB_IMM  2'b11

//alu_op
`define ADD   3'b000
`define SUB   3'b001
`define AND   3'b010
`define OR    3'b011
`define XOR   3'b100
`define SLL   3'b101
`define SRL   3'b110
`define SRA   3'b111

//br_op
`define BR_BEQ   3'b000
`define BR_BNE   3'b001
`define BR_BLT   3'b010
`define BR_BGE   3'b011
`define BR_NONE  3'b111 

//opcode
`define OPCODE_R     7'b0110011
`define OPCODE_I     7'b0010011
`define OPCODE_LW    7'b0000011
`define OPCODE_JALR  7'b1100111
`define OPCODE_S     7'b0100011
`define OPCODE_B     7'b1100011
`define OPCODE_U     7'b0110111
`define OPCODE_J     7'b1101111

//alub_sel
`define B_RD2  1'b0
`define B_EXT  1'b1


// 外设I/O接口电路的端口地址
`define PERI_ADDR_DIG   32'hFFFF_F000
`define PERI_ADDR_LED   32'hFFFF_F060
`define PERI_ADDR_SW    32'hFFFF_F070
`define PERI_ADDR_BTN   32'hFFFF_F078

//br_prediction
`define  STRONGLY_TAKEN       2'b11
`define  WEAKLY_TAKEN         2'b10
`define  WEAKLY_NOT_TAKEN     2'b01
`define  STRONGLY_NOT_TAKEN   2'b00

