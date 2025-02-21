module datapath (
    input wire clk, reset,

    // Control signals
    input wire [31:0] Mdatain,
    input wire PCout, Zhighout, Zlowout, MDRout, R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out,
    input wire HIout, LOout, IRout, MARout, InPortout, OutPortout,
    input wire PCin, Zhighin, Zlowin, MDRin, R0in, R1in, R2in, R3in, R4in, R5in, R6in, R7in, R8in, R9in, R10in, R11in, R12in, R13in, R14in, R15in, HIin, LOin, IRin, MARin, Yin,
    input wire Read, Write, IncPC,

    // ALU control signals
    input wire ADD, SUB, MUL, DIV, AND, OR, SHR, SHRA, SHL, ROR, ROL, NEG, NOT,

    // Output
    output wire [31:0] BusMuxOut
);

    // Internal signals
    wire [31:0] bus_out, Yout, alu_result_low, alu_result_high;
    wire [31:0] Zlow_bus, Zhigh_bus;

    // Special purpose registers
    reg32 PC (.clk(clk), .reset(reset), .in(PCin), .out(PCout), .data_in(bus_out), .data_out(PC_out));
    reg32 IR (.clk(clk), .reset(reset), .in(IRin), .out(IRout), .data_in(bus_out), .data_out(IR_out));
    reg32 HI (.clk(clk), .reset(reset), .in(HIin), .out(HIout), .data_in(bus_out), .data_out(HI_out));
    reg32 LO (.clk(clk), .reset(reset), .in(LOin), .out(LOout), .data_in(bus_out), .data_out(LO_out));
    reg32 MAR (.clk(clk), .reset(reset), .in(MARin), .out(MARout), .data_in(bus_out), .data_out(MAR_out));
    reg32 MDR (.clk(clk), .reset(reset), .in(MDRin), .out(MDRout), .data_in(bus_out), .data_out(MDR_out));
    reg32 Y (.clk(clk), .reset(reset), .in(Yin), .out(), .data_in(bus_out), .data_out(Yout));

    // General purpose registers R0-R15 manually instantiated
    wire [31:0] R[15:0];
    reg32 R0 (.clk(clk), .reset(reset), .in(R0in), .out(R0out), .data_in(bus_out), .data_out(R[0]));
    reg32 R1 (.clk(clk), .reset(reset), .in(R1in), .out(R1out), .data_in(bus_out), .data_out(R[1]));
    reg32 R2 (.clk(clk), .reset(reset), .in(R2in), .out(R2out), .data_in(bus_out), .data_out(R[2]));
    reg32 R3 (.clk(clk), .reset(reset), .in(R3in), .out(R3out), .data_in(bus_out), .data_out(R[3]));
    reg32 R4 (.clk(clk), .reset(reset), .in(R4in), .out(R4out), .data_in(bus_out), .data_out(R[4]));
    reg32 R5 (.clk(clk), .reset(reset), .in(R5in), .out(R5out), .data_in(bus_out), .data_out(R[5]));
    reg32 R6 (.clk(clk), .reset(reset), .in(R6in), .out(R6out), .data_in(bus_out), .data_out(R[6]));
    reg32 R7 (.clk(clk), .reset(reset), .in(R7in), .out(R7out), .data_in(bus_out), .data_out(R[7]));
    reg32 R8 (.clk(clk), .reset(reset), .in(R8in), .out(R8out), .data_in(bus_out), .data_out(R[8]));
    reg32 R9 (.clk(clk), .reset(reset), .in(R9in), .out(R9out), .data_in(bus_out), .data_out(R[9]));
    reg32 R10 (.clk(clk), .reset(reset), .in(R10in), .out(R10out), .data_in(bus_out), .data_out(R[10]));
    reg32 R11 (.clk(clk), .reset(reset), .in(R11in), .out(R11out), .data_in(bus_out), .data_out(R[11]));
    reg32 R12 (.clk(clk), .reset(reset), .in(R12in), .out(R12out), .data_in(bus_out), .data_out(R[12]));
    reg32 R13 (.clk(clk), .reset(reset), .in(R13in), .out(R13out), .data_in(bus_out), .data_out(R[13]));
    reg32 R14 (.clk(clk), .reset(reset), .in(R14in), .out(R14out), .data_in(bus_out), .data_out(R[14]));
    reg32 R15 (.clk(clk), .reset(reset), .in(R15in), .out(R15out), .data_in(bus_out), .data_out(R[15]));

    // ALU for Arithmetic and Logic Operations
    alu ALU (
        .clk(clk),
        .A(Yout),
        .B(bus_out),
        .ALU_control({ADD, SUB, MUL, DIV, AND, OR, SHR, SHRA, SHL, ROR, ROL, NEG, NOT}),
        .result(alu_result_low),
        .Zlow(alu_result_low),
        .Zhigh(alu_result_high)
    );

    // Two separate Z registers (each 32 bits)
    reg32 Zlow_reg (
        .clk(clk),
        .reset(reset),
        .in(Zlowin),
        .out(Zlowout),
        .data_in(alu_result_low),
        .data_out(Zlow_bus)
    );

    reg32 Zhigh_reg (
        .clk(clk),
        .reset(reset),
        .in(Zhighin),
        .out(Zhighout),
        .data_in(alu_result_high),
        .data_out(Zhigh_bus)
    );

    // Bus logic (Tri-state buffer style implementation)
    bus Bus (
        .R0(R[0]), .R1(R[1]), .R2(R[2]), .R3(R[3]), .R4(R[4]), .R5(R[5]), .R6(R[6]), .R7(R[7]),
        .R8(R[8]), .R9(R[9]), .R10(R[10]), .R11(R[11]), .R12(R[12]), .R13(R[13]), .R14(R[14]), .R15(R[15]),
        .HI(HI_out), .LO(LO_out), .PC(PC_out), .IR(IR_out), .MDR(MDR_out),
        .Zhigh(Zhigh_bus), .Zlow(Zlow_bus),
        .R0out(R0out), .R1out(R1out), .R2out(R2out), .R3out(R3out), .R4out(R4out),
        .R5out(R5out), .R6out(R6out), .R7out(R7out), .R8out(R8out), .R9out(R9out),
        .R10out(R10out), .R11out(R11out), .R12out(R12out), .R13out(R13out), .R14out(R14out), .R15out(R15out),
        .HIout(HIout), .LOout(LOout), .PCout(PCout), .IRout(IRout), .MDRout(MDRout),
        .Zhighout(Zhighout), .Zlowout(Zlowout),
        .bus_out(bus_out)
    );

endmodule