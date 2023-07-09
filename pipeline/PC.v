module PC (
   input wire        cpu_rst,
   input wire        cpu_clk,
   input wire [31:0] din,

   output reg [31:0] pc
);

   always @(posedge cpu_clk or posedge cpu_rst) begin
      if (cpu_rst) begin
         pc <= 32'h00000000;
      end else pc <= din;
   end
endmodule  //PC
