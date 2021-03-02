`timescale 1 ns / 10 ps


module uc (input wire [5:0] opcode, input wire z, output reg s_inc, s_inm, we3, wez, output wire [2:0] op_alu);

parameter noop =			6'b000000;
parameter jump = 			6'b000001;
parameter jumpz = 		6'b000010;
parameter nojumpz = 	6'b000011;
parameter limm = 			6'b0001XX;

assign op_alu = opcode[4:2];

always @ (opcode)
begin
	if (opcode[5] == 1'b1)
	begin
		s_inc = 1;
		s_inm = 0;
		wez = 1;
		we3 = 1;
	end
	else
		begin
		casex (opcode)
			noop:
			begin
				s_inc = 1;
				wez = 0;
				s_inm = 0;
				we3 = 0;
			end

			jump:
			begin
				s_inc = 0;
				wez = 0;
				s_inm = 0;
				we3 = 0;
			end

			jumpz:
			begin
				wez = 0;
				s_inm = 0;
				we3 = 0;
				if (z)
					s_inc = 0;
				else
					s_inc = 1;
			end

			nojumpz:
			begin
				wez = 0;
				s_inm = 0;
				we3 = 0;
				if (~z)
					s_inc = 0;
				else
					s_inc = 1;
			end

			limm:
			begin
				s_inc = 1;
				wez = 0;
				s_inm = 1;
				we3 = 1;
			end
			
			default:
			begin
				s_inc = 1;
				wez = 0;
				s_inm = 0;
				we3 = 0;
			end
		endcase
		end
end

endmodule
