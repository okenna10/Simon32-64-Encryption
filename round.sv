module round (
  input logic clk, reset,
  input logic [15:0] x_in, y_in, key_in,
  output logic [15:0] x_out, y_out
);
  
  logic [15:0] S1_sig, S2_sig, S8_sig;
  logic [15:0] x_temp, y_temp;
    
  shifter #(16) S1 (x_in, 1'b0, 4'd1, S1_sig);
  shifter #(16) S2 (x_in, 1'b0, 4'd8, S8_sig);
  shifter #(16) S3 (x_in, 1'b0, 4'd2, S2_sig);
  
  always_ff @(posedge clk) begin
	  if (reset) begin
		x_temp <= 16'h00;
		y_temp <= 16'h00;
	  end
	  else begin
		x_temp <= (S1_sig & S8_sig) ^ y_in ^ S2_sig ^ key_in;
		y_temp <= x_in;
	  end
  end
  
  assign x_out = x_temp;
  assign y_out = y_temp;
  
endmodule
