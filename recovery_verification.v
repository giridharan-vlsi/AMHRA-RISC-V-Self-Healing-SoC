`timescale 1ns/1ps
module recovery_verification (
    input wire clk,
    input wire reset_n,
    input wire recovery_active,
    input wire fault_present,
    input wire [2:0] global_health_state,
    output reg verification_success,
    output reg verification_failure
);
    reg [1:0] healthy_samples;

    always @(posedge clk) begin
        if (!reset_n) begin
            healthy_samples <= 0;
            verification_success <= 0;
            verification_failure <= 0;
        end else begin
            verification_success <= 0;
            verification_failure <= 0;

            if (!recovery_active && !fault_present &&
                global_health_state == `HEALTHY) begin
                if (healthy_samples < 3)
                    healthy_samples <= healthy_samples + 1'b1;
                if (healthy_samples >= 2) begin
                    verification_success <= 1;
                    healthy_samples <= 0;
                end
            end else begin
                healthy_samples <= 0;
            end

            if (!recovery_active && fault_present)
                verification_failure <= 1;
        end
    end
endmodule
