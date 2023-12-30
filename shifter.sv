module shifter #(
  parameter WIDTH = 16
)  
(
  input logic [WIDTH-1:0] shift_in,
  input logic direction,
  input logic [($clog2(WIDTH))-1:0] shift_amount,
  output logic [WIDTH-1:0] shift_out
);
  
  // To set the direction bit 1 = right, and 0 = left.
  logic [WIDTH-1:0] temp ;
  
  always_comb begin
    if (direction == 1'b1)
      temp = (shift_in >> shift_amount) | (shift_in << (WIDTH - shift_amount));
    else
      temp = (shift_in << shift_amount) | (shift_in >> (WIDTH - shift_amount));
  end
  
  assign shift_out = temp;

endmodule
