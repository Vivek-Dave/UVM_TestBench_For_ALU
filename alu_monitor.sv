
class alu_monitor extends uvm_monitor;
  //----------------------------------------------------------------------------
  `uvm_component_utils(alu_monitor)
  //----------------------------------------------------------------------------

  //------------------- constructor --------------------------------------------
  function new(string name="alu_monitor",uvm_component parent);
    super.new(name,parent);
  endfunction
  //----------------------------------------------------------------------------
  
  //---------------- sequence_item class ---------------------------------------
  alu_sequence_item  txn;
  //----------------------------------------------------------------------------
  
  //------------------------ virtual interface handle---------------------------  
  virtual interface intf vif;
  //----------------------------------------------------------------------------

  //------------------------ analysis port -------------------------------------
  uvm_analysis_port#(alu_sequence_item) ap_mon;
  //----------------------------------------------------------------------------
  
  //------------------- build phase --------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!(uvm_config_db#(virtual intf)::get(this,"","vif",vif)))
    begin
      `uvm_fatal("monitor","unable to get interface")
    end
    
    ap_mon=new("ap_mon",this);
    txn=alu_sequence_item::type_id::create("txn");
  endfunction
  //----------------------------------------------------------------------------

  //-------------------- run phase ---------------------------------------------
  task run_phase(uvm_phase phase);
    forever
    begin 
      sample_dut(txn);
      ap_mon.write(txn);
    end
  endtask
  //----------------------------------------------------------------------------

  task sample_dut(output alu_sequence_item tr);
    alu_sequence_item t=alu_sequence_item::type_id::create("t");
    @(vif.in1 or vif.in2 or vif.s or vif.m or vif.cin);
    // or @(*)  --> will it work??
    t.in1  = vif.in1;
    t.in2  = vif.in2;
    t.s    = vif.s;
    t.m    = vif.m;
    t.cin  = vif.cin;
    t.out  = vif.out;
    t.cout = vif.cout;
    t.aeb  = vif.aeb;
    tr = t;
  endtask

endclass:alu_monitor

