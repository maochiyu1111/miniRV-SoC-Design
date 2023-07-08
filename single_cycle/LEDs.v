module LEDs (
   input wire        clk,
   input wire        rst,
   input wire [31:0] addr,
   input wire        wen,
   input wire [31:0] wdata,

   output reg [23:0] led
);

   always @(posedge clk or posedge rst) begin
      if (rst) begin
         led <= 24'h0;
      end

      else if(wen) begin
         led <= wdata[23:0];
      end
   end

endmodule  //LEDs
