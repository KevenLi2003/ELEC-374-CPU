module z32 (
    input wire clock,             // Clock signal
    input wire reset,             // Reset signal
    input wire Zin,               // Enable signal for storing data
    input wire Zout,              // Enable signal for outputting data
    input wire [31:0] data_in,    // 32-bit input from ALU (or MUX)
    output wire [31:0] busout     // 32-bit output to the bus
);
    reg [31:0] Zvalue;  // Internal 32-bit register

    // Store data on positive edge of the clock or reset
    always @(posedge clock or posedge reset) begin
        if (reset)
            Zvalue <= 32'b0;       // Reset the register
        else if (Zin)
            Zvalue <= data_in;     // Store incoming data when enabled
    end

    // Push data to the bus when enabled
    assign busout = Zout ? Zvalue : 32'b0;

endmodule