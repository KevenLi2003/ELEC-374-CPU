module reg32 #(
    parameter DATA_WIDTH = 32, 
    parameter INIT = 32'b0
) (
    input wire clk,           // Clock signal
    input wire reset,         // Synchronous reset signal
    input wire in,            // Enable to load data
    input wire out,           // Enable to output data to bus
    input wire [DATA_WIDTH-1:0] data_in,  // Data input
    output wire [DATA_WIDTH-1:0] data_out // Data output
);

    reg [DATA_WIDTH-1:0] q;

    // Initialize the register value
    initial q = INIT;

    // Synchronous loading and clearing
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= {DATA_WIDTH{1'b0}}; // Reset register
        end
        else if (in) begin
            q <= data_in; // Load new value when 'in' is active
        end
    end

    // Output control to bus
    assign data_out = (out) ? q : {DATA_WIDTH{1'bz}}; // High impedance if not outputting

endmodule