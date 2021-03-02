//Componentes varios

//Banco de registros de dos salidas y una entrada
module regfile(input  wire        clk, 
               input  wire        we3,           //señal de habilitación de escritura
               input  wire [3:0]  ra1, ra2, wa3, //direcciones de regs leidos y reg a escribir
               input  wire [7:0]  wd3, 			 //dato a escribir
               output wire [7:0]  rd1, rd2);     //datos leidos

  reg [7:0] regb[0:15]; //memoria de 16 registros de 8 bits de ancho

  initial
  begin
    $readmemb("regfile.dat",regb); // inicializa los registros a valores conocidos
  end  
  
  // El registro 0 siempre es cero
  // se leen dos reg combinacionalmente
  // y la escritura del tercero ocurre en flanco de subida del reloj
  
  always @(posedge clk)
    if (we3) regb[wa3] <= wd3;	
  
  assign rd1 = (ra1 != 0) ? regb[ra1] : 0;
  assign rd2 = (ra2 != 0) ? regb[ra2] : 0;

endmodule

//modulo sumador  
module sum(input  wire [9:0] a, b,
             output wire [9:0] y);

  assign y = a + b;

endmodule



//modulo registro para modelar el PC, cambia en cada flanco de subida de reloj o de reset
module registro #(parameter WIDTH = 8)
              (input wire             clk, reset,
               input wire [WIDTH-1:0] d, 
               output reg [WIDTH-1:0] q);

  always @(posedge clk, posedge reset)
    if (reset) q <= 0;
    else       q <= d;

endmodule

//Modulo multiplexor para la entrada.
module iomux #(parameter WIDTH = 8) (input wire [WIDTH-1:0] d0, d1, d2, d3, input wire [1:0] s, output reg [7:0] y);
always @(*)
begin
	case(s)
		2'b00:
		y = d0;
		2'b01:
		y = d1;
		2'b10:
		y = d2;
		2'b11:
		y = d3;
	endcase
end
endmodule
//modulo multiplexor, si s=1 sale d1, s=0 sale d0
module mux2 #(parameter WIDTH = 8)
             (input  wire [WIDTH-1:0] d0, d1, 
              input  wire             s, 
              output wire [WIDTH-1:0] y);

  assign y = s ? d1 : d0; 

endmodule

//Biestable para el flag de cero
//Biestable tipo D síncrono con reset asíncrono por flanco y entrada de habilitación de carga
module ffd(input wire clk, reset, d, carga, output reg q);

  always @(posedge clk, posedge reset)
    if (reset)
	    q <= 1'b0;
	  else
	    if (carga)
	      q <= d;

endmodule 

module deco (input wire[1:0] in, output wire[3:0] out);
	assign out = 1 << in;
endmodule


module banco_salida (input wire[7:0] in, input wire[1:0] select, input wire we, output wire[7:0] o0, o1, o2, o3);
	wire we0, we1, we2, we3;
	wire [3:0] dec_out;

	deco decoder(select, dec_out);

	assign we0 = we & dec_out[0];
	assign we1 = we & dec_out[1];
	assign we2 = we & dec_out[2];
	assign we3 = we & dec_out[3];

	registro out0(we0, 1'b0, in, o0);
	registro out1(we1, 1'b0, in, o1);
	registro out2(we2, 1'b0, in, o2);
	registro out3(we3, 1'b0, in, o3);

endmodule

