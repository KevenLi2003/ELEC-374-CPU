module mul32 (
    input signed [31:0] RA, // multiplicand
    input signed [31:0] RB, // multiplier
    output reg signed [63:0] product, // dynamically calculated 2n-bit product
    input wire enable // enable signal for controlling execution
);
    // registers for Booth’s Algorithm calculations
    reg signed [63:0] multiplicand; // fully sign-extended multiplicand
    reg signed [63:0] partialproduct; // accumulates the multiplication result
    reg signed [32:0] multiplier; // one extra bit for encoding Booth’s Algorithm
    integer i;

    always @(*) begin
        if (enable) begin // compute only when enabled
            // fully sign-extend multiplicand
            multiplicand = {{32{RA[31]}}, RA}; // extend `RA` to 64 bits
            multiplier = {RB, 1'b0}; // extend `RB` by adding an extra bit
            partialproduct = 64'b0; // zero-initialize

            // run Booth’s Algorithm for 32 cycles
            for (i = 0; i < 32; i++) begin
                // dynamically sign-extend `partialproduct`
                partialproduct = { {($bits(partialproduct) - $clog2(partialproduct)){partialproduct[$clog2(partialproduct)-1]}}, partialproduct };

                // booth’s Recoding - Process next 2 bits
                case (multiplier[1:0])
                    2'b01: partialproduct = partialproduct + multiplicand; // add `multiplicand` for `01`
                    2'b10: partialproduct = partialproduct - multiplicand; // subtract `multiplicand` for `10`
                    default: partialproduct = partialproduct; // no operation for `00` or `11`
                endcase
                
                // shifting for the Next Step
                multiplicand = multiplicand << 2; // shift left by 2 for Booth’s
                multiplier = multiplier >>> 2;    
                partialproduct = partialproduct >>> 2; 
            end

            // store final multiplication result
            product = partialproduct; 
            end else begin
            // reset product when disabled
            product = 64'b0; 
        end
    end
endmodule