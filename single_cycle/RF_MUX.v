`include "defines.vh"

module RF_MUX (
   input wire [ 1:0] rf_wsel,
   input wire [31:0] pc4,
   input wire [31:0] ext,
   input wire [31:0] ALU_C,
   input wire [31:0] rdo,

   output reg [31:0] wD

);

   always @(*) begin
      case (rf_wsel)
         `WB_ALU: wD = ALU_C;
         `WB_MEM: wD = rdo;
         `WB_PC4: wD = pc4;
         `WB_IMM: wD = ext;
         default: wD = 32'h00000000;
      endcase
   end

endmodule  //RF_MUX
