module Switches (
   input wire        clk,
   input wire        rst,
   input wire [31:0] addr,
   input wire [23:0] switch,

   output reg [31:0] rdata
);

   always @(posedge clk or posedge rst) begin
      if (rst) begin
         rdata <= 32'h0;
      end 
      
      else rdata = {8'b0, switch};
   end
endmodule  //Switches
