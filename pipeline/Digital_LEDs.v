module Digital_LEDs (
   input wire        clk,
   input wire        rst,
   input wire [31:0] addr,
   input wire        wen,
   input wire [31:0] wdata,
   
   output reg [ 7:0]  dig_en,
   output wire         DN_A,
   output wire         DN_B,
   output wire         DN_C,
   output wire         DN_D,
   output wire         DN_E,
   output wire         DN_F,
   output wire         DN_G,
   output wire         DN_DP
);

   reg [3:0] number;    //中间变量
   reg [3:0] number7;   //数码管高位第1位数字
   reg [3:0] number6;   //数码管第2位数字
   reg [3:0] number5;   //数码管第3位数字
   reg [3:0] number4;   //数码管第4位数字
   reg [3:0] number3;   //数码管第5位数字
   reg [3:0] number2;   //数码管第6位数字
   reg [3:0] number1;   //数码管第7位数字
   reg [3:0] number0;  

   always @(*) begin
      if (rst) begin
         number7 = 4'b0;   //数码管高位第1位数字
         number6 = 4'b0;   //数码管第2位数字
         number5 = 4'b0;   //数码管第3位数字
         number4 = 4'b0;   //数码管第4位数字
         number3 = 4'b0;   //数码管第5位数字
         number2 = 4'b0;   //数码管第6位数字
         number1 = 4'b0;   //数码管第7位数字
         number0 = 4'b0; 
      end
         
      else if (wen) begin
         number7 = wdata[31:28];   //数码管高位第1位数字
         number6 = wdata[27:24];   //数码管第2位数字
         number5 = wdata[23:20];   //数码管第3位数字
         number4 = wdata[19:16];   //数码管第4位数字
         number3 = wdata[15:12];   //数码管第5位数字
         number2 = wdata[11:8];   //数码管第6位数字
         number1 = wdata[7:4];   //数码管第7位数字
         number0 = wdata[3:0];   
      end  
   end

   reg [7:0] total;  //数码管使能信号合集

   reg [17:0] cnt;
   wire cnt_end = (cnt == 19_999);  

   always @(posedge clk or posedge rst) begin
      if (rst) dig_en <= 8'b1111_1110;
      else if (cnt_end) dig_en[7:0] <= {dig_en[6:0], dig_en[7]};
      else dig_en <= dig_en;
   end

   always @(posedge clk or posedge rst) begin
      if (rst) cnt <= 18'd0;
      else if (cnt_end) cnt <= 18'd0;
      else cnt <= cnt + 18'd1;
   end

   always @(*) begin
      case(dig_en)
         8'b1111_1110: number = number0;
         8'b1111_1101: number = number1;
         8'b1111_1011: number = number2;
         8'b1111_0111: number = number3;
         8'b1110_1111: number = number4;
         8'b1101_1111: number = number5;
         8'b1011_1111: number = number6;
         8'b0111_1111: number = number7;
         default:number = 4'h0;
      endcase
   end

   always @(*) begin
      if(rst)    total = 8'b11111111;
      else begin
         case (number)
               4'h0:  total = 8'b00000011;
               4'h1:  total = 8'b10011111;
               4'h2:  total = 8'b00100101;
               4'h3:  total = 8'b00001101;
               4'h4:  total = 8'b10011001;
               4'h5:  total = 8'b01001001;
               4'h6:  total = 8'b01000001;
               4'h7:  total = 8'b00011111;
               4'h8:  total = 8'b00000001;
               4'h9:  total = 8'b00011001;
               4'ha:  total = 8'b00010001;
               4'hb:  total = 8'b11000001;
               4'hc:  total = 8'b11100101;
               4'hd:  total = 8'b10000101;
               4'he:  total = 8'b01110001;
               4'hf:  total = 8'b11111111;
               default: total = 8'b11111111;
         endcase
      end
   end
    
    assign {DN_A, DN_B, DN_C, DN_D, DN_E, DN_F, DN_G, DN_DP} = total;


endmodule //Digital_LEDs