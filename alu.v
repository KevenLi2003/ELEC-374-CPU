module alu (
    input wire clk, 
    input wire [31:0] A, B, 
    input wire [3:0] ALU_control, 
    output reg [31:0] result, 
    output reg [31:0] Zlow, Zhigh  // Two 32-bit registers for 64-bit results
);

    // Intermediate wires for operation results
    wire [31:0] add_result, sub_result, and_result, or_result, neg_result, not_result;
    wire [31:0] shl_result, shr_result, shra_result, ror_result, rol_result;
    wire [31:0] mul_result_low, mul_result_high, div_result_low, div_result_high;

    // Enable signals for each operation
    reg enable_add, enable_sub, enable_mul, enable_div;
    reg enable_and, enable_or, enable_neg, enable_not;
    reg enable_shl, enable_shr, enable_shra, enable_ror, enable_rol;

    // Submodules for arithmetic and logic operations
    adder32 ADD (
        .RA(A),
        .RB(B),
        .sum(add_result),
        .Zlow(add_result),  // Since Zlow directly takes the sum
        .enable(enable_add),
        .c_in(1'b0),
        .c_out()
    );

    sub32 SUB (
        .RA(A),
        .RB(B),
        .enable(enable_sub),
        .Zlow(sub_result),
        .c_out()
    );

    mul32 MUL (
        .RA(A),
        .RB(B),
        .Zlow(mul_result_low),
        .Zhigh(mul_result_high),
        .enable(enable_mul)
    );

    div32 DIV (
        .clock(clk),
        .dividend(A),
        .divisor(B),
        .Zlow(div_result_low),
        .Zhigh(div_result_high),
        .enable(enable_div)
    );

    and32 AND_OP (
        .RA(A),
        .RB(B),
        .enable(enable_and),
        .Zlow(and_result)
    );

    or32 OR_OP (
        .RA(A),
        .RB(B),
        .enable(enable_or),
        .Zlow(or_result)
    );

    neg32 NEG_OP (
        .RA(A),
        .enable(enable_neg),
        .Zlow(neg_result)
    );

    not32 NOT_OP (
        .RA(A),
        .enable(enable_not),
        .Zlow(not_result)
    );

    shl32 SHL_OP (
        .RA(A),
        .bits(B[4:0]),
        .enable(enable_shl),
        .Zlow(shl_result)
    );

    shr32 SHR_OP (
        .RA(A),
        .bits(B[4:0]),
        .enable(enable_shr),
        .Zlow(shr_result)
    );

    shra32 SHRA_OP (
        .RA(A),
        .bits(B[4:0]),
        .enable(enable_shra),
        .Zlow(shra_result)
    );

    ror32 ROR_OP (
        .RA(A),
        .bits(B[4:0]),
        .enable(enable_ror),
        .Zlow(ror_result)
    );

    rol32 ROL_OP (
        .RA(A),
        .bits(B[4:0]),
        .enable(enable_rol),
        .Zlow(rol_result)
    );

    // Main ALU control logic
    always @(posedge clk) begin
        // Reset all enable signals
        enable_add = 0; enable_sub = 0; enable_mul = 0; enable_div = 0;
        enable_and = 0; enable_or = 0; enable_neg = 0; enable_not = 0;
        enable_shl = 0; enable_shr = 0; enable_shra = 0; enable_ror = 0; enable_rol = 0;

        // Clear result registers
        result = 32'b0;
        Zlow = 32'b0;
        Zhigh = 32'b0;

        // ALU Control Operation
        case (ALU_control)
            4'b0000: begin  // ADD
                enable_add = 1;
                result = add_result;
                Zlow = add_result;
            end
            4'b0001: begin  // SUB
                enable_sub = 1;
                result = sub_result;
                Zlow = sub_result;
            end
            4'b0010: begin  // AND
                enable_and = 1;
                result = and_result;
                Zlow = and_result;
            end
            4'b0011: begin  // OR
                enable_or = 1;
                result = or_result;
                Zlow = or_result;
            end
            4'b0100: begin  // SHL
                enable_shl = 1;
                result = shl_result;
                Zlow = shl_result;
            end
            4'b0101: begin  // SHR
                enable_shr = 1;
                result = shr_result;
                Zlow = shr_result;
            end
            4'b0110: begin  // SHRA
                enable_shra = 1;
                result = shra_result;
                Zlow = shra_result;
            end
            4'b0111: begin  // ROR
                enable_ror = 1;
                result = ror_result;
                Zlow = ror_result;
            end
            4'b1000: begin  // ROL
                enable_rol = 1;
                result = rol_result;
                Zlow = rol_result;
            end
            4'b1001: begin  // NOT
                enable_not = 1;
                result = not_result;
                Zlow = not_result;
            end
            4'b1010: begin  // NEG
                enable_neg = 1;
                result = neg_result;
                Zlow = neg_result;
            end
            4'b1110: begin  // MUL
                enable_mul = 1;
                Zlow = mul_result_low;
                Zhigh = mul_result_high;
            end
            4'b1111: begin  // DIV
                enable_div = 1;
                Zlow = div_result_low;
                Zhigh = div_result_high;
            end
            default: begin
                result = 32'b0;  // Default case
                Zlow = 32'b0;
                Zhigh = 32'b0;
            end
        endcase
    end
endmodule