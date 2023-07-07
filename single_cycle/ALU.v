`include "defines.vh"

module ALU (
   input wire [31:0] A,
   input wire [31:0] B,
   input wire [ 2:0] alu_op,
   input wire [ 2:0] br_op,

   output reg [31:0] ALU_C,
   output reg        ALU_F
);

reg [31:0] sub_result;

always @(*) begin
   case (alu_op)
      `ADD: ALU_C = A + B;
      `SUB: ALU_C = A - B;
      `AND: ALU_C = A & B;
      `OR:  ALU_C = A | B;
      `XOR: ALU_C = A ^ B;
      `SLL: ALU_C = A << B[4:0];
      `SRL: ALU_C = A >> B[4:0];
      `SRA: ALU_C = $signed(A) >>> B[4:0];
      default: ALU_C = 0;
   endcase
end


always @(*) begin
   sub_result = A - B; 
   case (br_op)
      `BR_NONE:
         ALU_F = 1'b0;
      `BR_BEQ:
         if (sub_result == 0)
            ALU_F = 1'b1;
         else
            ALU_F = 1'b0;
      `BR_BLT:
         if (sub_result[31] == 1)
            ALU_F = 1'b1;
         else
            ALU_F = 1'b0;
      `BR_BNE:
         if (sub_result != 0)
            ALU_F = 1'b1;
         else
            ALU_F = 1'b0;
      `BR_BGE:
         if (sub_result[31] == 0)
            ALU_F = 1'b1;
         else
            ALU_F = 1'b0;
      default: ALU_F = 1'b0;
   endcase
end

endmodule  //ALU
