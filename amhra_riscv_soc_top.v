`timescale 1ns/1ps
module amhra_riscv_soc_top #(
    parameter integer BASELINE_RELIABILITY = 95
)(
    input wire clk,
    input wire reset_n,
    input wire [1:0] temp_status,
    input wire [1:0] voltage_status,
    input wire [1:0] current_status,
    input wire [1:0] timing_status,
    input wire [1:0] ecc_status,
    input wire [1:0] watchdog_status,
    output wire [31:0] pc,
    output wire [31:0] instruction_count,
    output wire [2:0] selected_action,
    output wire [2:0] active_action,
    output wire fault_present,
    output wire [2:0] health_state,
    output wire recovery_active,
    output wire recovery_done,
    output wire escalate,
    output wire core_isolated,
    output wire core_reset_n,
    output wire soc_reset_n
);
    wire [5:0] fault_vector;
    wire [2:0] severity_level;
    wire [3:0] persistence_count;
    wire intermittent_fault, escalating_fault;
    wire [6:0] candidate_mask, eligible_mask;
    wire selection_valid;

    wire clock_throttle, dvfs_request, isolate_request;
    wire local_reset, core_reset_request, soc_reset_request;
    wire core_run_enable;
    wire verification_success, verification_failure;

    wire [7:0] cost0,cost1,cost2,cost3,cost4,cost5,cost6;

    global_sensor_fusion u_fusion (
        .clk(clk), .reset_n(reset_n),
        .temp_status(temp_status), .voltage_status(voltage_status),
        .current_status(current_status), .timing_status(timing_status),
        .ecc_status(ecc_status), .watchdog_status(watchdog_status),
        .fault_vector(fault_vector),
        .global_health_state(health_state),
        .fault_present(fault_present)
    );

    temporal_severity_analysis u_temporal (
        .clk(clk), .reset_n(reset_n),
        .fault_present(fault_present),
        .global_health_state(health_state),
        .persistence_count(persistence_count),
        .severity_level(severity_level),
        .intermittent_fault(intermittent_fault),
        .escalating_fault(escalating_fault)
    );

    wire fast_valid;
    wire [2:0] fast_action;
    fast_path_decision u_fast (
        .severity_level(severity_level),
        .persistence_count(persistence_count),
        .intermittent_fault(intermittent_fault),
        .escalating_fault(escalating_fault),
        .fast_valid(fast_valid),
        .fast_action(fast_action)
    );

    recovery_candidate_generator u_candidates (
        .severity_level(severity_level),
        .persistence_count(persistence_count),
        .fast_valid(fast_valid),
        .fast_action(fast_action),
        .candidate_mask(candidate_mask)
    );

    reliability_improvement_filter #(
        .BASELINE_RELIABILITY(BASELINE_RELIABILITY)
    ) u_rel_filter (
        .candidate_mask(candidate_mask),
        .eligible_mask(eligible_mask)
    );

    recovery_cost_evaluator u_cost (
        .eligible_mask(eligible_mask),
        .cost0(cost0), .cost1(cost1), .cost2(cost2),
        .cost3(cost3), .cost4(cost4), .cost5(cost5), .cost6(cost6)
    );

    minimum_impact_recovery_selector u_selector (
        .eligible_mask(eligible_mask),
        .cost0(cost0), .cost1(cost1), .cost2(cost2),
        .cost3(cost3), .cost4(cost4), .cost5(cost5), .cost6(cost6),
        .selected_action(selected_action),
        .selection_valid(selection_valid)
    );

    wire start_recovery = selection_valid && fault_present;

    recovery_execution_controller u_exec (
        .clk(clk), .reset_n(reset_n),
        .start_recovery(start_recovery),
        .selected_action(selected_action),
        .verification_success(verification_success),
        .active_action(active_action),
        .recovery_active(recovery_active),
        .recovery_done(recovery_done),
        .escalate(escalate),
        .clock_throttle(clock_throttle),
        .dvfs_request(dvfs_request),
        .isolate_request(isolate_request),
        .local_reset(local_reset),
        .core_reset_request(core_reset_request),
        .soc_reset_request(soc_reset_request)
    );

    recovery_verification u_verify (
        .clk(clk), .reset_n(reset_n),
        .recovery_active(recovery_active),
        .fault_present(fault_present),
        .global_health_state(health_state),
        .verification_success(verification_success),
        .verification_failure(verification_failure)
    );

    riscv_recovery_interface u_if (
        .clk(clk), .reset_n(reset_n),
        .clock_throttle(clock_throttle),
        .dvfs_request(dvfs_request),
        .isolate_request(isolate_request),
        .local_reset(local_reset),
        .core_reset_request(core_reset_request),
        .soc_reset_request(soc_reset_request),
        .core_run_enable(core_run_enable),
        .core_isolated(core_isolated),
        .core_reset_n(core_reset_n),
        .soc_reset_n(soc_reset_n)
    );

    rv32i_demo_core u_cpu (
        .clk(clk),
        .reset_n(core_reset_n && soc_reset_n),
        .run_enable(core_run_enable),
        .pc(pc),
        .instruction_count(instruction_count),
        .heartbeat()
    );
endmodule
