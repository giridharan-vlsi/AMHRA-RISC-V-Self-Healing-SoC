`timescale 1ns/1ps
module global_sensor_fusion (
    input  wire       clk,
    input  wire       reset_n,
    input  wire [1:0] temp_status,
    input  wire [1:0] voltage_status,
    input  wire [1:0] current_status,
    input  wire [1:0] timing_status,
    input  wire [1:0] ecc_status,
    input  wire [1:0] watchdog_status,
    output reg  [5:0] fault_vector,
    output reg  [2:0] global_health_state,
    output reg        fault_present
);
    integer serious_count;
    reg [1:0] max_status;

    always @(*) begin
        max_status = temp_status;
        if (voltage_status  > max_status) max_status = voltage_status;
        if (current_status  > max_status) max_status = current_status;
        if (timing_status   > max_status) max_status = timing_status;
        if (ecc_status      > max_status) max_status = ecc_status;
        if (watchdog_status > max_status) max_status = watchdog_status;

        serious_count = 0;
        if (temp_status     >= 2'b10) serious_count = serious_count + 1;
        if (voltage_status  >= 2'b10) serious_count = serious_count + 1;
        if (current_status  >= 2'b10) serious_count = serious_count + 1;
        if (timing_status   >= 2'b10) serious_count = serious_count + 1;
        if (ecc_status      >= 2'b10) serious_count = serious_count + 1;
        if (watchdog_status >= 2'b10) serious_count = serious_count + 1;
    end

    always @(posedge clk) begin
        if (!reset_n) begin
            fault_vector        <= 6'b0;
            global_health_state <= `HEALTHY;
            fault_present       <= 1'b0;
        end else begin
            fault_vector <= {
                watchdog_status != 2'b00,
                ecc_status      != 2'b00,
                timing_status   != 2'b00,
                current_status  != 2'b00,
                voltage_status  != 2'b00,
                temp_status     != 2'b00
            };

            fault_present <= (max_status != 2'b00);

            if (max_status == 2'b11)
                global_health_state <= `CRITICAL;
            else if (serious_count >= 3)
                global_health_state <= `SEVERE;
            else if (max_status == 2'b10)
                global_health_state <= `MODERATE;
            else if (max_status == 2'b01)
                global_health_state <= `WARNING;
            else
                global_health_state <= `HEALTHY;
        end
    end
endmodule
