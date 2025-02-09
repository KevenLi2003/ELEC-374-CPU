module neg32 (
    input wire [31:0] RA,
    input wire enable,
    output wire [31:0] RZ
);
    assign RZ = enable ? ~RA : 32'b0;

endmodule