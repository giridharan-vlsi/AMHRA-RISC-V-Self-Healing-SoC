`timescale 1ns/1ps
module minimum_impact_recovery_selector (
    input wire [6:0] eligible_mask,
    input wire [7:0] cost0, cost1, cost2, cost3, cost4, cost5, cost6,
    output reg [2:0] selected_action,
    output reg       selection_valid
);
    reg [7:0] min_cost;

    always @(*) begin
        selected_action = `ACT_SOCRST;
        selection_valid = 1'b0;
        min_cost = 8'hff;

        if (eligible_mask[0] && cost0 < min_cost) begin min_cost=cost0; selected_action=0; selection_valid=1; end
        if (eligible_mask[1] && cost1 < min_cost) begin min_cost=cost1; selected_action=1; selection_valid=1; end
        if (eligible_mask[2] && cost2 < min_cost) begin min_cost=cost2; selected_action=2; selection_valid=1; end
        if (eligible_mask[3] && cost3 < min_cost) begin min_cost=cost3; selected_action=3; selection_valid=1; end
        if (eligible_mask[4] && cost4 < min_cost) begin min_cost=cost4; selected_action=4; selection_valid=1; end
        if (eligible_mask[5] && cost5 < min_cost) begin min_cost=cost5; selected_action=5; selection_valid=1; end
        if (eligible_mask[6] && cost6 < min_cost) begin min_cost=cost6; selected_action=6; selection_valid=1; end
    end
endmodule
