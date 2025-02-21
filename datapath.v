module datapath (
    input wire clk, reset,
    
    // Control signals
    input wire [31:0] Mdatain,
    input wire PCout, Zhighout, Zlowout, MDRout, R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out,
    input wire HIout, LOout, IRout, MARout, InPortout, OutPortout,
    input wire PCin, Zin, Zhighin, Zlowin, MDRin, R0in, R1in, R2in, R3in, R4in, R5in, R6in, R7in, R8in, R9in, R10in, R11in, R12in, R13in, R14in, R15in, HIin, LOin, IRin, MARin, Yin,
    input wire Read, Write, IncPC,

    // ALU control signals
    input wire ADD, SUB, MUL, DIV, AND, OR, SHR, SHRA, SHL, ROR, ROL, NEG, NOT,

    // Output
    output wire [31:0] BusMuxOut
);

    // Internal signals
    wire [31:0] bus_out, Yout, alu_result_low, alu_result_high;
    wire [63:0] Z;

    // Registers
    reg32 PC(.clk(clk), .reset(reset), .in(PCin), .out(PCout), .data_in(bus_out), .data_out(PC_out));
    reg32 IR(.clk(clk), .reset(reset), .in(IRin), .out(IRout), .data_in(bus_out), .data_out(IR_out));
    reg32 HI(.clk(clk), .reset(reset), .in(HIin), .out(HIout), .data_in(bus_out), .data_out(HI_out));
    reg32 LO(.clk(clk), .reset(reset), .in(LOin), .out(LOout), .data_in(bus_out), .data_out(LO_out));
    reg32 MAR(.clk(clk), .reset(reset), .in(MARin), .out(MARout), .data_in(bus_out), .data_out(MAR_out));
    reg32 MDR(.clk(clk), .reset(reset), .in(MDRin), .out(MDRout), .data_in(bus_out), .data_out(MDR_out));
    reg32 Y(.clk(clk), .reset(reset), .in(Yin), .out(), .data_in(bus_out), .data_out(Yout));

    // Registers R0-R15
    wire [31:0] R[15:0];
    generate
        genvar i;
        for (i = 0; i < 16; i = i + 1) begin : REGISTERS
            reg32 Reg(.clk(clk), .reset(reset), 
                      .in({R0in, R1in, R2in, R3in, R4in, R5in, R6in, R7in, R8in, R9in, R10in, R11in, R12in, R13in, R14in, R15in}[i]),
                      .out({R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out}[i]),
                      .data_in(bus_out), 
                      .data_out(R[i]));
        end
    endgenerate

    // ALU
    alu ALU (
        .A(Yout),
        .B(bus_out),
        .ADD(ADD), .SUB(SUB), .MUL(MUL), .DIV(DIV),
        .AND(AND), .OR(OR), .SHR(SHR), .SHRA(SHRA),
        .SHL(SHL), .ROR(ROR), .ROL(ROL), .NEG(NEG), .NOT(NOT),
        .Zlow(alu_result_low), .Zhigh(alu_result_high)
    );

    // Z Register (64-bit for multiplication/division results)
    reg64 Z_reg (.clk(clk), .reset(reset), .in(Zin), .data_in({alu_result_high, alu_result_low}), .data_out(Z));
    assign Zhigh = Z[63:32];
    assign Zlow = Z[31:0];

    // Bus logic (Tri-state buffer style implementation)
    bus Bus (
        .R0(R[0]), .R1(R[1]), .R2(R[2]), .R3(R[3]), .R4(R[4]), .R5(R[5]), .R6(R[6]), .R7(R[7]),
        .R8(R[8]), .R9(R[9]), .R10(R[10]), .R11(R[11]), .R12(R[12]), .R13(R[13]), .R14(R[14]), .R15(R[15]),
        .HI(HI_out), .LO(LO_out), .PC(PC_out), .IR(IR_out), .MDR(MDR_out),
        .Zhigh(Zhigh), .Zlow(Zlow),
        .R0out(R0out), .R1out(R1out), .R2out(R2out), .R3out(R3out), .R4out(R4out),
        .R5out(R5out), .R6out(R6out), .R7out(R7out), .R8out(R8out), .R9out(R9out),
        .R10out(R10out), .R11out(R11out), .R12out(R12out), .R13out(R13out), .R14out(R14out), .R15out(R15out),
        .HIout(HIout), .LOout(LOout), .PCout(PCout), .IRout(IRout), .MDRout(MDRout),
        .Zhighout(Zhighout), .Zlowout(Zlowout),
        .bus_out(bus_out)
    );

endmodule