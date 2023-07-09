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
   output reg [31:0] rD2_EX_in

`ifdef RUN_TRACE
   ,// debug
   input wire [31:0] pc_ID_out,
   output reg [31:0] pc_EX_in

`endif 
);

   //ext
   always @(posedge cpu_clk or posedge cpu_rst ) begin
      if (cpu_rst) begin
         ext_EX_in <= 32'h0;
      end
      else begin
         ext_EX_in <= ext_ID_out;
      end
   end

   //pc4
   always @(posedge cpu_clk or posedge cpu_rst ) begin
      if (cpu_rst) begin
         pc4_EX_in <= 32'h0;
      end

      else 
         pc4_EX_in <= pc4_ID_out;
   end


   //wR
   always @(posedge cpu_clk or posedge cpu_rst ) begin
      if (cpu_rst) begin
         wR_EX_in <= 5'b0;
      end
      else begin
         wR_EX_in <= wR_ID_out;
      end
   end

   //ram_we
   always @(posedge cpu_clk or posedge cpu_rst ) begin
      if (cpu_rst) begin
         ram_we_EX_in <= 1'b0;
      end
      else begin
         ram_we_EX_in <= ram_we_ID_out;
      end
   end

   //alu_op
   always @(posedge cpu_clk or posedge cpu_rst ) begin
      if (cpu_rst) begin
         alu_op_EX_in <= 3'b0;
      end
      else begin
         alu_op_EX_in <= alu_op_ID_out;
      end
   end

   //rf_wsel
   always @(posedge cpu_clk or posedge cpu_rst ) begin
      if (cpu_rst) begin
         rf_wsel_EX_in <= 2'b0;
      end
      else begin
         rf_wsel_EX_in <= rf_wsel_ID_out;
      end
   end

   //rf_we
   always @(posedge cpu_clk or posedge cpu_rst ) begin
      if (cpu_rst) begin
         rf_we_EX_in <= 1'b0;
      end
      else begin
         rf_we_EX_in <= rf_we_ID_out;
      end
   end

   //br_op
   always @(posedge cpu_clk or posedge cpu_rst ) begin
      if (cpu_rst) begin
         br_op_EX_in <= 3'b111;
      end
      else begin
         br_op_EX_in <= br_op_ID_out;
      end
   end

   //rD1
   always @(posedge cpu_clk or posedge cpu_rst ) begin
      if (cpu_rst) begin
         rD1_EX_in <= 32'h0;
      end
      else begin
         rD1_EX_in <= rD1_ID_out;
      end
   end

   //B
   always @(posedge cpu_clk or posedge cpu_rst ) begin
      if (cpu_rst) begin
         B_EX_in <= 32'h0;
      end
      else begin
         B_EX_in <= B_ID_out;
      end
   end

   //rD2
   always @(posedge cpu_clk or posedge cpu_rst ) begin
      if (cpu_rst) begin
         rD2_EX_in <= 32'h0;
      end
      else begin
         rD2_EX_in <= rD2_ID_out;
      end
   end


`ifdef RUN_TRACE
   //pc
   always @(posedge cpu_clk or posedge cpu_rst ) begin
      if (cpu_rst) begin
         pc_EX_in <= 32'h0;
      end
      else begin
         pc_EX_in <= pc_ID_out;
      end
   end
   
`endif 


endmodule //REG_ID_EX