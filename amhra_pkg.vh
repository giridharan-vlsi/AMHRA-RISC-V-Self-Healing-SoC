`ifndef AMHRA_PKG_VH
`define AMHRA_PKG_VH

`define HEALTHY  3'd0
`define WARNING  3'd1
`define MODERATE 3'd2
`define SEVERE   3'd3
`define CRITICAL 3'd4

`define ACT_CONTINUE 3'd0
`define ACT_CLOCK    3'd1
`define ACT_DVFS     3'd2
`define ACT_ISOLATE  3'd3
`define ACT_LOCALRST 3'd4
`define ACT_CORERST  3'd5
`define ACT_SOCRST   3'd6

`endif
