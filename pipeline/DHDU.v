module DHDU (  //Data Hazard Detection Unit

   input wire is_load,    // signal from controller

   input wire rR1_read,
   input wire rR2_read,

   input wire [4:0] rR1_ID_in,
   input wire [4:0] rR2_ID_in,

   input wire rf_we_EX_in,
   input wire rf_we_MEM_in,
   input wire rf_we_WB_in,

   input wire [4:0] wR_EX_in,
   input wire [4:0] wR_MEM_in,
   input wire [4:0] wR_WB_in,

   //data hazard deteced signal
   output wire RAW_A_rR1,
   output wire RAW_A_rR2,

   output wire RAW_B_rR1,
   output wire RAW_B_rR2,

   output wire RAW_C_rR1,
   output wire RAW_C_rR2,

   output wire nop

);
   wire load_use_hazard;

   assign RAW_A_rR1 = wR_EX_in && rR1_read && rf_we_EX_in && (rR1_ID_in == wR_EX_in); 
   assign RAW_A_rR2 = wR_EX_in && rR2_read && rf_we_EX_in && (rR2_ID_in == wR_EX_in);

   assign RAW_B_rR1 = wR_MEM_in && rR1_read && rf_we_MEM_in && (rR1_ID_in == wR_MEM_in);
   assign RAW_B_rR2 = wR_MEM_in && rR2_read && rf_we_MEM_in && (rR2_ID_in == wR_MEM_in);

   assign RAW_C_rR1 = wR_WB_in && rR1_read && rf_we_WB_in && (rR1_ID_in == wR_WB_in);
   assign RAW_C_rR2 = wR_WB_in && rR2_read && rf_we_WB_in && (rR2_ID_in == wR_WB_in);

   assign load_use_hazard = is_load && (RAW_A_rR1 || RAW_A_rR2); //load-use hazard deteced 

   assign nop = load_use_hazard;


endmodule //DHDU