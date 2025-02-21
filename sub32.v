module sub32 (
    input wire [31:0] RA,       // Minuend
    input wire [31:0] RB,       // Subtrahend
    input wire enable,          // Enable signal
    output wire [31:0] Zlow,    // Lower 32 bits result (A - B)
    output wire c_out           // Carry-out (borrow)
);
    // A - B = A + (-B)
    // Calculating the two's complement of B
    wire [31:0] two_complement_B;
    wire [31:0] sum_result;

    assign two_complement_B = ~RB + 1;  // Two's complement of B

    // Use 32-bit adder for subtraction
    adder32 add (
        .RA(RA),
        .RB(two_complement_B),
        .sum(sum_result),
        .c_in(1'b0),
        .c_out(c_out)
    );

    // Pass result to Zlow only if enabled
    assign Zlow = enable ? sum_result : 32'b0;
    assign c_out = enable ? c_out : 1'b0;

endmodule

