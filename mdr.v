module mdr (
    input wire clock, 
    input wire reset,
    input wire MDRin,
    input wire MDRout, 
    input wire memory_read,
    input wire [31:0] busdata,
    input wire [31:0] memdata,
    output reg [31:0] MDRvalue,
    output wire [31:0] busout
);
    always @(posedge clock or posedge reset) begin
        if (reset)
            MDRvalue <= 32'b0;
        else if (memory_read)
            MDRvalue <= memdata;
        else if (MDRin)
            MDRvalue <= busdata;
    end

    assign busout = (MDRout) ? MDRvalue : 32'bz;
    
endmodule