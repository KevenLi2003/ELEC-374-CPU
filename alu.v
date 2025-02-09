module alu (
    input wire clk, 
    input wire [31:0] A, B, 
    input wire [3:0] ALU_control, 
    output reg [31:0] result, 
    output reg [31:0] Zlow, Zhigh
);

    wire [31:0] add_result, sub_result, and_result, or_result, neg_result, not_result, shl_result, shr_result, shra_result, ror_result, rol_result, mul_result_low, mul_result_high, div_result;

    reg enable_add, enable_sub, enable_mul, enable_div, enable_and, enable_or, enable_neg, enable_not, enable_shl, enable_shr, enable_shra, enable_ror, enable_rol;

    adder32 ADD (.A(A), .B(B), .sum(add_result), .enable(enable_add));
    sub32 SUB (.A(A), .B(B), .diff(sub_result), .enable(enable_sub));
    mul32 MUL (.A(A), .B(B), .Zlow(mul_result_low), .Zhigh(mul_result_high), .enable(enable_mul));
    div32 DIV (.clk(clk), .A(A), .B(B), .quotient(div_result), .enable(enable_div));

    and32 AND (.A(A), .B(B), .result(and_result), .enable(enable_and));
    or32 OR (.A(A), .B(B), .result(or_result), .enable(enable_or));
    neg32 NEG (.A(A), .result(neg_result), .enable(enable_neg));
    not32 NOT (.A(A), .result(not_result), .enable(enable_not));

    shl32 SHL (.A(A), .B(B), .result(shl_result), .enable(enable_shl));
    shr32 SHR (.A(A), .B(B), .result(shr_result), .enable(enable_shr));
    shra32 SHRA (.A(A), .B(B), .result(shra_result), .enable(enable_shra));
    ror32 ROR (.A(A), .B(B), .result(ror_result), .enable(enable_ror));
    rol32 ROL (.A(A), .B(B), .result(rol_result), .enable(enable_rol));

    always @(*) begin
        enable_add = 0; enable_sub = 0; enable_mul = 0; enable_div = 0;
        enable_and = 0; enable_or = 0; enable_neg = 0; enable_not = 0;
        enable_shl = 0; enable_shr = 0; enable_shra = 0; enable_ror = 0; enable_rol = 0;
        
        result = 32'b0;
        Zlow = 32'b0;
        Zhigh = 32'b0;

        case (ALU_control)
            4'b0000: begin enable_add = 1; result = add_result; end // ADD
            4'b0001: begin enable_sub = 1; result = sub_result; end // SUB
            4'b0010: begin enable_and = 1; result = and_result; end // AND
            4'b0011: begin enable_or = 1; result = or_result; end // OR
            4'b0100: begin enable_shl = 1; result = shl_result; end // SHL
            4'b0101: begin enable_shr = 1; result = shr_result; end // SHR
            4'b0110: begin enable_shra = 1; result = shra_result; end // SHRA
            4'b0111: begin enable_ror = 1; result = ror_result; end // ROR
            4'b1000: begin enable_rol = 1; result = rol_result; end // ROL
            4'b1001: begin enable_not = 1; result = not_result; end // NOT
            4'b1011: begin enable_neg = 1; result = neg_result; end // NEGATE
            4'b1110: begin // MUL
                enable_mul = 1;
                Zlow = mul_result_low;
                Zhigh = mul_result_high;
            end
            4'b1111: begin enable_div = 1; result = div_result; end // DIV
            default: result = 32'b0;
        endcase
    end
endmodule