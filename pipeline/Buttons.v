module Buttons (
   input wire        clk,
   input wire        rst,
   input wire [31:0] addr,
   input wire [ 4:0] button,

   output reg [31:0] rdata
);

   always @(posedge clk or posedge rst) begin
      if (rst) begin
         rdata <= 32'h0;
      end 
      
      else rdata = {27'b0, button};
   end


endmodule //Buttons