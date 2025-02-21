module div32 (
    input wire clock,
    input wire [31:0] dividend,  // Dividend input
    input wire [31:0] divisor,   // Divisor input
    output reg [31:0] Zlow,      // Lower 32 bits (quotient)
    output reg [31:0] Zhigh,     // Upper 32 bits (remainder)
    input wire enable            // Enable signal
);
    reg [63:0] AQ;  // A + Q in a single 64-bit register
    integer i;

    always @(posedge clock) begin
        if (enable) begin
            // Initialize the values
            AQ = {32'b0, dividend};  // Concatenate 32 bits of zero with the dividend
            Zlow = 0;                // Initialize quotient to 0
            Zhigh = 0;               // Initialize remainder to 0

            // Restoring Division Algorithm
            for (i = 0; i < 32; i = i + 1) begin
                AQ = AQ << 1;  // Left shift by 1
                AQ[63:32] = AQ[63:32] - divisor;  // Subtract divisor (M)

                // Check if subtraction result is negative
                if (AQ[63] == 1) begin
                    AQ[63:32] = AQ[63:32] + divisor;  // Restore previous value
                    AQ[0] = 0;  // Set least significant bit to 0
                end else begin
                    AQ[0] = 1;  // Set least significant bit to 1
                end
            end

            // Store results into Zlow and Zhigh
            Zlow = AQ[31:0];   // Quotient (lower 32 bits)
            Zhigh = AQ[63:32]; // Remainder (upper 32 bits)
        end else begin
            // Reset outputs when not enabled
            Zlow = 32'b0;
            Zhigh = 32'b0;
        end
    end
endmodule
