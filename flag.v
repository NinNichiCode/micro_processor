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
 
///////////////////////////////////////////////////////////// bitwise or
 
`ror : begin
      if(`imm_mode)
        GPR[`rdst]  = GPR[`rsrc1] | `isrc;
     else
       GPR[`rdst]   = GPR[`rsrc1] | GPR[`rsrc2];
end
 
////////////////////////////////////////////////////////////bitwise and
 
`rand : begin
      if(`imm_mode)
        GPR[`rdst]  = GPR[`rsrc1] & `isrc;
     else
       GPR[`rdst]   = GPR[`rsrc1] & GPR[`rsrc2];
end
 
//////////////////////////////////////////////////////////// bitwise xor
 
`rxor : begin
      if(`imm_mode)
        GPR[`rdst]  = GPR[`rsrc1] ^ `isrc;
     else
       GPR[`rdst]   = GPR[`rsrc1] ^ GPR[`rsrc2];
end
 
//////////////////////////////////////////////////////////// bitwise xnor
 
`rxnor : begin
      if(`imm_mode)
        GPR[`rdst]  = GPR[`rsrc1] ~^ `isrc;
     else
        GPR[`rdst]   = GPR[`rsrc1] ~^ GPR[`rsrc2];
end
 
//////////////////////////////////////////////////////////// bitwisw nand
 
`rnand : begin
      if(`imm_mode)
        GPR[`rdst]  = ~(GPR[`rsrc1] & `isrc);
     else
       GPR[`rdst]   = ~(GPR[`rsrc1] & GPR[`rsrc2]);
end
 
////////////////////////////////////////////////////////////bitwise nor
 
`rnor : begin
      if(`imm_mode)
        GPR[`rdst]  = ~(GPR[`rsrc1] | `isrc);
     else
       GPR[`rdst]   = ~(GPR[`rsrc1] | GPR[`rsrc2]);
end
 
////////////////////////////////////////////////////////////not
`rnot : begin
      if(`imm_mode)
        GPR[`rdst]  = ~(`isrc);
     else
        GPR[`rdst]   = ~(GPR[`rsrc1]);
end
 
////////////////////////////////////////////////////////////
endcase
end
///////////////////////logic for condition flag
reg sign = 0, zero = 0, overflow = 0, carry = 0;
reg [16:0] temp_sum;
 
always@(*)
begin
 
/////////////////sign bit
if(`oper_type == `mul)
  sign = SGPR[15];
else
  sign = GPR[`rdst][15];
 
////////////////carry bit
 
if(`oper_type == `add)
   begin
      if(`imm_mode)
         begin
         temp_sum = GPR[`rsrc1] + `isrc;
         carry    = temp_sum[16]; 
         end
      else
         begin
         temp_sum = GPR[`rsrc1] + GPR[`rsrc2];
         carry    = temp_sum[16]; 
         end   end
   else
    begin
        carry  = 1'b0;
    end
 
///////////////////// zero bit
if(`oper_type == `mul)
  zero =  ~((|SGPR[15:0]) | (|GPR[`rdst]));
else
  zero =  ~(|GPR[`rdst]); 
 
 
//////////////////////overflow bit
 
if(`oper_type == `add)
     begin
       if(`imm_mode)
         overflow = ( (~GPR[`rsrc1][15] & ~IR[15] & GPR[`rdst][15] ) | (GPR[`rsrc1][15] & IR[15] & ~GPR[`rdst][15]) );
       else
         overflow = ( (~GPR[`rsrc1][15] & ~GPR[`rsrc2][15] & GPR[`rdst][15]) | (GPR[`rsrc1][15] & GPR[`rsrc2][15] & ~GPR[`rdst][15]));
     end
  else if(`oper_type == `sub)
    begin
       if(`imm_mode)
         overflow = ( (~GPR[`rsrc1][15] & IR[15] & GPR[`rdst][15] ) | (GPR[`rsrc1][15] & ~IR[15] & ~GPR[`rdst][15]) );
       else
         overflow = ( (~GPR[`rsrc1][15] & GPR[`rsrc2][15] & GPR[`rdst][15]) | (GPR[`rsrc1][15] & ~GPR[`rsrc2][15] & ~GPR[`rdst][15]));
    end 
  else
     begin
     overflow = 1'b0;
     end
 
end
 
endmodule
 