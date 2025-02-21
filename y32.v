module y32 (
    input wire clock, 
    input wire reset,
    input wire Yin,
    input wire [31:0] busdata,
    output reg [31:0] Yvalue
);
    always @(posedge clock or posedge reset) begin
        if (reset)
            Yvalue <= 32'b0;
        else if (Yin)
            Yvalue <= busdata;
    end

endmodule