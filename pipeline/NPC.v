`include "defines.vh"

module NPC (

   input wire [31:0] pc,
   input wire        op,
   input wire [31:0] new_pc,
 
   output reg [31:0] npc,
   output reg [31:0] pc4
);

   always @(*) begin
      case (op)
         `NPC_PC4:   npc = pc + 4;

         `NPC_new:   npc = new_pc;

         default:    npc = pc + 4;
      endcase  
   end

   always @(*) begin
      pc4 = pc + 4;
   end

endmodule  //NPC
