module NPC_Sel (
   input wire is_jal,
   input wire is_jalr,
   input wire Flush_B,
   input wire B_jump,      // branch predictor output pre_br == 1

   input wire [31:0] br_pc,  // when branch predictor mispredict, the next pc is br_pc

   input wire [31:0] pc_ID_in,
   input wire [31:0] ext_ID_out,
   input wire [31:0] rD1_ID_out,
   input wire forward_en_rD1,
   input wire [31:0] forward_rD1,

   output reg [31:0] new_pc,
   output wire npc_op

);

   always @(*) begin
      if (Flush_B) 
         new_pc = br_pc;
      else if (is_jal || B_jump) 
         new_pc = pc_ID_in + ext_ID_out;
      else if (is_jalr)
         if (forward_en_rD1) 
            new_pc = forward_rD1 + ext_ID_out;
         else
            new_pc = rD1_ID_out + ext_ID_out;
   end

   assign npc_op = is_jal || is_jalr || Flush_B || B_jump;
   
endmodule