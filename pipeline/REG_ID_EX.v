module REG_ID_EX (
   input wire cpu_rst,
   input wire cpu_clk,

   input wire [31:0] ext_ID_out,
   output reg [31:0] ext_EX_in,

   input wire [31:0] pc4_ID_out,
   output reg [31:0] pc4_EX_in,

   input wire [4:0] wR_ID_out,
   output reg [4:0] wR_EX_in,

   input wire ram_we_ID_out,
   output reg ram_we_EX_in,

   input wire [2:0] alu_op_ID_out,
   output reg [2:0] alu_op_EX_in,

   input wire [1:0] rf_wsel_ID_out,
   output reg [1:0] rf_wsel_EX_in,

   input wire rf_we_ID_out,
   output reg rf_we_EX_in,

   input wire [2:0] br_op_ID_out,
   output reg [2:0] br_op_EX_in,

   input wire [31:0] rD1_ID_out,
   output reg [31:0] rD1_EX_in,

   input wire [31:0] B_ID_out,
   output reg [31:0] B_EX_in,

   input wire [31:0] rD2_ID_out,
   output reg [31:0] rD2_EX_in,

   input wire forward_en_rD1,
   input wire forward_en_rD2,

   input wire [31:0] forward_rD1,
   input wire [31:0] forward_rD2,

   input wire is_load_ID_out,
   output wire is_load_EX_in,

   input wire nop

`ifdef RUN_TRACE
   ,// debug
   input wire [31:0] pc_ID_out,
   output reg [31:0] pc_EX_in,

   input wire inst_valid_ID_out,
   output reg inst_valid_EX_in

`endif 
);

   //ext
   always @(posedge cpu_clk or posedge cpu_rst) begin
      if (cpu_rst)
         ext_EX_in <= 32'h0;
      else
         ext_EX_in <= ext_ID_out;
   end

   //pc4
   always @(posedge cpu_clk or posedge cpu_rst) begin
      if (cpu_rst)
         pc4_EX_in <= 32'h0;
      else
         pc4_EX_in <= pc4_ID_out;
   end

   //wR
   always @(posedge cpu_clk or posedge cpu_rst) begin
      if (cpu_rst)
         wR_EX_in <= 5'b0;
      else if (nop)
         wR_EX_in <= 5'b0;
      else
         wR_EX_in <= wR_ID_out;
   end

   //ram_we
   always @(posedge cpu_clk or posedge cpu_rst) begin
      if (cpu_rst)
         ram_we_EX_in <= 1'b0;
      else if (nop)
         ram_we_EX_in <= 1'b0;
      else
         ram_we_EX_in <= ram_we_ID_out;
   end

   //alu_op
   always @(posedge cpu_clk or posedge cpu_rst) begin
      if (cpu_rst)
         alu_op_EX_in <= 3'b0;
      else if (nop)
         alu_op_EX_in <= 3'b0;
      else
         alu_op_EX_in <= alu_op_ID_out;
   end

   //rf_wsel
   always @(posedge cpu_clk or posedge cpu_rst) begin
      if (cpu_rst)
         rf_wsel_EX_in <= 2'b0;
      else if (nop)
         rf_wsel_EX_in <= 2'b0;
      else
         rf_wsel_EX_in <= rf_wsel_ID_out;
   end

   //rf_we
   always @(posedge cpu_clk or posedge cpu_rst) begin
      if (cpu_rst)
         rf_we_EX_in <= 1'b0;
      else if (nop)
         rf_we_EX_in <= 1'b0;
      else
         rf_we_EX_in <= rf_we_ID_out;
   end

   //br_op
   always @(posedge cpu_clk or posedge cpu_rst) begin
      if (cpu_rst)
         br_op_EX_in <= 3'b111;
      else if (nop)
         br_op_EX_in <= 3'b111;
      else
         br_op_EX_in <= br_op_ID_out;
   end

   //rD1
   always @(posedge cpu_clk or posedge cpu_rst) begin
      if (cpu_rst)
         rD1_EX_in <= 32'h0;
      else if (forward_en_rD1)
         rD1_EX_in <= forward_rD1;
      else
         rD1_EX_in <= rD1_ID_out;
   end

   //B
   always @(posedge cpu_clk or posedge cpu_rst) begin
      if (cpu_rst)
         B_EX_in <= 32'h0;
      else if (forward_en_rD2)
         B_EX_in <= forward_rD2;
      else
         B_EX_in <= B_ID_out;
   end

   //rD2
   always @(posedge cpu_clk or posedge cpu_rst) begin
      if (cpu_rst)
         rD2_EX_in <= 32'h0;
      else if (forward_en_rD2)
         rD2_EX_in <= forward_rD2;
      else
         rD2_EX_in <= rD2_ID_out;
   end

   always @(posedge cpu_clk or posedge cpu_rst) begin
      if (cpu_rst)
         is_load_EX_in <= 1'b0;
      else if (nop)
         is_load_EX_in <= 1'b0;
      else
         is_load_EX_in <= is_load_ID_out;
   end  

`ifdef RUN_TRACE
   //pc
   always @(posedge cpu_clk or posedge cpu_rst) begin
      if (cpu_rst)
         pc_EX_in <= 32'h0;
      else if (nop)
         pc_EX_in <= 32'h0;
      else
         pc_EX_in <= pc_ID_out;
   end

   always @(posedge cpu_clk or posedge cpu_rst) begin
      if (cpu_rst)
         inst_valid_EX_in <= 1'b0;
      else if (nop)
         inst_valid_EX_in <= 1'b0;
      else
         inst_valid_EX_in <= inst_valid_ID_out;
   end
`endif


endmodule //REG_ID_EX