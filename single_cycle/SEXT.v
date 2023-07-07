`include "defines.vh"

module SEXT (
   input wire [ 2:0] op,
   input wire [24:0] din,


   output reg [31:0] ext
);


   always @(*) begin
      case (op)
         `IMM_I: ext = {(din[24]? 20'hFFFFF : 20'h00000), din[24:13]};
         `IMM_S: ext = {(din[24]? 20'hFFFFF : 20'h00000), din[24:18], din[4:0]};
         `IMM_B: ext = {(din[24]? 20'hFFFFF : 20'h00000), din[0], din[23:18], din[4:1], 1'b0};
         `IMM_U: ext = {din[24:5], 12'h000};
         `IMM_J: ext = {(din[24]? 12'hFFF : 12'h000), din[12:5], din[13], din[23:14], 1'b0};
         default: ext = 32'h00000000;
      endcase
   end

endmodule //SEXT