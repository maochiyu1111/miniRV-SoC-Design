`include "defines.vh"
module ALUB_MUX (
   input wire        alub_sel,
   input wire [31:0] rD2,
   input wire [31:0] ext,

   output reg [31:0] B
);

   always @(*) begin
      case (alub_sel)
         `B_RD2: B = rD2;
         `B_EXT: B = ext;
         default: B = rD2;
      endcase
   end
endmodule //ALUB_MUX