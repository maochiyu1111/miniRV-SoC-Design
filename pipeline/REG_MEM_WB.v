module REG_MEM_WB (
   input wire cpu_rst,
   input wire cpu_clk,

   input wire [31:0] ext_MEM_out,
   output reg [31:0] ext_WB_in,

   input wire [31:0] pc4_MEM_out,
   output reg [31:0] pc4_WB_in,

   input wire [4:0] wR_MEM_out,
   output reg [4:0] wR_WB_in,

   input wire [1:0] rf_wsel_MEM_out,
   output reg [1:0] rf_wsel_WB_in,

   input wire rf_we_MEM_out,
   output reg rf_we_WB_in,

   input wire [31:0] ALU_C_MEM_out,
   output reg [31:0] ALU_C_WB_in,

   input wire [31:0] rdo_MEM_out,
   output reg [31:0] rdo_WB_in

`ifdef RUN_TRACE
   ,// debug
   input wire [31:0] pc_MEM_out,
   output reg [31:0] pc_WB_in

`endif 
);

   // ext
   always @(posedge cpu_clk or posedge cpu_rst) begin
      if (cpu_rst) begin
         ext_WB_in <= 32'h0;
      end
      else begin
         ext_WB_in <= ext_MEM_out;
      end
   end

   // pc4
   always @(posedge cpu_clk or posedge cpu_rst) begin
      if (cpu_rst) begin
         pc4_WB_in <= 32'h0;
      end
      else begin
         pc4_WB_in <= pc4_MEM_out;
      end
   end

   // wR
   always @(posedge cpu_clk or posedge cpu_rst) begin
      if (cpu_rst) begin
         wR_WB_in <= 5'b0;
      end
      else begin
         wR_WB_in <= wR_MEM_out;
      end
   end

   // rf_wsel
   always @(posedge cpu_clk or posedge cpu_rst) begin
      if (cpu_rst) begin
         rf_wsel_WB_in <= 2'b0;
      end
      else begin
         rf_wsel_WB_in <= rf_wsel_MEM_out;
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

   // ALU_C
   always @(posedge cpu_clk or posedge cpu_rst) begin
      if (cpu_rst) begin
         ALU_C_WB_in <= 32'h0;
      end
      else begin
         ALU_C_WB_in <= ALU_C_MEM_out;
      end
   end

   // rdo
   always @(posedge cpu_clk or posedge cpu_rst) begin
      if (cpu_rst) begin
         rdo_WB_in <= 32'h0;
      end
      else begin
         rdo_WB_in <= rdo_MEM_out;
      end
   end


`ifdef RUN_TRACE
   // pc
   always @(posedge cpu_clk or posedge cpu_rst) begin
      if (cpu_rst) begin
         pc_WB_in <= 32'h0;
      end
      else begin
         pc_WB_in <= pc_MEM_out;
      end
   end

`endif 

endmodule //REG_MEM_WB