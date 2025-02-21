module ir (
    input wire clock, 
    input wire reset,
    input wire IRin,           // Enable signal for loading data
    input wire [31:0] busdata, // Data from the bus
    output reg [31:0] IRvalue, // Internal storage for instruction register
    output wire [31:0] Zlow    // Output passed to the bus
);
    // Load instruction value on rising clock edge or reset
    always @(posedge clock or posedge reset) begin
        if (reset)
            IRvalue <= 32'b0;  // Reset the IRvalue to zero
        else if (IRin)
            IRvalue <= busdata;  // Load data from the bus
    end

    // Pass IRvalue to Zlow for bus connection
    assign Zlow = IRvalue;  // Connect IRvalue directly to Zlow output

endmodule