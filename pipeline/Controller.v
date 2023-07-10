`include "defines.vh"

module Controller (
   input  wire [31:0] inst,

   output wire [ 2:0] sext_op,
   output wire [ 1:0] npc_op,
   output wire        ram_we,
   output wire [ 2:0] alu_op,
   output wire        alub_sel,
   output wire        rf_we,
   output wire [ 1:0] rf_wsel,
   output wire [ 2:0] br_op,

   //hazard
   output wire        rR1_read,
   output wire        rR2_read,
   output wire        is_load,
   output wire        is_B
   
);

   assign rR1_read = ~ ((opcode == `OPCODE_U) || (opcode == `OPCODE_J));
   assign rR2_read = ((opcode == `OPCODE_B) || (opcode == `OPCODE_S) || (opcode == `OPCODE_R));
   assign is_load = (opcode == `OPCODE_LW);
   assign is_B = (opcode == `OPCODE_B);

   wire [6:0] opcode = inst[6:0];
   wire [2:0] funct3 = inst[14:12];
   wire [6:0] funct7 = inst[31:25];

   reg [16:0] ctrl_info;

   always @(*) begin
      case (opcode)
         `OPCODE_R:
            case (funct3)
               3'b000:
                  case (funct7)
                     7'b0000000: ctrl_info = 16'b111_00_0_000_0_1_00_111;     //add
                     7'b0100000: ctrl_info = 16'b111_00_0_001_0_1_00_111;     //sub
                     default:    ctrl_info = 16'b111_00_0_000_0_0_00_111;     
                  endcase

               3'b111:  ctrl_info = 16'b111_00_0_010_0_1_00_111;     //and
               3'b110:  ctrl_info = 16'b111_00_0_011_0_1_00_111;     //or
               3'b100:  ctrl_info = 16'b111_00_0_100_0_1_00_111;     //xor
               3'b001:  ctrl_info = 16'b111_00_0_101_0_1_00_111;     //sll
               3'b101: 
                  case (funct7)
                     7'b0000000: ctrl_info = 16'b111_00_0_110_0_1_00_111;     //srl
                     7'b0100000: ctrl_info = 16'b111_00_0_111_0_1_00_111;     //sra
                     default:    ctrl_info = 16'b111_00_0_000_0_0_00_111;     
                  endcase
               default: ctrl_info = 16'b111_00_0_000_0_0_00_111;
            endcase

         `OPCODE_I:
            case (funct3)
               3'b000:  ctrl_info = 16'b000_00_0_000_1_1_00_111;     //addi
               3'b111:  ctrl_info = 16'b000_00_0_010_1_1_00_111;     //andi
               3'b110:  ctrl_info = 16'b000_00_0_011_1_1_00_111;     //ori
               3'b100:  ctrl_info = 16'b000_00_0_100_1_1_00_111;     //xori
               3'b001:  ctrl_info = 16'b000_00_0_101_1_1_00_111;     //slli
               3'b101:
                  case(funct7)
                     7'b0000000:  ctrl_info = 16'b000_00_0_110_1_1_00_111;     //srli
                     7'b0100000:  ctrl_info = 16'b000_00_0_111_1_1_00_111;     //srai
                     default:     ctrl_info = 16'b111_00_0_000_0_0_00_111;     
                  endcase
               default: ctrl_info = 16'b111_00_0_000_0_0_00_111;    
            endcase
            
         `OPCODE_LW: ctrl_info = 16'b000_00_0_000_1_1_01_111;  //lw
 
         `OPCODE_JALR: ctrl_info = 16'b000_11_0_000_0_1_10_111;    //jarl

         `OPCODE_S: ctrl_info = 16'b001_00_1_000_1_0_10_111;    //sw

         `OPCODE_B: 
            case (funct3)
               3'b000:  ctrl_info = 16'b010_10_0_000_0_0_00_000;     //beq
               3'b001:  ctrl_info = 16'b010_10_0_000_0_0_00_001;     //bne
               3'b100:  ctrl_info = 16'b010_10_0_000_0_0_00_010;     //blt
               3'b101:  ctrl_info = 16'b010_10_0_000_0_0_00_011;     //bge
               default: ctrl_info = 16'b111_00_0_000_0_0_00_111;     
            endcase

         `OPCODE_U: ctrl_info = 16'b011_00_0_000_0_1_11_111;   //lui

         `OPCODE_J: ctrl_info = 16'b100_01_0_000_0_1_10_111;   //jal

         default:   ctrl_info = 16'b111_00_0_000_0_0_00_111;   
         
      endcase
   end

   assign sext_op  = ctrl_info[15:13];
   assign npc_op   = ctrl_info[12:11];
   assign ram_we   = ctrl_info[10];
   assign alu_op   = ctrl_info[9:7];
   assign alub_sel = ctrl_info[6];
   assign rf_we    = ctrl_info[5];
   assign rf_wsel  = ctrl_info[4:3];
   assign br_op    = ctrl_info[2:0];
   

endmodule  //Controller
