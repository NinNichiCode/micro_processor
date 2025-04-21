`ifndef IR_DEFS_SVH
`define IR_DEFS_SVH

///////////fields of IR
`define oper_type IR[31:27]
`define rdst      IR[26:22]
`define rsrc1     IR[21:17]
`define imm_mode  IR[16]
`define rsrc2     IR[15:11]
`define isrc      IR[15:0]
 
 
////////////////arithmetic operation
`define movsgpr        5'b00000
`define mov            5'b00001
`define add            5'b00010
`define sub            5'b00011
`define mul            5'b00100
 
////////////////logical operations : and or xor xnor nand nor not
 
`define ror            5'b00101
`define rand           5'b00110
`define rxor           5'b00111
`define rxnor          5'b01000
`define rnand          5'b01001
`define rnor           5'b01010
`define rnot           5'b01011

`endif
