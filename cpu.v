`include "uc.v"
`include "cd.v"

module cpu (input wire clk, reset);

wire s_inc, s_inm, we3, wez, z, s_ret, we_ret;
wire [2:0] op_alu;
wire [5:0] opcode;

cd camino_datos (clk, reset, s_inc, s_inm, we3, wez, op_alu, z, opcode);
uc unidad_control (opcode, z, s_inc, s_inm, we3, wez, op_alu);

endmodule
