module  Automatic_Garage_Door_Controller (
	input  wire Activate,
	input  wire UP_Max,
	input  wire DN_Max,
	input  wire CLK, RST,
	output reg UP_M, DN_M
	);

localparam	IDLE =2'b00,
			Mv_Dn =2'b01,
			Mv_Up =2'b11;

reg [1:0] current_state, next_state;

always @(posedge CLK or negedge RST) begin
	if (!RST) begin
		current_state <= IDLE;
	end
	else begin
		current_state <= next_state;
	end
end

always @(*) begin
	case (current_state)
	IDLE : begin
		if (!Activate)
			next_state = IDLE;
		else if (UP_Max & (!DN_Max))
			next_state = Mv_Dn;
		else if (DN_Max & (!UP_Max))
			next_state = Mv_Up;
		UP_M = 0;
		DN_M = 0;
	end
	Mv_Dn : begin
		if (DN_Max)
			next_state = IDLE;
		UP_M = 0;
		DN_M = 1;
	end
	Mv_Up : begin
		if (UP_Max)
			next_state = IDLE;
		UP_M = 1;
		DN_M = 0;
	end
	endcase
end

endmodule