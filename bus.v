module bus (
    input wire [31:0] R0, R1, R2, R3, R4, R5, R6, R7, R8, R9, R10, R11, R12, R13, R14, R15, 
    input wire [31:0] HI, LO, PC, IR, MDR, Zhigh, Zlow,
    input wire R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out,
    input wire HIout, LOout, PCout, IRout, MDRout, Zhighout, Zlowout,
    output wire [31:0] bus_out
);
    reg [31:0] data;
    always @(*) begin
        if (R0out) data = R0;
        else if (R1out) data = R1;
        else if (R2out) data = R2;
        else if (R3out) data = R3;
        else if (R4out) data = R4;
        else if (R5out) data = R5;
        else if (R6out) data = R6;
        else if (R7out) data = R7;
        else if (R8out) data = R8;
        else if (R9out) data = R9;
        else if (R10out) data = R10;
        else if (R11out) data = R11;
        else if (R12out) data = R12;
        else if (R13out) data = R13;
        else if (R14out) data = R14;
        else if (R15out) data = R15;
        else if (HIout) data = HI;
        else if (LOout) data = LO;
        else if (PCout) data = PC;
        else if (IRout) data = IR;
        else if (MDRout) data = MDR;
        else if (Zhighout) data = Zhigh;
        else if (Zlowout) data = Zlow;
        else data = 32'bz;
    end    

    assign bus_out = data;
endmodule