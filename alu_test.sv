
class alu_test extends uvm_test;

    //--------------------------------------------------------------------------
    `uvm_component_utils(alu_test)
    //--------------------------------------------------------------------------

    //--------------------------------------------------------------------------
    function new(string name="alu_test",uvm_component parent);
	    super.new(name,parent);
    endfunction
    //--------------------------------------------------------------------------

    alu_env env_h;
    int file_h;

    //--------------------------------------------------------------------------
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      env_h = alu_env::type_id::create("env_h",this);
    endfunction
    //--------------------------------------------------------------------------

    //--------------------------------------------------------------------------
    function void end_of_elobartion_phase(uvm_phase phase);
      //factory.print();
      $display("End of eleboration phase in agent");
    endfunction
    //--------------------------------------------------------------------------

    //--------------------------------------------------------------------------
    function void start_of_simulation_phase(uvm_phase phase);
      $display("start_of_simulation_phase");
      file_h=$fopen("LOG_FILE.log","w");
      set_report_default_file_hier(file_h);
      set_report_severity_action_hier(UVM_INFO,UVM_DISPLAY+UVM_LOG);
      set_report_verbosity_level_hier(UVM_MEDIUM);
    endfunction
    //--------------------------------------------------------------------------

    //--------------------------------------------------------------------------
    task run_phase(uvm_phase phase);
        alu_sequence seq;
	      phase.raise_objection(this);
            seq= alu_sequence::type_id::create("seq");
            seq.start(env_h.agent_h.sequencer_h);
      		#10;
           
	      phase.drop_objection(this);
    endtask
    //--------------------------------------------------------------------------

endclass:alu_test

