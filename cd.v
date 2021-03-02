`include "componentes.v"
`include "memprog.v"
`include "alu.v"

module cd ( input wire clk, reset, s_inc, s_inm, we3, wez, input wire[2:0] op_alu, output wire z, output wire [5:0] opcode);

	wire [9:0] memory_dir;
	wire [9:0] next_operation;
	wire [15:0] memory_data;
	wire [9:0] increment_dir;
	wire [7:0] register_1, register_2;
	wire [7:0] alu_out;
	wire [7:0] wd3;
	wire z_out, zero;

  //Circuito Program Counter
  registro #(10) programcounter (clk, reset, next_operation, memory_dir);
  sum incrementador ( memory_dir, 10'b0000000001, increment_dir);
  mux2 #(10) mux_programcounter (memory_data[9:0], increment_dir,
																 s_inc, next_operation );
  memprog memoria (clk, memory_dir, memory_data);


	//Registros
  regfile banco(clk, we3, memory_data[11:8], memory_data[7:4],
								memory_data[3:0], wd3, register_1, register_2);

  alu alu_1( register_1, register_2, op_alu, alu_out, zero );
  mux2 mux_alu( alu_out, memory_data[11:4], s_inm, wd3);
  ffd flagz(clk, reset, zero, wez, z);

  assign opcode = memory_data[15:10];

endmodule
