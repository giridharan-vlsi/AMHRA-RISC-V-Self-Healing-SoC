`timescale 1ns/1ps
module recovery_candidate_generator (
    input  wire [2:0] severity_level,
    input  wire [3:0] persistence_count,
    input  wire       fast_valid,
    input  wire [2:0] fast_action,
    output reg  [6:0] candidate_mask
);
    always @(*) begin
        candidate_mask = 7'b0000000;

        candidate_mask[`ACT_CONTINUE] = 1'b1;

        if (severity_level >= `WARNING)
            candidate_mask[`ACT_CLOCK] = 1'b1;

        if (severity_level >= `MODERATE)
            candidate_mask[`ACT_DVFS] = 1'b1;

        if (severity_level >= `MODERATE)
            candidate_mask[`ACT_ISOLATE] = 1'b1;

        if ((severity_level >= `SEVERE) || (persistence_count >= 4'd3))
            candidate_mask[`ACT_LOCALRST] = 1'b1;

        if ((severity_level >= `CRITICAL) || (persistence_count >= 4'd8))
            candidate_mask[`ACT_CORERST] = 1'b1;

        if ((severity_level == `CRITICAL) && (persistence_count >= 4'd8))
            candidate_mask[`ACT_SOCRST] = 1'b1;

        if (fast_valid)
            candidate_mask[fast_action] = 1'b1;
    end
endmodule
