module PC (
   input wire        cpu_rst,
   input wire        cpu_clk,
   input wire [31:0] din,
   input wire        nop_data,

   output reg [31:0] pc
);

   always @(posedge cpu_clk or posedge cpu_rst) begin
      if (cpu_rst) 
         pc <= 32'h0;
      else if (nop_data)
         pc <= pc;
      else
         pc <= din;
   end
endmodule  //PC
