module neg32 (
    input wire [31:0] RA,     // Input operand
    input wire enable,        // Enable signal
    output wire [31:0] Zlow   // Lower 32 bits output (negation result)
);
    // Perform two's complement negation and pass the result to Zlow
    assign Zlow = enable ? (~RA + 1) : 32'b0;

endmodule
