module BMHU ( //branch misprediction handling unit
   input cpu_rst,
   input cpu_clk,

   input wire is_B,   // from EX
   input wire real_br,  // from EX
   input wire pre_br,   // from predictor

   input wire [31:0] pc_EX_out,
   input wire [31:0] pc4_EX_out,
   input wire [31:0] ext_EX_out,

   output wire Flush_B,
   output wire [31:0] br_pc

);


   reg pre_br_ex;

   always @(posedge cpu_clk or posedge cpu_rst) begin
      if (cpu_rst)
         pre_br_ex <= 1'b0;
      else 
         pre_br_ex <= pre_br;
   end

   assign Flush_B = is_B && (pre_br_ex != real_br); 

   assign br_pc = real_br? (pc_EX_out + ext_EX_out) : pc4_EX_out;
   

endmodule //BMHU