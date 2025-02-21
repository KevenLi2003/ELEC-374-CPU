module shl32 (
    input wire [31:0] RA,
    input wire bits,
    input wire enable,
    output wire [31:0] Zlow
);
    assign Zlow = enable ? (RA << bits) : 32'b0;
    
endmodule
