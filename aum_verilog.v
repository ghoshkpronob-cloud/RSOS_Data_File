// AUM Verilog behavioral models
// Encoding (2-bit):
// 2'b00 -> M (-1)
// 2'b01 -> U (0)
// 2'b10 -> A (+1)
// Note: 2'b11 is unused/reserved.
//
// Each module is purely combinational and maps inputs to outputs
// according to the AUM truth tables described in the manuscript.

module aum_not(
    input [1:0] in,
    output reg [1:0] out
);
    always @(*) begin
        case (in)
            2'b10: out = 2'b00; // A -> M
            2'b00: out = 2'b10; // M -> A
            2'b01: out = 2'b01; // U -> U
            default: out = 2'b01; // default to U
        endcase
    end
endmodule

// Helper: compare numeric mapping: M=0, U=1, A=2 (for ordering in case)
function [1:0] min_trit;
    input [1:0] a,b;
    begin
        // map to order value
        int va, vb;
        case (a)
            2'b00: va = 0; // M
            2'b01: va = 1; // U
            2'b10: va = 2; // A
            default: va = 1;
        endcase
        case (b)
            2'b00: vb = 0;
            2'b01: vb = 1;
            2'b10: vb = 2;
            default: vb = 1;
        endcase
        if (va <= vb) begin
            min_trit = a;
        end else begin
            min_trit = b;
        end
    end
endfunction

function [1:0] max_trit;
    input [1:0] a,b;
    begin
        int va, vb;
        case (a)
            2'b00: va = 0; // M
            2'b01: va = 1; // U
            2'b10: va = 2; // A
            default: va = 1;
        endcase
        case (b)
            2'b00: vb = 0;
            2'b01: vb = 1;
            2'b10: vb = 2;
            default: vb = 1;
        endcase
        if (va >= vb) begin
            max_trit = a;
        end else begin
            max_trit = b;
        end
    end
endfunction

module aum_and(input [1:0] a, input [1:0] b, output [1:0] y);
    assign y = min_trit(a,b);
endmodule

module aum_or(input [1:0] a, input [1:0] b, output [1:0] y);
    assign y = max_trit(a,b);
endmodule

module aum_nand(input [1:0] a, input [1:0] b, output [1:0] y);
    wire [1:0] t;
    assign t = min_trit(a,b);
    aum_not not1(.in(t), .out(y));
endmodule

module aum_nor(input [1:0] a, input [1:0] b, output [1:0] y);
    wire [1:0] t;
    assign t = max_trit(a,b);
    aum_not not2(.in(t), .out(y));
endmodule

module aum_xnor(input [1:0] a, input [1:0] b, output reg [1:0] y);
    always @(*) begin
        if (a == b) y = 2'b10; // equal -> A
        else if ((a==2'b10 && b==2'b00) || (a==2'b00 && b==2'b10)) y = 2'b00; // opposites -> M
        else y = 2'b01; // mixed -> U
    end
endmodule

module aum_xor(input [1:0] a, input [1:0] b, output [1:0] y);
    wire [1:0] t;
    aum_xnor xnor1(.a(a), .b(b), .y(t));
    aum_not not3(.in(t), .out(y));
endmodule