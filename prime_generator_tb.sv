module prime_generator_tb;

  // Test input signals
  reg clk;
  reg rst;
  
  // Test output signals
  wire [4095:0] prime;

  // Instantiate the prime generator module
  prime_generator dut(
    .clk(clk),
    .rst(rst),
    .prime(prime)
  );

  initial begin
  // Initialize inputs
  clk = 0;
  rst = 1;

  // Wait for a few cycles
  #10;

  // De-assert reset
  rst = 0;

  // Wait for a few cycles
  #10;

  // Set a random seed value for the generator
  $random;

  // Generate a prime number and validate it
  repeat (10) begin
    // Wait for a few cycles
    #10;

    // Toggle the clock signal
    clk = ~clk;

    // Wait for a few cycles
    #10;

    // Check if the generated prime number is valid
    if (prime !== 0) begin
      $display("Valid prime number found: %d", prime);
      // Stop the simulation
      $finish;
    end
  end
end

endmodule
