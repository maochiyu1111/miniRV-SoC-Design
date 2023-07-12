module REG_IF_ID (
   input cpu_rst,
   input cpu_clk,

   input wire [31:0] pc4_IF_out,
   output reg [31:0] pc4_ID_in,

   input wire [31:0] inst_IF_out,
   output reg [31:0] inst_ID_in,

   input wire [31:0] pc_IF_out,
   output reg [31:0] pc_ID_in,

   input wire nop_data,
   input wire Flush_B,
   input wire Flush_jump

`ifdef RUN_TRACE
   ,// debug
   output reg inst_valid_ID_in

`endif 
);

   //pc4
   always @(posedge cpu_clk or posedge cpu_rst ) begin
      if (cpu_rst) 
         pc4_ID_in <= 32'h0;
      else if (Flush_B || Flush_jump) 
         pc4_ID_in <= 32'h0;
      else if (nop_data) 
         pc4_ID_in <= pc4_ID_in;
      else 
         pc4_ID_in <= pc4_IF_out;
   end

   //inst
   always @(posedge cpu_clk or posedge cpu_rst) begin
      if (cpu_rst)
         inst_ID_in <= 32'h0;
      else if (Flush_B || Flush_jump) 
         inst_ID_in <= 32'h0;
      else if (nop_data)
         inst_ID_in <= inst_ID_in;
      else
         inst_ID_in <= inst_IF_out;
   end

   //pc
   always @(posedge cpu_clk or posedge cpu_rst) begin
      if (cpu_rst)
         pc_ID_in <= 32'h0;
      else if (Flush_B || Flush_jump)
         pc_ID_in <= 32'h0;
      else if (nop_data)
         pc_ID_in <= pc_ID_in;
      else
         pc_ID_in <= pc_IF_out;
   end   

`ifdef RUN_TRACE

   always @(posedge cpu_clk or posedge cpu_rst) begin
      if (cpu_rst)
         inst_valid_ID_in <= 1'b0;
      else if (Flush_B || Flush_jump)
         inst_valid_ID_in <= 1'b0;
      else
         inst_valid_ID_in <= 1'b1;
   end
`endif


   //pc
endmodule //REG_IF_ID