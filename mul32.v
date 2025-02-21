module mul32 (
    input signed [31:0] RA, // Multiplicand
    input signed [31:0] RB, // Multiplier
    output reg signed [31:0] Zlow,  // Lower 32 bits of the result
    output reg signed [31:0] Zhigh, // Upper 32 bits of the result
    input wire enable // Enable signal for controlling execution
);
    // Registers for Booth’s Algorithm calculations
    reg signed [63:0] multiplicand;      // Fully sign-extended multiplicand
    reg signed [63:0] partialproduct;    // Accumulates the multiplication result
    reg signed [32:0] multiplier;        // One extra bit for encoding Booth’s Algorithm
    integer i;

    always @(*) begin
        if (enable) begin
            // Fully sign-extend multiplicand
            multiplicand = {{32{RA[31]}}, RA}; // Extend RA to 64 bits
            multiplier = {RB, 1'b0};           // Extend RB by adding an extra bit
            partialproduct = 64'b0;            // Initialize accumulator to zero

            // Run Booth’s Algorithm for 32 cycles
            for (i = 0; i < 32; i = i + 1) begin
                // Booth’s Recoding - Process next 2 bits
                case (multiplier[1:0])
                    2'b01: partialproduct = partialproduct + multiplicand; // Add multiplicand
                    2'b10: partialproduct = partialproduct - multiplicand; // Subtract multiplicand
                    default: partialproduct = partialproduct; // No operation for 00 or 11
                endcase
                
                // Arithmetic shift right by 1 for both partialproduct and multiplier
                multiplier = multiplier >>> 1;
                partialproduct = partialproduct >>> 1;
            end

            // Store final multiplication result into Zlow and Zhigh
            Zlow = partialproduct[31:0];     // Lower 32 bits
            Zhigh = partialproduct[63:32];   // Upper 32 bits
        end else begin
            // Reset outputs when disabled
            Zlow = 32'b0;
            Zhigh = 32'b0;
        end
    end
endmodule
