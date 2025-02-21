module or32 (
    input wire [31:0] RA,     // First operand
    input wire [31:0] RB,     // Second operand
    input wire enable,        // Enable signal
    output wire [31:0] Zlow   // Lower 32 bits output for OR result
);
    // Perform bitwise OR operation and pass the result to Zlow
    assign Zlow = enable ? (RA | RB) : 32'b0;

endmodule
