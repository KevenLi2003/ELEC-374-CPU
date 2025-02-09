module shra32 (
    input wire [31:0] RA,
    input wire bits,
    input wire enable,
    output wire [31:0] RZ
);
    assign RZ = enable ? ((RA << rotate_amount) | (RA >> (32 - rotate_amount))) : 32'b0;

endmodule
