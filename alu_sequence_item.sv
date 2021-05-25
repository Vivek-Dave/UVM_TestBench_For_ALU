class alu_sequence_item extends uvm_sequence_item;

  //------------ i/p || o/p field declaration-----------------

  rand logic [7:0] in1;  //i/p
  rand logic [7:0] in2;
  rand logic [3:0] s;
  rand logic m;
  rand logic cin;

  logic [7:0] out;        //o/p
  logic aeb;
  logic cout;
  
  //---------------- register alu_sequence_item class with factory --------
  `uvm_object_utils_begin(alu_sequence_item) 
     `uvm_field_int( in1  ,UVM_ALL_ON)
     `uvm_field_int( in2  ,UVM_ALL_ON)
     `uvm_field_int( s    ,UVM_ALL_ON)
     `uvm_field_int( m    ,UVM_ALL_ON)
     `uvm_field_int( cin  ,UVM_ALL_ON)
     `uvm_field_int( out  ,UVM_ALL_ON)
     `uvm_field_int( aeb  ,UVM_ALL_ON)
     `uvm_field_int( cout ,UVM_ALL_ON)
  `uvm_object_utils_end
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  function new(string name="alu_sequence_item");
    super.new(name);
  endfunction
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  // write DUT inputs here for printing
  function string input2string();
    return($sformatf("in1=%8b  in2=%8b s=%4b m=%b cin=%b", in1,in2,s,m,cin));
  endfunction
  
  // write DUT outputs here for printing
  function string output2string();
    return($sformatf("out=%8b cout=%b aeb=%b", out,cout,aeb));
  endfunction
    
  function string convert2string();
    return($sformatf({input2string(), "  ", output2string()}));
  endfunction
  //----------------------------------------------------------------------------

endclass:alu_sequence_item
