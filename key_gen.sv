module key_gen (
  input logic clk, reset,
  input logic [63:0] key_in,
  input logic [31:0] z_in,
  output logic [31:0] z_out,
  output logic [15:0] key_out,
  output logic [63:0] next_key 
);
  
  logic [15:0] k1;
  logic [15:0] k2;
  logic [15:0] k3;
  logic [15:0] k4;
  logic [15:0] encrypt_c, k4_shifted, temp_1_shifted, C_Z; //Intermediate values, usefule for debugging
  logic [15:0] temp_1, temp_2, temp_3, temp_4; 			   //Intermediate values, usefule for debugging
  logic [31:0] z_shifted, z_temp;
  
  //Shift modules
  shifter #(16) S1 (k4, 1'b1, 4'd3, k4_shifted);
  shifter #(16) S2 (temp_1, 1'b1, 4'd1, temp_1_shifted); 
  shifter #(32) S3 (z_in, 1'b0, 5'd1, z_shifted); 
  
  always_comb begin
	k1 = key_in[15:0];
	k2 = key_in[31:16];
	k3 = key_in[47:32];
	k4 = key_in[63:48];
  end
  
  //encryption
  always_comb begin
	C_Z = {{15'd0},{z_in[31]}};
	temp_1 = k4_shifted ^ k2;
	temp_2 = (temp_1 ^ k1);
	temp_3 = temp_2 ^ temp_1_shifted;
	temp_4 = 16'hfffc ^ C_Z;
	encrypt_c = temp_3 ^ temp_4;
  end
  
  always_ff @(posedge clk) begin
	if (reset) begin
		next_key <= {64{1'b0}};
		z_temp <= {32{1'b0}};
	end
	else begin
		next_key <= {{encrypt_c},{k4},{k3},{k2}};
		z_temp <= z_shifted;
	end
  end

  assign z_out = z_temp;
  assign key_out = k1;
  
endmodule