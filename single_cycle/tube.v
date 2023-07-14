module tube (
    input  wire clk,
    input  wire rst,
    input  wire [3:0]number,
    output reg  [7:0]segment_en 
);
   
    always @(*) begin
        case (number)
            4'd0: segment_en=8'b00000011;
            4'd1: segment_en=8'b10011111;
            4'd2: segment_en=8'b00100101;
            4'd3: segment_en=8'b00001101;
            4'd4: segment_en=8'b10011001;
            4'd5: segment_en=8'b01001001;
            4'd6: segment_en=8'b01000001;
            4'd7: segment_en=8'b00011111;
            4'd8: segment_en=8'b00000001;
            4'd9: segment_en=8'b00011001;
            4'd10: segment_en=8'b00010001;
            4'd11: segment_en=8'b11000001;
            4'd12: segment_en=8'b11100101;
            4'd13: segment_en=8'b10000101;
            4'd14: segment_en=8'b01100001;
            4'd15: segment_en=8'b01110001;
            default: segment_en=8'b11111111;
        endcase
    end

endmodule //tube