`timescale 1ns/1ps
module fast_path_decision (
    input  wire [2:0] severity_level,
    input  wire [3:0] persistence_count,
    input  wire       intermittent_fault,
    input  wire       escalating_fault,
    output reg        fast_valid,
    output reg [2:0]  fast_action
);
    always @(*) begin
        fast_valid  = 1'b0;
        fast_action = `ACT_CONTINUE;

        if (!escalating_fault && intermittent_fault &&
            severity_level <= `MODERATE &&
            persistence_count <= 4'd2) begin
            fast_valid  = 1'b1;
            fast_action = `ACT_CLOCK;
        end
        else if (!escalating_fault &&
                 severity_level == `WARNING &&
                 persistence_count <= 4'd1) begin
            fast_valid  = 1'b1;
            fast_action = `ACT_CLOCK;
        end
    end
endmodule
