module mar (
    input wire clock, 
    input wire reset,
    input wire MARin,
    input wire [31:0] busdata,
    output reg [31:0] MARvalue
);
    always @(posedge clock or posedge reset) begin
        if (reset)
            MARvalue <= 32'b0
        else if (MARin)
            MARvalue <= bus_data;
    end
    
endmodule