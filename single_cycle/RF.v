`include "defines.vh"

module RF (
   input  wire        cpu_clk,
   input  wire [ 4:0] rR1,   //register 1
   input  wire [ 4:0] rR2,   //register 2
   input  wire [ 4:0] wR,    //register write back
   input  wire        we,    //write back enable signal
   input  wire [31:0] wD,    //write back data
   output reg  [31:0] rD1,   //data of register1
   output reg  [31:0] rD2    //data of register2

);

   reg [31:0] registers [31:0];   // 32 registers, each 32 bits wide

   always @(posedge cpu_clk) begin
      // Read data from register 1 and register 2
      rD1 <= registers[rR1];
      rD2 <= registers[rR2];

      // Write data to register if write enable signal is high
      if (we)
         registers[wR] <= wD;
   end


endmodule  //RF
