module JumpDU ( 
   input wire is_jal,
   input wire is_jalr,

   input wire is_B,   //from controller
   input wire pre_br,

   output wire Flush_jump,
   output wire B_jump
);

   assign Flush_jump = is_jal || is_jalr || B_jump;
   assign B_jump = is_B && pre_br;
   
endmodule