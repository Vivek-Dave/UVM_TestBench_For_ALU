
/***************************************************
** class name  : alu_sequence
** description : apply all stimulus sequentially
                 s iterate from 0 to 15.
                 for both logical and arithmetic 
                 operation 
***************************************************/
class alu_sequence extends uvm_sequence#(alu_sequence_item);
  //----------------------------------------------------------------------------
  `uvm_object_utils(alu_sequence)            
  //----------------------------------------------------------------------------

  alu_sequence_item txn;
  int unsigned LOOP=2;

  //----------------------------------------------------------------------------
  function new(string name="alu_sequence");  
    super.new(name);
  endfunction
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  virtual task body();
    txn=alu_sequence_item::type_id::create("txn");
    sequence_logical_stimulus(txn);
    sequence_arithmetic_cin0_stimulus(txn);
    sequence_arithmetic_cin1_stimulus(txn);
    force_in1_in2_to_ff(txn);
    force_in1_in2_to_0(txn);
  endtask:body
  //----------------------------------------------------------------------------
  // m==1 and logical operation 
  task sequence_logical_stimulus(alu_sequence_item txn);
    repeat(LOOP) begin
      for(int i=0;i<16;i++) begin
        start_item(txn);
        txn.randomize()with{txn.s==i;txn.m==1;txn.cin==0;};
        #5;
        finish_item(txn);
      end
    end
  endtask
  // m==0 and cin==0 ; arithmetic operation 
  task sequence_arithmetic_cin0_stimulus(alu_sequence_item txn);
    repeat(LOOP) begin
      for(int i=0;i<16;i++) begin
        start_item(txn);
        txn.randomize()with{txn.s==i;txn.m==0;txn.cin==0;};
        #5;
        finish_item(txn);
      end
    end
  endtask

  // m==0 and cin==1 ; arithmetic operation 
  task sequence_arithmetic_cin1_stimulus(alu_sequence_item txn);
    repeat(LOOP) begin
      for(int i=0;i<16;i++) begin
        start_item(txn);
        txn.randomize()with{txn.s==i;txn.m==0;txn.cin==1;};
        #5;
        finish_item(txn);
      end
    end
  endtask
  
  task force_in1_in2_to_ff(alu_sequence_item txn);
    repeat(LOOP) begin
      for(int i=0;i<16;i++) begin
        start_item(txn);
        txn.randomize()with{txn.in1==8'b1111_1111; txn.in2==8'b1111_1111;};
        #5;
        finish_item(txn);
      end
    end
  endtask
  
  task force_in1_in2_to_0(alu_sequence_item txn);
    repeat(LOOP) begin
      for(int i=0;i<16;i++) begin 
        //txn=alu_sequence_item::type_id::create("txn");
        start_item(txn);
        txn.randomize()with{txn.in1==0;txn.in2==0;txn.s==i;};
        #5;
        finish_item(txn);
      end
    end
  endtask

endclass:alu_sequence
