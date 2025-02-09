module hilo32 (
    input wire clock, 
    input wire reset,
    input wire HIin, LOin,
    input wire [31:0] HIdata, LOdata, // data from ALU
    output reg [31:0] HIvalue, LOvalue // values in registers
);
    always @(posedge clock or posedge reset) begin
        if (reset) begin
            HIvalue <= 32'b0
            LOvalue <= 32'b0
        end else begin
            if (HIin) HIvalue <= HIdata;
            if (LOin) LOvalue <= LOdata;
        end
    end
endmodule