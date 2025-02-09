module div32 (
    input wire clock,
    input wire [31:0] dividend,
    input wire [31:0] divisor,
    output reg [31:0] quotient,
    output reg [31:0] remainder, 
    input wire enable
);
    reg [63:0] AQ; // A + Q in a single 64-bit reg
    integer i;

    always @(posedge clock) begin
        if (enable) begin
            // initialize the values
            AQ = {32'b0, dividend};
            quotient = 0;
            remainder = 0;

            for (i = 0; i < 32; i++) begin
                AQ = AQ << 1; // left shift by 1
                AQ[63:32] = AQ[63:32] - divisor; // subtract M
                if (AQ[63] == 1) begin
                    AQ[63:32] = AQ[63:32] + divisor;
                    AQ[0] = 0;
                end else begin
                    AQ[0] = 1;
                end
            end
            quotient = AQ[31:0];
            remainder = AQ[63:32];
        end else begin
            quotient = 32'b0;
            remainder = 32'b0;
        end
    end
    
endmodule