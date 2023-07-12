module REG_EX_MEM (
   input wire cpu_rst,
   input wire cpu_clk,

   input wire [31:0] ext_EX_out,
   output reg [31:0] ext_MEM_in,

   input wire [31:0] pc4_EX_out,
   output reg [31:0] pc4_MEM_in,

   input wire [4:0] wR_EX_out,
   output reg [4:0] wR_MEM_in,

   input wire ram_we_EX_out,
   output reg ram_we_MEM_in,

   input wire [1:0] rf_wsel_EX_out,
   output reg [1:0] rf_wsel_MEM_in,

   input wire rf_we_EX_out,
   output reg rf_we_MEM_in,

   input wire [31:0] rD2_EX_out,
   output reg [31:0] rD2_MEM_in,

   input wire [31:0] ALU_C_EX_out,
   output reg [31:0] ALU_C_MEM_in,

   input wire [31:0] pc_EX_out,
   output reg [31:0] pc_MEM_in

`ifdef RUN_TRACE
   ,// debug
   input wire inst_valid_EX_out,
   output reg inst_valid_MEM_in

`endif 
);

   // ext
   always @(posedge cpu_clk or posedge cpu_rst) begin
      if (cpu_rst) begin
         ext_MEM_in <= 32'h0;
      end
      else begin
         ext_MEM_in <= ext_EX_out;
      end
   end

   // pc4
   always @(posedge cpu_clk or posedge cpu_rst) begin
      if (cpu_rst) begin
         pc4_MEM_in <= 32'h0;
      end
      else begin
         pc4_MEM_in <= pc4_EX_out;
      end
   end

   // wR
   always @(posedge cpu_clk or posedge cpu_rst) begin
      if (cpu_rst) begin
         wR_MEM_in <= 5'b0;
      end
      else begin
         wR_MEM_in <= wR_EX_out;
      end
   end

   // ram_we
   always @(posedge cpu_clk or posedge cpu_rst) begin
      if (cpu_rst) begin
         ram_we_MEM_in <= 1'b0;
      end
      else begin
         ram_we_MEM_in <= ram_we_EX_out;
      end
   end

   // rf_wsel
   always @(posedge cpu_clk or posedge cpu_rst) begin
      if (cpu_rst) begin
         rf_wsel_MEM_in <= 2'b0;
      end
      else begin
         rf_wsel_MEM_in <= rf_wsel_EX_out;
      end
   end

   // rf_we
   always @(posedge cpu_clk or posedge cpu_rst) begin
      if (cpu_rst) begin
         rf_we_MEM_in <= 1'b0;
      end
      else begin
         rf_we_MEM_in <= rf_we_EX_out;
      end
   end

   // rD2
   always @(posedge cpu_clk or posedge cpu_rst) begin
      if (cpu_rst) begin
         rD2_MEM_in <= 32'h0;
      end
      else begin
         rD2_MEM_in <= rD2_EX_out;
      end
   end

   // ALU_C
   always @(posedge cpu_clk or posedge cpu_rst) begin
      if (cpu_rst) begin
         ALU_C_MEM_in <= 32'h0;
      end
      else begin
         ALU_C_MEM_in <= ALU_C_EX_out;
      end
   end

   // pc
   always @(posedge cpu_clk or posedge cpu_rst) begin
      if (cpu_rst) begin
         pc_MEM_in <= 32'h0;
      end
      else begin
         pc_MEM_in <= pc_EX_out;
      end
   end

`ifdef RUN_TRACE

   always @(posedge cpu_clk or posedge cpu_rst) begin
      if (cpu_rst)
         inst_valid_MEM_in <= 1'b0;
      else 
         inst_valid_MEM_in <= inst_valid_EX_out;
   end

`endif 

endmodule //REG_EX_MEM