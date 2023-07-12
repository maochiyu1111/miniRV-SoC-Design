module REG_MEM_WB (
   input wire cpu_rst,
   input wire cpu_clk,

   input wire [4:0] wR_MEM_out,
   output reg [4:0] wR_WB_in,

   input wire rf_we_MEM_out,
   output reg rf_we_WB_in,

   input wire [31:0] wD_MEM_out,
   output reg [31:0] wD_WB_in,

   input wire [31:0] pc_MEM_out,
   output reg [31:0] pc_WB_in   

`ifdef RUN_TRACE
   ,// debug

   input wire inst_valid_MEM_out,
   output reg inst_valid_WB_in

`endif 
);


   // wR
   always @(posedge cpu_clk or posedge cpu_rst) begin
      if (cpu_rst) begin
         wR_WB_in <= 5'b0;
      end
      else begin
         wR_WB_in <= wR_MEM_out;
      end
   end


   // rf_we
   always @(posedge cpu_clk or posedge cpu_rst) begin
      if (cpu_rst) begin
         rf_we_WB_in <= 1'b0;
      end
      else begin
         rf_we_WB_in <= rf_we_MEM_out;
      end
   end


   // wD
   always @(posedge cpu_clk or posedge cpu_rst) begin
      if (cpu_rst) begin
         wD_WB_in <= 32'h0;
      end
      else begin
         wD_WB_in <= wD_MEM_out;
      end
   end

   // pc
   always @(posedge cpu_clk or posedge cpu_rst) begin
      if (cpu_rst) begin
         pc_WB_in <= 32'h0;
      end
      else begin
         pc_WB_in <= pc_MEM_out;
      end
   end

`ifdef RUN_TRACE

   always @(posedge cpu_clk or posedge cpu_rst) begin
      if (cpu_rst)
         inst_valid_WB_in <= 1'b0;
      else 
         inst_valid_WB_in <= inst_valid_MEM_out;
   end
`endif 

endmodule //REG_MEM_WB