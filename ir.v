module ir (
    input wire clock, 
    input wire reset,
    input wire IRin,
    input wire [31:0] busdata,
    output reg [31:0] IRvalue
);
    always @(posedge clock or posedge reset) begin
        if (reset)
            IRvalue <= 32'b0
        else if (IRin)
            IRvalue <= bus_data;
    end
    
endmodule