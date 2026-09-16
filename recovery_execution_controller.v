`timescale 1ns/1ps
module recovery_execution_controller (
    input  wire       clk,
    input  wire       reset_n,
    input  wire       start_recovery,
    input  wire [2:0] selected_action,
    input  wire       verification_success,
    output reg [2:0]  active_action,
    output reg        recovery_active,
    output reg        recovery_done,
    output reg        escalate,
    output reg        clock_throttle,
    output reg        dvfs_request,
    output reg        isolate_request,
    output reg        local_reset,
    output reg        core_reset_request,
    output reg        soc_reset_request
);
    localparam IDLE=2'd0, EXEC=2'd1, VERIFY=2'd2;
    reg [1:0] state;
    reg [1:0] exec_count;

    always @(posedge clk) begin
        if (!reset_n) begin
            state <= IDLE;
            exec_count <= 0;
            active_action <= `ACT_CONTINUE;
            recovery_active <= 0;
            recovery_done <= 0;
            escalate <= 0;
            clock_throttle <= 0;
            dvfs_request <= 0;
            isolate_request <= 0;
            local_reset <= 0;
            core_reset_request <= 0;
            soc_reset_request <= 0;
        end else begin
            recovery_done <= 0;
            escalate <= 0;

            if (state == IDLE) begin
                recovery_active <= 0;
                clock_throttle <= 0;
                dvfs_request <= 0;
                isolate_request <= 0;
                local_reset <= 0;
                core_reset_request <= 0;
                soc_reset_request <= 0;

                if (start_recovery) begin
                    active_action <= selected_action;
                    if (selected_action == `ACT_CONTINUE) begin
                        recovery_done <= 1;
                    end else begin
                        recovery_active <= 1;
                        exec_count <= 0;
                        case (selected_action)
                            `ACT_CLOCK:    clock_throttle <= 1;
                            `ACT_DVFS:     dvfs_request <= 1;
                            `ACT_ISOLATE:  isolate_request <= 1;
                            `ACT_LOCALRST: local_reset <= 1;
                            `ACT_CORERST:  core_reset_request <= 1;
                            `ACT_SOCRST:   soc_reset_request <= 1;
                        endcase
                        state <= EXEC;
                    end
                end
            end else if (state == EXEC) begin
                if (exec_count == 2) begin
                    state <= VERIFY;
                    recovery_active <= 0;
                end else begin
                    exec_count <= exec_count + 1'b1;
                end
            end else begin
                if (verification_success) begin
                    recovery_done <= 1;
                    state <= IDLE;
                end else begin
                    escalate <= 1;
                    state <= IDLE;
                end
            end
        end
    end
endmodule
