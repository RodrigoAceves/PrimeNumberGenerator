module prime_generator(
  input clk,
  output reg [4095:0] prime
);

  // Function to perform modular exponentiation
  function automatic integer modular_exponentiation;
    input [4095:0] base, exponent, modulus;
    reg [4095:0] result = 1;
    for (int i = 4095; i >= 0; i = i - 1) begin
      result = (result * result) % modulus;
      if (exponent[i] == 1) begin
        result = (result * base) % modulus;
      end
    end
    return result;
  endfunction

  // Function to perform the Miller-Rabin primality test
  function automatic integer miller_rabin_test;
    input [4095:0] n, a;
    reg [4095:0] m = n - 1;
    reg [4095:0] y = modular_exponentiation(a, m, n);
    while (m != 1 && y != 1 && y != n - 1) begin
      y = (y * y) % n;
      m = m / 2;
    end
    if (y != n - 1 && m % 2 == 0) begin
      return 0; // n is composite
    end
    return 1; // n is probably prime
  endfunction

  // Function to perform the AKS primality test
  function automatic integer aks_test;
    input [4095:0] n;
    reg [4095:0] c;
    for (int i = 1; i <= 4095/2; i = i + 1) begin
      c[i] = 1;
      for (int j = 1; j <= i; j = j + 1) begin
        c[i+1-j] = ((c[i+1-j] + c[i-j]) * (i-j+1)) / j;
      end
    end
    c[0] = 1;
    for (int r = 1; r <= 4095/2; r = r + 1) begin
      if (n % r == 0) begin
        continue;
      end
      reg [4095:0] x = modular_exponentiation(2'b10, r, n);
      if (x == 1 || x == n - 1) begin
        continue;
      end
      reg [4095:0] xp = x;
      for (int i = 1; i < c[r]; i = i + 1) begin
        x = (x * xp) % n;
      end
      if (x == 1) begin
        return 0; // n is composite
      end
      if (x == n - 1) begin
        continue;
      end
      for (int i = 1; i < r; i = i + 1) begin
        x = (x * x) % n;
        if (x == n - 1) begin
          continue 'r;
        end
        if (x == 1) begin
          return 0; // n is composite
        end
      end
      return 0; // n is composite
    end
    return 1; // n is prime
  endfunction


// Module to generate prime numbers
module prime_generator(
  input clk,
  output reg [4095:0] prime
);

  reg [4095:0] current_number = 2;
  always @(posedge clk) begin
    while (!aks_test(current_number)) begin
      current_number = current_number + 1;
    end
    prime <= current_number;
    current_number = current_number + 1;
  end

endmodule
