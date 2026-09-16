`timescale 1ns/1ps
module temporal_severity_analysis (
    input  wire       clk,
    input  wire       reset_n,
    input  wire       fault_present,
    input  wire [2:0] global_health_state,
    output reg  [3:0] persistence_count,
    output reg  [2:0] severity_level,
    output reg        intermittent_fault,
    output reg        escalating_fault
);
    reg [2:0] previous_health;
    reg       previous_fault;

    always @(posedge clk) begin
        if (!reset_n) begin
            persistence_count  <= 4'd0;
            severity_level     <= `HEALTHY;
            intermittent_fault <= 1'b0;
            escalating_fault   <= 1'b0;
            previous_health    <= `HEALTHY;
            previous_fault     <= 1'b0;
        end else begin
            severity_level   <= global_health_state;
            escalating_fault <= (global_health_state > previous_health);

            if (fault_present)
                persistence_count <= (persistence_count == 4'hF) ?
                                      4'hF : persistence_count + 1'b1;
            else
                persistence_count <= 4'd0;

            intermittent_fault <= fault_present &&
                                  previous_fault &&
                                  (global_health_state <= previous_health);

            previous_health <= global_health_state;
            previous_fault  <= fault_present;
        end
    end
endmodule
