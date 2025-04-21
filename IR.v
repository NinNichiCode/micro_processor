`timescale 1ns / 1ps
///////////fields of IR
`include "IR_defs.svh"
 
module top();
 
reg [31:0] IR;            ////// instruction register  <--ir[31:27]--><--ir[26:22]--><--ir[21:17]--><--ir[16]--><--ir[15:11]--><--ir[10:0]-->
                          //////fields                 <---  oper  --><--   rdest --><--   rsrc1 --><--modesel--><--  rsrc2 --><--unused  -->             
                          //////fields                 <---  oper  --><--   rdest --><--   rsrc1 --><--modesel--><--  immediate_date      -->      
 
reg [15:0] GPR [31:0] ;   ///////general purpose register gpr[0] ....... gpr[31]
 
reg [15:0] SGPR ;      ///// msb of multiplication --> special register
 
reg [31:0] mul_res;

always@(*)
begin
case(`oper_type)
///////////////////////////////
`movsgpr: begin
 
   GPR[`rdst] = SGPR;
   
end
/////////////////////////////////
`mov : begin
   if(`imm_mode)
        GPR[`rdst]  = `isrc;
   else
       GPR[`rdst]   = GPR[`rsrc1];
end
////////////////////////////////////////////////////
`add : begin
      if(`imm_mode)
        GPR[`rdst]   = GPR[`rsrc1] + `isrc;
     else
        GPR[`rdst]   = GPR[`rsrc1] + GPR[`rsrc2];
end
/////////////////////////////////////////////////////////
`sub : begin
      if(`imm_mode)
        GPR[`rdst]  = GPR[`rsrc1] - `isrc;
     else
       GPR[`rdst]   = GPR[`rsrc1] - GPR[`rsrc2];
end
/////////////////////////////////////////////////////////////
`mul : begin
      if(`imm_mode)
        mul_res   = GPR[`rsrc1] * `isrc;
     else
        mul_res   = GPR[`rsrc1] * GPR[`rsrc2];
        
     GPR[`rdst]   =  mul_res[15:0];
     SGPR         =  mul_res[31:16];
end
/////////////////////////////////////////////////////////////
endcase
end
endmodule