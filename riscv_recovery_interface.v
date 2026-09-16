`timescale 1ns/1ps
module riscv_recovery_interface (
    input wire clk,
    input wire reset_n,
    input wire clock_throttle,
    input wire dvfs_request,
    input wire isolate_request,
    input wire local_reset,
    input wire core_reset_request,
    input wire soc_reset_request,
    output reg core_run_enable,
    output reg core_isolated,
    output reg core_reset_n,
    output reg soc_reset_n
);
    always @(posedge clk) begin
        if (!reset_n) begin
            core_run_enable <= 1'b0;
            core_isolated   <= 1'b0;
            core_reset_n    <= 1'b0;
            soc_reset_n     <= 1'b0;
        end else begin
            soc_reset_n <= !soc_reset_request;

            if (core_reset_request || local_reset)
                core_reset_n <= 1'b0;
            else
                core_reset_n <= 1'b1;

            core_isolated <= isolate_request;

            // In this RTL prototype, clock_throttle/DVFS are control requests.
            // A real SoC connects them to clock/power-management hardware.
            core_run_enable <= !isolate_request && !core_reset_request &&
                               !local_reset && !soc_reset_request;
        end
    end
endmodule
