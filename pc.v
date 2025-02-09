module pc (
    input wire clock, // clock signal
    input wire reset, // reset signal
    input wire PCin, // load new value from bus signal
    input wire PCout, // output the current value of pc to bus signal
    input wire increment, // increment pc value by 1
    input wire [31:0] bus_data, // data from the bus
    output reg [31:0] PC, // current pc value
    output wire [31:0] bus // output value to bus
);
    always @(posedge clock or posedge reset) begin
        if (reset) 
            PC <= 32'b0;
        else if (PC_in) 
            PC <= bus_data;
        else if (increment) 
            PC <= PC + 1;
    end

    assign bus = (PC_out) ? PC : 32'bz;
    
endmodule