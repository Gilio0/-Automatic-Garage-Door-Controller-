`timescale 1ns/1ps
module Automatic_Garage_Door_Controller_TB ();

reg  Activate_tb;
reg  UP_Max_tb;
reg  DN_Max_tb;
reg  CLK_tb;
reg  RST_tb;
wire UP_M_tb;
wire DN_M_tb;

Automatic_Garage_Door_Controller DUT (
	.Activate(Activate_tb),
	.UP_Max(UP_Max_tb),
	.DN_Max(DN_Max_tb),
	.CLK(CLK_tb),
	.RST(RST_tb),
	.UP_M(UP_M_tb),
	.DN_M(DN_M_tb)
	);

always #10 CLK_tb = ~CLK_tb;

initial begin
	$dumpfile("Automatic_Garage_Door_Controller.vcd");
	$dumpvars;

    initialize();

    reset();

    //Check if idle after initialization and reset
    Check(0,0);

	#20
	//Check if open
	Check(1,0);
	#40
	//Check if still until UP_Max changes
	Check(1,0);

	DN_Max_tb = 0;
	Activate_tb = 0;

	#20

	Check(1,0);

	Activate_tb = 1;

	#20

	Check(1,0);

	Activate_tb = 0;
	UP_Max_tb = 1;

	#20

	Check(0,0);

	#20

	Check(0,0);

	Activate_tb = 1;
	UP_Max_tb = 0;

	#20

	Check(0,0);

	open_door();

	#20

	Check(1,0);

	close_door();

	#20

	Check(0,0);

	#20

	Check(0,1);
	open_door();

	#20

	Check(0,0);

	#20

	Check(1,0);

	#60

	$finish;
end

task initialize;
 begin
	CLK_tb = 0;
	RST_tb = 1;
	Activate_tb = 1;
	UP_Max_tb = 0;
	DN_Max_tb = 1;
 end
endtask
  
task reset;
 begin
	RST_tb =  'b1;
	#1
	RST_tb  = 'b0;
	#1
	RST_tb  = 'b1;
 end
endtask

task open_door;
 begin
	Activate_tb = 1;
	UP_Max_tb =0;
	DN_Max_tb =1;
 end
endtask

task close_door;
 begin
	Activate_tb = 1;
	UP_Max_tb =1;
	DN_Max_tb =0;
 end
endtask

task Check(
  input  reg     UP,
  input  reg     DN
);
  
begin
	$display("Inputs: Activate = %0b,  UP_Max   = %0b,	DN_Max   = %0b,	  RST      = %0b",Activate_tb,UP_Max_tb,DN_Max_tb,RST_tb);
	if ((UP_M_tb == UP)&(DN_M_tb == DN)) begin
		$display("Correct, Expected: UP_M = %0b , DN_M = %0b ; Actual : UP_M = %0b , DN_M = %0b \n",UP,DN,UP_M_tb,DN_M_tb);
	end
	else begin
		$display("Wrong");
	end
end
endtask

endmodule