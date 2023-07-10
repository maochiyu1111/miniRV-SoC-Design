`include "defines.vh"

module ForwardU ( // forwarding unit
   input wire cpu_rst,
   input wire cpu_clk,

   //hazard signal
   input wire RAW_A_rR1,
   input wire RAW_A_rR2,

   input wire RAW_B_rR1,
   input wire RAW_B_rR2,

   input wire RAW_C_rR1,
   input wire RAW_C_rR2,


   //write back data
   input wire [31:0] ALU_C_EX_out,  //RAW_A
   input wire [31:0] ext_EX_out,
   input wire [31:0] pc4_EX_out,
   input wire [ 1:0] rf_wsel_EX_out, 

   input wire [31:0] wD_MEM_out,  //RAW_B
   input wire [31:0] wD_WB_in,   //RAW_C

   output wire forward_en_rD1,
   output wire forward_en_rD2,

   output reg [31:0] forward_rD1,
   output reg [31:0] forward_rD2
);

   //MUX for wD_RAW_A
   reg [31:0] wD_RAW_A;  //without possibility of rdo
   always @(*) begin
      case (rf_wsel_EX_out)

         `WB_ALU : wD_RAW_A = ALU_C_EX_out;
         `WB_PC4 : wD_RAW_A = pc4_EX_out;
         `WB_IMM : wD_RAW_A = ext_EX_out;
         default : wD_RAW_A = 32'h0;
            
      endcase
   end


   assign forward_en_rD1 = (RAW_A_rR1 || RAW_B_rR1 || RAW_C_rR1);
   assign forward_en_rD2 = (RAW_A_rR2 || RAW_B_rR2 || RAW_C_rR2);



   always @(*) begin
      if (RAW_A_rR1)
         forward_rD1 = wD_RAW_A;
      else if (RAW_B_rR1)
         forward_rD1 = wD_MEM_out;
      else if (RAW_C_rR1)
         forward_rD1 = wD_WB_in;
      else
         forward_rD1 = 32'h0;
   end

   always @(*) begin
      if (RAW_A_rR2)
         forward_rD2 = wD_RAW_A;
      else if (RAW_B_rR2)
         forward_rD2 = wD_MEM_out;
      else if (RAW_C_rR2)
         forward_rD2 = wD_WB_in;
      else
         forward_rD2 = 32'h0;         
   end

endmodule //ForwardU