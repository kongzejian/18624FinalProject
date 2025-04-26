// Code your design here
module RangeFinder 
  #(parameter WIDTH=16)
    (input logic [WIDTH-1:0] data_in, 
    input logic clock, reset, 
    input logic go, finish, 
    output logic [WIDTH-1:0] range,
    output logic debug_error);

  enum logic [1:0] {IDLE = 2'b00, RUN = 2'b01, ERROR = 2'b11} current_state, next_state; 
    logic [WIDTH-1:0] smallest, largest;
  	
  	always_ff @(posedge clock or posedge reset) begin
      	if(reset) current_state <= IDLE;
      	else current_state <= next_state;
  	end
  
  
  	always_comb begin
      unique case(current_state)
        IDLE: begin
          if(go && finish)
            next_state = ERROR;
          else if(finish)
            next_state = ERROR;
          else if(go)
            next_state = RUN;
          else 
            next_state = IDLE;
        end
        RUN: begin
          if(go && finish)
            next_state = ERROR;
          else if(go && !finish)
            next_state = RUN;
          else if(finish)
            next_state = IDLE;
          else
            next_state = RUN;
        end
        ERROR: begin
          if(go && finish)
            next_state = ERROR;
          else if(go && !finish)
            next_state = RUN;
          else
            next_state = ERROR;
        end
      endcase
    end

  assign debug_error = current_state == ERROR;
  assign range = largest - smallest;
  
  always_ff @(posedge clock or posedge reset) begin
    if(reset) largest <= 0;
    else if((current_state == IDLE || current_state == ERROR) && go && !finish) largest <= data_in;
    else if(current_state == RUN && data_in > largest) largest <= data_in;
  end
  
  always_ff @(posedge clock or posedge reset) begin
    if(reset) smallest <= 0;
    else if((current_state == IDLE || current_state == ERROR) && go && !finish) smallest <= data_in;
    else if(current_state == RUN && data_in < smallest) smallest <= data_in;
  end
  
endmodule