module REG_IF_ID (
   input cpu_rst,
   input cpu_clk,

   input wire [31:0] pc4_IF_out,
   output reg [31:0] pc4_ID_in,

   input wire [31:0] inst_IF_out,
   output reg [31:0] inst_ID_in

`ifdef RUN_TRACE
   ,// debug
   input wire [31:0] pc_IF_out,
   output reg [31:0] pc_ID_in

`endif 
);

   //pc4
   always @(posedge cpu_clk or posedge cpu_rst ) begin
      if (cpu_rst) begin
         pc4_ID_in <= 32'h0;
      end

      else 
         pc4_ID_in <= pc4_IF_out;
   end

   //inst
   always @(posedge cpu_clk or posedge cpu_rst ) begin
      if (cpu_rst) begin
         inst_ID_in <= 32'h0;
      end
      else begin
         inst_ID_in <= inst_IF_out;
      end
   end

`ifdef RUN_TRACE
   //pc
   always @(posedge cpu_clk or posedge cpu_rst ) begin
      if (cpu_rst) begin
         pc_ID_in <= 32'h0;
      end
      else begin
         pc_ID_in <= pc_IF_out;
      end
   end
   
`endif 


   //pc
endmodule //REG_IF_ID