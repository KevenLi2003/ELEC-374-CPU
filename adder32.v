module adder32 (
    input wire [31:0] RA,
    input wire [31:0] RB,
    output wire [31:0] sum,
    input wire enable; // for ALU, only perform addition when enabled
    input c_in,
    output wire c_out
);
    wire c_out_internal;
    adder16 lower (
        .RA(RA[15:0]),
        .RB(RB[15:0]),
        .c_in(c_in),
        .enable(enable),
        .sum(sum[15:0]), 
        .c_out(c_out_internal)
    );
    adder16 upper (
        .RA(RA[31:16],
        .RB(RB[31:16]),
        .c_in(c_out_internal),
        .enable(enable)
        .sum(sum[31:16]),
        .c_out(c_out))
    );

    assign sum = enable ? sum : 32'b0;

endmodule

module adder16 (
    input wire [15:0] RA,
    input wire [15:0] RB,
    output wire [15:0] sum,
    input wire enable, // for ALU, only perform addition when enabled
    input c_in,
    output c_out
);
    wire c_out1, c_out2, c_out3;

    adder4 adder1_4 (
        .RA(RA[3:0]), 
        .RB(RB[3:0]), 
        .c_in(c_in), 
        .enable(enable),
        .sum(sum[3:0]), 
        .c_out(c_out1)
    )
    ;
    adder4 adder5_8 (
        .RA(RA[7:4]),
        .RB(RB[7:4]), 
        .c_in(c_out1),
        .enable(enable), 
        .sum(sum[7:4]), 
        .c_out(c_out2)
    );

    adder4 adder9_12 (
        .RA(RA[11:8]), 
        .RB(RB[11:8]), 
        .c_in(c_out2), 
        .enable(enable),
        .sum(sum[11:8]), 
        .c_out(c_out3)
    );

    adder4 adder13_16 (
        .RA(RA[15:12]), 
        .RB(RB[15:12]), 
        .c_in(c_out3), 
        .enable(enable),
        .sum(sum[15:12]), 
        .c_out(c_out)
    );

    assign sum = enable ? sum : 16'b0;

endmodule

module adder4 (
    input wire [3:0] RA, // addend
    input wire [3:0] RB, // addend
    output wire [3:0] sum, // sum
    input wire enable, // for ALU, only perform addition when enabled
    input c_in, // carry in
    output wire c_out // carry out
);
    // generation, propogation, carry signals
    wire [3:0] g;
    wire [3:0] p;
    wire [3:0] c; // three bits carry-in's and a carry-out

    // calculate propogation and generate functions
    assign g = RA & RB;
    assign p = RA | RB;

    // carries calculation
    assign c[0] = c_in;
    assign c[1] = g[0] | p[0] & c[0];
    assign c[2] = g[1] | p[1] & c[1];
    assign c[3] = g[2] | p[2] & c[2];
    assign c_out = g[3] | p[3] & c[3];

    // sum calculations
    assign sum = RA ^ RB ^ c;
    assign sum = enable ? sum : 4'b0;
endmodule