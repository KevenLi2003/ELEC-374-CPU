module sub32 (
    input wire [31:0] RA,
    input wire [31:0] RB,
    output wire [31:0] sum,
    input wire enable,
    output wire c_out
);
    // A - B = A + (-B)
    // calculating the two's complement of B
    wire [31:0] two_complement_B;
    assign two_complement_B = ~RB + 1;

    adder32 add (
        .RA(RA),
        .RB(two_complement_B),
        .sum(sum),
        .c_in(1'b0),
        .c_out(c_out)
    );

    assign sum = enable ? sum : 32'b0;
    assign c_out = enable ? c_out : 1'b0;

endmodule