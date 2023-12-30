module simon32_64 (
	input logic clk, reset,
	input logic [31:0] plaintext,
	input logic [63:0] key,
	output logic [31:0] ciphertext
);

	logic [15:0] round_xin, round_yin, round_xout, round_yout;
	logic [15:0] x_in, y_in;
	logic [31:0] plaintext_r, temp_out;
	logic [63:0] key_r;
	
	logic [511:0] xx_in, yy_in, key_out;
	logic [2047:0] next_key;
	logic [1023:0] z_values;
	logic [31:0] z_0;
	
	assign z_0 = 32'hFA2561CD;
	
	//Register inputs
	always_ff @(posedge clk) begin
		plaintext_r <= plaintext;
		key_r <= key;
	end
	
	assign x_in = plaintext_r[31:16];
	assign y_in = plaintext_r[15:0];
	
	round round_function_1 (clk, reset, x_in, y_in, key_out[15:0],
							xx_in[15:0], yy_in[15:0]);

	key_gen key_generator_1(clk, reset, key_r, z_0, z_values[31:0],
							key_out[15:0], next_key[63:0]);
							
	//Unroll Encryption loop
	generate
		genvar i;
		for(i=1; i<32; i=i+1) begin : encryption
			round round_function (clk, reset, xx_in[(i-1)*16 +: 16], yy_in[(i-1)*16 +: 16], 
									key_out[i*16 +: 16], xx_in[i*16 +: 16], yy_in[i*16 +: 16]);
									
			key_gen key_generator(clk, reset, next_key[(i-1)*64 +: 64], z_values[(i-1)*32 +: 32], z_values[i*32 +: 32],
									key_out[i*16 +: 16], next_key[i*64 +: 64]);
		end
	endgenerate
	
	always_ff @(posedge clk) begin
		if (reset)
			temp_out <= {32{1'b0}};
		else
			temp_out <= {{xx_in[511:496]},{yy_in[511:496]}};			
	end
	
	assign ciphertext = temp_out;
	
endmodule
