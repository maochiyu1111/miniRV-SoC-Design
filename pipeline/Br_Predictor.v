`include "defines.vh"

module Br_Predictor (
   input wire cpu_rst,
   input wire cpu_clk,
   input wire is_B,     //from EX

   input wire real_br,  //1'b1 means jump
   output wire pre_br
);

   reg [1:0] current_state;
   reg [1:0] next_state;


   always @(posedge cpu_clk or posedge cpu_rst) begin
      if (cpu_rst) 
         current_state <= `WEAKLY_NOT_TAKEN;   //weakly not taken at first
      else if (is_B)
         current_state <= next_state;
      else 
         current_state <= current_state;
   end

   always @(*) begin
      case (current_state)
         `STRONGLY_TAKEN:  
            if (real_br) 
               next_state = `STRONGLY_TAKEN;
            else 
               next_state = `WEAKLY_TAKEN;

         `WEAKLY_TAKEN:
            if (real_br) 
               next_state = `STRONGLY_TAKEN;
            else 
               next_state = `WEAKLY_NOT_TAKEN;            

         `WEAKLY_NOT_TAKEN:
            if (real_br) 
               next_state = `WEAKLY_TAKEN;
            else 
               next_state = `STRONGLY_NOT_TAKEN;

         `STRONGLY_NOT_TAKEN:
            if (real_br) 
               next_state = `WEAKLY_NOT_TAKEN;
            else 
               next_state = `STRONGLY_NOT_TAKEN;

         default: next_state = `WEAKLY_NOT_TAKEN;
      endcase
   end

   assign pre_br = current_state[1];

endmodule //Br_Predictor