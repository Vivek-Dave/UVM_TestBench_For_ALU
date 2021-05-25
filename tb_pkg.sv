
`ifndef TB_PKG
`define TB_PKG
`include "uvm_macros.svh"
package tb_pkg;
 import uvm_pkg::*;
 `include "alu_sequence_item.sv"        // transaction class
 `include "alu_sequence.sv"             // sequence class
 `include "alu_sequencer.sv"            // sequencer class
 `include "alu_driver.sv"               // driver class
 `include "alu_monitor.sv"
 `include "alu_agent.sv"                // agent class  
 `include "alu_coverage.sv"             // coverage class
 `include "alu_scoreboard.sv"           // scoreboard class
 `include "alu_env.sv"                  // environment class

 `include "alu_test.sv"                 // test

endpackage
`endif 


