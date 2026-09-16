`timescale 1ns/1ps
// Small deterministic RV32I-style demonstration core interface.
// This is intentionally not a complete commercial RISC-V implementation.
// It provides a synthesizable CPU-like workload endpoint for AMHRA integration.
module rv32i_demo_core (
    input  wire clk,
    input  wire reset_n,
    input  wire run_enable,
    output reg [31:0] pc,
    output reg [31:0] instruction_count,
    output reg        heartbeat
);
    always @(posedge clk) begin
        if (!reset_n) begin
            pc <= 32'h0000_0000;
            instruction_count <= 0;
            heartbeat <= 0;
        end else if (run_enable) begin
            pc <= pc + 32'd4;
            instruction_count <= instruction_count + 1'b1;
            heartbeat <= ~heartbeat;
        end
    end
endmodule
