`include "defines.vh"

module NPC (
   input wire [31:0] pc,
   input wire [ 1:0] op,
   input wire [31:0] baseadr,
   input wire [31:0] offset,
   input wire        br,

   output reg [31:0] npc,
   output reg [31:0] pc4
);

   always @(*) begin
      case (op)
         `NPC_PC4:   npc = pc + 4;
         `NPC_JAL:   npc = pc + offset;
         `NPC_BR:    if (br) begin
                        npc = pc + offset;
                     end 
                     else npc = pc + 4;
         `NPC_JALR:  npc = baseadr + offset;
         default:    npc = 32'h00000000;
      endcase
   end

   always @(*) begin
      pc4 = pc + 4;
   end

endmodule  //NPC
