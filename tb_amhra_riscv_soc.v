`timescale 1ns/1ps
module tb_amhra_riscv_soc;
    reg clk, reset_n;
    reg [1:0] temp_status, voltage_status, current_status;
    reg [1:0] timing_status, ecc_status, watchdog_status;

    wire [31:0] pc, instruction_count;
    wire [2:0] selected_action, active_action, health_state;
    wire fault_present, recovery_active, recovery_done, escalate;
    wire core_isolated, core_reset_n, soc_reset_n;

    amhra_riscv_soc_top #(.BASELINE_RELIABILITY(95)) dut (
        .clk(clk), .reset_n(reset_n),
        .temp_status(temp_status), .voltage_status(voltage_status),
        .current_status(current_status), .timing_status(timing_status),
        .ecc_status(ecc_status), .watchdog_status(watchdog_status),
        .pc(pc), .instruction_count(instruction_count),
        .selected_action(selected_action), .active_action(active_action),
        .fault_present(fault_present), .health_state(health_state),
        .recovery_active(recovery_active), .recovery_done(recovery_done),
        .escalate(escalate), .core_isolated(core_isolated),
        .core_reset_n(core_reset_n), .soc_reset_n(soc_reset_n)
    );

    always #5 clk = ~clk;

    task normal;
        begin
            temp_status=0; voltage_status=0; current_status=0;
            timing_status=0; ecc_status=0; watchdog_status=0;
        end
    endtask

    task warning_fault;
        begin normal; temp_status=2'b01; end
    endtask

    task timing_fault;
        begin normal; timing_status=2'b10; end
    endtask

    task severe_fault;
        begin
            normal;
            temp_status=2'b10;
            voltage_status=2'b10;
            timing_status=2'b10;
        end
    endtask

    task critical_fault;
        begin normal; watchdog_status=2'b11; end
    endtask

    initial begin
        $dumpfile("amhra_soc.vcd");
        $dumpvars(0, tb_amhra_riscv_soc);

        clk=0; reset_n=0; normal;
        #20 reset_n=1;

        $display("\n--- NORMAL ---");
        normal; #60;

        $display("\n--- WARNING ---");
        warning_fault; #70;

        $display("\n--- SINGLE TIMING FAULT ---");
        timing_fault; #100;

        $display("\n--- SEVERE MULTI-SENSOR FAULT ---");
        severe_fault; #140;

        $display("\n--- CRITICAL WATCHDOG FAULT ---");
        critical_fault; #160;

        $display("\n--- FAULT CLEARED ---");
        normal; #160;

        $display("\n--- RESET ---");
        reset_n=0; #30; reset_n=1; normal; #50;

        $display("\nFINAL PC=%h INSTR_COUNT=%0d", pc, instruction_count);
        $display("SIMULATION COMPLETE");
        $finish;
    end

    always @(posedge clk) begin
        $display("t=%0t health=%0d fault=%b severity=%0d persist=%0d cand=%b eligible=%b sel=%0d active=%0d rec=%b done=%b esc=%b pc=%h",
                 $time, health_state, fault_present, dut.severity_level,
                 dut.persistence_count, dut.candidate_mask, dut.eligible_mask,
                 selected_action, active_action, recovery_active,
                 recovery_done, escalate, pc);
    end
endmodule
