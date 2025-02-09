module shr32 (
    input wire [31:0] RA,
    input wire bits,
    input wire enable,
    output wire [31:0] RZ
)
    assign RZ = enable ? (RA >> bits) : 32'b0;
    
endmodule