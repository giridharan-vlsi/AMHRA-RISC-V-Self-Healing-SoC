`timescale 1ns/1ps
module recovery_cost_evaluator (
    input  wire [6:0] eligible_mask,
    output reg [7:0] cost0, cost1, cost2, cost3, cost4, cost5, cost6
);
    always @(*) begin
        cost0 = eligible_mask[0] ? 8'd0  : 8'hff;
        cost1 = eligible_mask[1] ? 8'd4  : 8'hff;
        cost2 = eligible_mask[2] ? 8'd6  : 8'hff;
        cost3 = eligible_mask[3] ? 8'd10 : 8'hff;
        cost4 = eligible_mask[4] ? 8'd20 : 8'hff;
        cost5 = eligible_mask[5] ? 8'd40 : 8'hff;
        cost6 = eligible_mask[6] ? 8'd80 : 8'hff;
    end
endmodule
