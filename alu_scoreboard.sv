
/***************************************************
  analysis_port from driver
  analysis_port from monitor
***************************************************/

`uvm_analysis_imp_decl( _drv )
`uvm_analysis_imp_decl( _mon )

class alu_scoreboard extends uvm_scoreboard;
  
  `uvm_component_utils(alu_scoreboard)
  
  uvm_analysis_imp_drv #(alu_sequence_item, alu_scoreboard) aport_drv;
  uvm_analysis_imp_mon #(alu_sequence_item, alu_scoreboard) aport_mon;
  
  uvm_tlm_fifo #(alu_sequence_item) expfifo;
  uvm_tlm_fifo #(alu_sequence_item) outfifo;
  
  int VECT_CNT, PASS_CNT, ERROR_CNT;
  logic [7:0] t_in1;
  logic [7:0] t_in2;
  logic [3:0] t_s;
  logic t_m;
  logic t_cin;

  logic [7:0] t_out,temp;
  logic t_cout;
  logic t_aeb,temp_aeb;

  function new(string name="alu_scoreboard",uvm_component parent);
    super.new(name,parent);
  endfunction
    
  function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	aport_drv = new("aport_drv", this);
	aport_mon = new("aport_mon", this);
	expfifo= new("expfifo",this);
	outfifo= new("outfifo",this);
  endfunction


  function void write_drv(alu_sequence_item tr);
    `uvm_info("write_drv STIM", tr.input2string(), UVM_MEDIUM)
    t_in1 = tr.in1;
    t_in2 = tr.in2;
    t_s   = tr.s;
    t_m   = tr.m;
    t_cin = tr.cin;
    
    temp= t_out;

    t_out = check_out(t_in1,t_in2,t_s,t_m,t_cin);
    t_aeb = check_aeb(t_in1,t_in2);
    t_cout= (t_in1[7]==1'b1 && t_in2[7]==1'b1)?1:0;
  
    tr.out  = temp;
    tr.aeb  = t_aeb;
    tr.cout = t_cout;
  
    void'(expfifo.try_put(tr));
  endfunction

  function bit check_aeb(logic [7:0]t_in1,t_in2);
    return (t_in1==t_in2);
  endfunction

  function [7:0] check_out(logic [7:0]t_in1,t_in2,logic [3:0]t_s,logic t_m,t_cin);
    //$display("inside check out function ");
      if(t_m==1) begin  // perform logical operation
        case(t_s)
            4'b0000: begin check_out=~t_in1;          end
            4'b0001: begin check_out=~(t_in1|t_in2);  end
            4'b0010: begin check_out=(~t_in1)&t_in2;  end
            4'b0011: begin check_out=0;               end

            4'b0100: begin check_out=~(t_in1&t_in2);  end
            4'b0101: begin check_out=~(t_in2);        end
            4'b0110: begin check_out=(t_in1^t_in2);   end
            4'b0111: begin check_out=t_in1&(~t_in2);  end

            4'b1000: begin check_out=(~t_in1)|t_in2;  end
            4'b1001: begin check_out=~(t_in1^t_in2);  end
            4'b1010: begin check_out=t_in2;           end
            4'b1011: begin check_out=(t_in1&t_in2);   end

            4'b1100: begin check_out=1;               end
            4'b1101: begin check_out=t_in1|(~t_in2);  end
            4'b1110: begin check_out=(t_in1|t_in2);   end
            4'b1111: begin check_out=t_in1;           end
        endcase
    end
    else begin  // perform arithmetic operation 
        if(t_cin==1) begin  // with carry 
            case(t_s)
                4'b0000: begin check_out= t_in1;          end
                4'b0001: begin check_out= t_in1|t_in2;    end
                4'b0010: begin check_out= (~t_in1)|t_in2; end
                4'b0011: begin check_out= 8'b1111_1111;   end

                4'b0100: begin check_out= t_in1+(t_in1&(~t_in2));         end
                4'b0101: begin check_out= (t_in1|t_in2)+(t_in1&(~t_in2)); end
                4'b0110: begin check_out= t_in1-t_in2-1;                  end
                4'b0111: begin check_out= (t_in1&(~t_in2))-1;             end

                4'b1000: begin check_out=t_in1+(t_in1&t_in2);            end
                4'b1001: begin check_out=t_in1+t_in2;                    end
                4'b1010: begin check_out=(t_in1|(~t_in2))+(t_in1&t_in2); end
                4'b1011: begin check_out=(t_in1&t_in2)-1;                end

                4'b1100: begin check_out=t_in1+(~t_in1);          end
                4'b1101: begin check_out=(t_in1|t_in2)+t_in1;     end
                4'b1110: begin check_out=(t_in1|(~t_in2))+t_in1;  end
                4'b1111: begin check_out=t_in1-1;                 end
            endcase
        end
        else begin        // without carry
            case(t_s)
                4'b0000: begin check_out= t_in1+1;            end
                4'b0001: begin check_out= (t_in1|t_in2)+1;    end
                4'b0010: begin check_out= ((~t_in1)|t_in2)+1; end
                4'b0011: begin check_out= 0;                  end

                4'b0100: begin check_out= (t_in1+(t_in1&(~t_in2)))+1;         end
                4'b0101: begin check_out= ((t_in1|t_in2)+(t_in1&(~t_in2)))+1; end
                4'b0110: begin check_out= t_in1-t_in2;                        end
                4'b0111: begin check_out= (t_in1&(~t_in2));                   end

                4'b1000: begin check_out=(t_in1+(t_in1&t_in2))+1;         end
                4'b1001: begin check_out=t_in1+t_in2+1;                   end
                4'b1010: begin check_out=(t_in1|(~t_in2))+(t_in1&t_in2)+1;end
                4'b1011: begin check_out=(t_in1&t_in2);                   end

                4'b1100: begin check_out=t_in1+(~t_in1)+1;           end
                4'b1101: begin check_out=(t_in1|t_in2)+t_in1+1;      end
                4'b1110: begin check_out=(t_in1|(~t_in2))+t_in1+1;   end
                4'b1111: begin check_out=t_in1;                      end
            endcase
        end
    end
  endfunction

  function void write_mon(alu_sequence_item tr);
    `uvm_info("write_mon OUT ", tr.convert2string(), UVM_MEDIUM)
    void'(outfifo.try_put(tr));
  endfunction
  
  task run_phase(uvm_phase phase);
	alu_sequence_item exp_tr, out_tr;
    static int unsigned count=0;
	forever begin
	    `uvm_info("scoreboard run task","WAITING for expected output", UVM_DEBUG)
	    expfifo.get(exp_tr);
	    `uvm_info("scoreboard run task","WAITING for actual output", UVM_DEBUG)
	    outfifo.get(out_tr);
      //$display("comparision ");
      if (out_tr.out===exp_tr.out && out_tr.aeb===exp_tr.aeb && out_tr.cout===exp_tr.cout && count>1) begin
            PASS();
        	`uvm_info ("\n PASS ",out_tr.convert2string() , UVM_LOW)
	      end
      
      else if(out_tr.out!==exp_tr.out && out_tr.aeb!==exp_tr.aeb && out_tr.aeb!==exp_tr.aeb && count>1) begin
      		ERROR();
          `uvm_info ("ERROR [ACTUAL_OP]",out_tr.convert2string() , UVM_LOW)
          `uvm_info ("ERROR [EXPECTED_OP]",exp_tr.convert2string() , UVM_LOW)
          `uvm_warning("ERROR",exp_tr.convert2string())
	      end
      //else $display("no match of if and else if");
      count++;
      //$display("count = %d",count);
    end
  endtask

  function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        if (VECT_CNT && !ERROR_CNT)
            `uvm_info("PASSED",
            $sformatf("*** TEST PASSED - %0d vectors ran, %0d vectors passed ***",VECT_CNT, PASS_CNT), UVM_LOW)

        else
            `uvm_info("FAILED",$sformatf("*** TEST FAILED - %0d vectors ran, %0d vectors passed, %0d vectors failed ***",
            VECT_CNT, PASS_CNT, ERROR_CNT), UVM_LOW)
  endfunction

  function void PASS();
	VECT_CNT++;
	PASS_CNT++;
  endfunction

  function void ERROR();
  	VECT_CNT++;
  	ERROR_CNT++;
  endfunction

endclass