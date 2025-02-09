module z32 (
    input wire clock, 
    input wire reset,
    input wire Zin, Zlowout, Zhighout,
    input wire [31:0] ALU,
    output wire [31:0] busout
);
    reg [31:0] Zlow;
    reg [31:0] Zhigh;
    
     always @(posedge clock or posedge reset) begin
        if (reset) begin
            Zlow <= 32'b0;
            Zhigh <= 32'b0;
        end else if (Zin)
            {Zhigh, Zlow} <= ALU;
    end

    assign busout = (Zlowout) ? Zlow : (Zhighout ? Zhigh : 32'b0);
endmodule