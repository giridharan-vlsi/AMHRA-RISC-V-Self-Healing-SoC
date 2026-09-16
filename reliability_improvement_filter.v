`timescale 1ns/1ps
module reliability_improvement_filter #(
    parameter integer BASELINE_RELIABILITY = 95
)(
    input  wire [6:0] candidate_mask,
    output reg  [6:0] eligible_mask
);
    reg [7:0] estimated_reliability [0:6];
    integer i;

    always @(*) begin
        // Initial architecture model only. Replace by measured fault-injection
        // results for quantitative research conclusions.
        estimated_reliability[0] = 8'd90;
        estimated_reliability[1] = 8'd96;
        estimated_reliability[2] = 8'd97;
        estimated_reliability[3] = 8'd98;
        estimated_reliability[4] = 8'd99;
        estimated_reliability[5] = 8'd100;
        estimated_reliability[6] = 8'd100;

        eligible_mask = 7'b0;
        for (i=0; i<7; i=i+1)
            if (candidate_mask[i] &&
                estimated_reliability[i] > BASELINE_RELIABILITY)
                eligible_mask[i] = 1'b1;
    end
endmodule
