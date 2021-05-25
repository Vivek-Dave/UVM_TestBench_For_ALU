
class alu_driver extends uvm_driver #(alu_sequence_item);
  //----------------------------------------------------------------------------
  `uvm_component_utils(alu_driver)
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  function new(string name="alu_driver",uvm_component parent);
    super.new(name,parent);
  endfunction
  //---------------------------------------------------------------------------- 

  //--------------------------  virtual interface handel -----------------------  
  virtual interface intf vif;
  //----------------------------------------------------------------------------

  uvm_analysis_port #(alu_sequence_item) drv2sb;

  //-------------------------  get interface handel from top -------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!(uvm_config_db#(virtual intf)::get(this,"","vif",vif))) begin
      `uvm_fatal("driver","unable to get interface");
    end
    drv2sb=new("drv2sb",this);
  endfunction
  //----------------------------------------------------------------------------
  
  //---------------------------- run task --------------------------------------
  task run_phase(uvm_phase phase);
    alu_sequence_item txn=alu_sequence_item::type_id::create("txn");
    initilize();
    forever begin
      seq_item_port.get_next_item(txn);
      drive_item(txn);
      drv2sb.write(txn);
      seq_item_port.item_done();    
    end
  endtask
  //----------------------------------------------------------------------------
  task initilize();
    vif.in1 = 0;
    vif.in2 = 0;
    vif.s   = 0;
    vif.m   = 0;
    vif.cin = 0;
  endtask

  task drive_item(alu_sequence_item tx);
    vif.in1 = tx.in1;
    vif.in2 = tx.in2;
    vif.s   = tx.s;
    vif.m   = tx.m;
    vif.cin = tx.cin;
  endtask

endclass:alu_driver