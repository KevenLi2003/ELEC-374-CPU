module or32 (
    input wire [31:0] RA,
    input wire [31:0] RB,
    input wire enable,
    output wire [31:0] RZ
);
    assign RZ = enable ? (RA | RB) : 32'b0;

endmodule