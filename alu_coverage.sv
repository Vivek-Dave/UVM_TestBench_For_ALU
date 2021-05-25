
class alu_coverage extends uvm_subscriber #(alu_sequence_item);

  //----------------------------------------------------------------------------
  `uvm_component_utils(alu_coverage)
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  function new(string name="",uvm_component parent);
    super.new(name,parent);
    dut_cov=new();
  endfunction
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  alu_sequence_item txn;
  real cov;
  //----------------------------------------------------------------------------
  
  //----------------------------------------------------------------------------
  covergroup dut_cov;
    option.per_instance= 1;
    option.comment     = "dut_cov";
    option.name        = "dut_cov";
    option.auto_bin_max= 256;
    LOGICAL_OPERATION_S:coverpoint txn.s; 

    LOGICAL_OPERATION_M:coverpoint txn.m { 
        bins m_high_for_logical_operation={1};
    }
    L_SXL_M:cross LOGICAL_OPERATION_M,LOGICAL_OPERATION_S;

    ARITHMETIC_OPERATION_S:coverpoint txn.s; 

    ARITHMETIC_OPERATION_M:coverpoint txn.m { 
        bins m_low_for_arithmetic_operation={0};
    }
    ARITHMETIC_OPERATION_CIN_0: coverpoint txn.cin{
      bins cin_low={0};
    }

    ARITHMETIC_OPERATION_CIN_1: coverpoint txn.cin{
      bins cin_high={1};
    }
    A1:cross ARITHMETIC_OPERATION_M,ARITHMETIC_OPERATION_S;

    CIN_0XA1:cross A1,ARITHMETIC_OPERATION_CIN_0;

    CIN_1XA1:cross A1,ARITHMETIC_OPERATION_CIN_1;
  endgroup:dut_cov;

  //----------------------------------------------------------------------------

  //---------------------  write method ----------------------------------------
  function void write(alu_sequence_item t);
    txn=t;
    dut_cov.sample();
  endfunction
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    cov=dut_cov.get_coverage();
  endfunction
  //----------------------------------------------------------------------------


  //----------------------------------------------------------------------------
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_type_name(),$sformatf("Coverage is %f",cov),UVM_MEDIUM)
  endfunction
  //----------------------------------------------------------------------------
  
endclass:alu_coverage

