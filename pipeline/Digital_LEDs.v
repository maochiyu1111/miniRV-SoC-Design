module Digital_LEDs (
   input wire        clk,
   input wire        rst,
   input wire [31:0] addr,
   input wire        wen,
   input wire [31:0] wdata,
   
   output wire[ 7:0] dig_en,
   output reg        DN_A,
   output reg        DN_B,
   output reg        DN_C,
   output reg        DN_D,
   output reg        DN_E,
   output reg        DN_F,
   output reg        DN_G,
   output reg        DN_DP
);
   
    wire [63:0] segment_en;
    reg  [31:0] wD;
    
    always @(posedge clk or posedge rst) begin      
        if(rst)                             
            wD <= 32'b0;
        else if(wen && addr == 12'h000)     
            wD <= wdata;      
        else                                
            wD <= wD;
    end
    
    wire [31:0] wdata_pro = wD;
    
    tube u_tube_7(.clk(clk),.rst(rst),.number(wdata_pro[31:28]),.segment_en(segment_en[7:0]));
    tube u_tube_6(.clk(clk),.rst(rst),.number(wdata_pro[27:24]),.segment_en(segment_en[15:8]));
    tube u_tube_5(.clk(clk),.rst(rst),.number(wdata_pro[23:20]),.segment_en(segment_en[23:16]));
    tube u_tube_4(.clk(clk),.rst(rst),.number(wdata_pro[19:16]),.segment_en(segment_en[31:24]));
    tube u_tube_3(.clk(clk),.rst(rst),.number(wdata_pro[15:12]),.segment_en(segment_en[39:32]));
    tube u_tube_2(.clk(clk),.rst(rst),.number(wdata_pro[11:8]),.segment_en(segment_en[47:40]));
    tube u_tube_1(.clk(clk),.rst(rst),.number(wdata_pro[7:4]),.segment_en(segment_en[55:48]));
    tube u_tube_0(.clk(clk),.rst(rst),.number(wdata_pro[3:0]),.segment_en(segment_en[63:56]));
 
    always @(*) begin
        case(dig_en) 
            8'b1111_1110:  {DN_A,DN_B,DN_C,DN_D,DN_E,DN_F,DN_G,DN_DP} = segment_en[63:56];
            8'b1111_1101:  {DN_A,DN_B,DN_C,DN_D,DN_E,DN_F,DN_G,DN_DP} = segment_en[55:48];
            8'b1111_1011:  {DN_A,DN_B,DN_C,DN_D,DN_E,DN_F,DN_G,DN_DP} = segment_en[47:40];
            8'b1111_0111:  {DN_A,DN_B,DN_C,DN_D,DN_E,DN_F,DN_G,DN_DP} = segment_en[39:32];
            8'b1110_1111:  {DN_A,DN_B,DN_C,DN_D,DN_E,DN_F,DN_G,DN_DP} = segment_en[31:24];
            8'b1101_1111:  {DN_A,DN_B,DN_C,DN_D,DN_E,DN_F,DN_G,DN_DP} = segment_en[23:16];
            8'b1011_1111:  {DN_A,DN_B,DN_C,DN_D,DN_E,DN_F,DN_G,DN_DP} = segment_en[15:8];
            8'b0111_1111:  {DN_A,DN_B,DN_C,DN_D,DN_E,DN_F,DN_G,DN_DP} = segment_en[7:0];
            default:  {DN_A,DN_B,DN_C,DN_D,DN_E,DN_F,DN_G,DN_DP} = 8'b1111_1111;
        endcase
    end

    timer u_timer(.clk(clk),.rst(rst),.wen(wen),.led_en(dig_en));

endmodule //Digital_LEDs