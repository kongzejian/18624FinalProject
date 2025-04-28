module ChipInterface #(parameter FRE = 25000000) (
    input logic clock,
    input logic confirm,
    input logic clear,
    input logic algorithm_select_mode,
    input reset,
    input logic enter0, enter1,
    output logic [5:0] led
  );

  logic confirm_sync, clear_sync, enter0_sync, enter1_sync, algorithm_select_mode_sync;
  logic enter0_valid_press, enter1_valid_press, clear_valid_press, confirm_valid_press, algorithm_select_mode_valid_press;
  logic [11:0] password_current, password_next;
  logic [11:0] password_ref;
  logic [5:0] OTP;
  logic change_current, change_next;
  logic [31:0] cnt_current, cnt_next;
  logic [1:0] wrong_password_time_current, wrong_password_time_next;
  logic algorithm_selet_current, algorithm_selet_next;
  logic [2:0] algorithm_mode_current, algorithm_mode_next;

  password_generator password_generator_inst(
    .clock(clock),
    .reset(reset),  
    .algorithm_select(algorithm_mode_current),
    .OTP(OTP), 
    .password(password_ref));

  FF2_Synchronizer confirm_sync_ (
    .clock(clock),
    .button(confirm),
    .sync_button(confirm_sync)
  );

  FF2_Synchronizer clear_sync_ (
    .clock(clock),
    .button(clear),
    .sync_button(clear_sync)
  );

  FF2_Synchronizer enter0_sync_ (
    .clock(clock),
    .button(enter0),
    .sync_button(enter0_sync)
  );

  FF2_Synchronizer enter1_sync_ (
    .clock(clock),
    .button(enter1),
    .sync_button(enter1_sync)
  );

  FF2_Synchronizer algorithm_select_mode_sync_ (
    .clock(clock),
    .button(algorithm_select_mode),
    .sync_button(algorithm_select_mode_sync)
  );

  button_handler confirm_valid(.clock(clock), .reset(reset), .btn(confirm_sync), .valid_press(confirm_valid_press));
  button_handler clear_valid(.clock(clock), .reset(reset), .btn(clear_sync), .valid_press(clear_valid_press));
  button_handler enter0_valid(.clock(clock), .reset(reset), .btn(enter0_sync), .valid_press(enter0_valid_press));
  button_handler enter1_valid(.clock(clock), .reset(reset), .btn(enter1_sync), .valid_press(enter1_valid_press));
  button_handler algorithm_select_mode_valid(.clock(clock), .reset(reset), .btn(algorithm_select_mode_sync), .valid_press(algorithm_select_mode_valid_press));
  OTP_generator inst_OTP_generator(.clock(clock), .reset(reset), .change(change_current), .OTP(OTP));

  typedef enum logic [2:0] {IDLE = 3'b000, 
                            TIMEOUT = 3'b001, 
                            INPUT = 3'b010, 
                            VERIFY = 3'b011, 
                            PASS = 3'b100, 
                            FAIL = 3'b101, 
                            LOCK = 3'b110,
                            ALGO_SELECT = 3'b111} state_t;

  state_t current_state, next_state;


  always_ff @(posedge clock or posedge reset) begin 
    if(reset) begin
      current_state <= IDLE;
      password_current <= 0;
      change_current <= 0;
      wrong_password_time_current <= 0;
      algorithm_selet_current <= 0;
      algorithm_mode_current <= 0;
      cnt_current <= 0;
    end
    else begin
      current_state <= next_state;
      password_current <= password_next;
      change_current <= change_next;
      wrong_password_time_current <= wrong_password_time_next;
      algorithm_selet_current <= algorithm_selet_next;
      algorithm_mode_current <= algorithm_mode_next;
      cnt_current <= cnt_next;
    end
  end


  always_comb begin
    case(current_state)
      IDLE: begin
        wrong_password_time_next = wrong_password_time_current;
        algorithm_mode_next = algorithm_mode_current;
        if(cnt_current == 60 * FRE -1) begin
          next_state = TIMEOUT;
          password_next = 0;
          change_next = 1;
          algorithm_selet_next = 0;
          cnt_next = 0;
        end
        else if(algorithm_select_mode_valid_press) begin
            algorithm_selet_next = 1;
            next_state = INPUT;
            change_next = 0;
            password_next = 0;
            cnt_next = 0;
        end
        else if(enter0_valid_press)begin
           cnt_next = 0;
           next_state = INPUT;
           password_next = {password_current[10:0],1'b0};
           change_next = 0;
           algorithm_selet_next = 0;
        end 
        else if(enter1_valid_press)begin
           cnt_next = 0;
           next_state = INPUT;
           password_next = {password_current[10:0],1'b1};
           change_next = 0;
           algorithm_selet_next = 0;
        end 
        else begin
          cnt_next = cnt_current + 1;
          next_state = IDLE;
          password_next = 0;
          change_next = 0;
          algorithm_selet_next = 0;
        end
      end
      TIMEOUT: begin
        next_state = IDLE;
        wrong_password_time_next = wrong_password_time_current;
        cnt_next = cnt_current + 1;
        password_next = 0;
        change_next = 0;
        algorithm_selet_next = 0;
        algorithm_mode_next = algorithm_mode_current;
      end
      INPUT:begin
        wrong_password_time_next = wrong_password_time_current;
        cnt_next = 0;
        change_next = 0;
        algorithm_selet_next = algorithm_selet_current;
        algorithm_mode_next = algorithm_mode_current;
        if(confirm_valid_press) begin
           next_state = VERIFY;
           password_next = password_current;
        end
        else if(clear_valid_press) begin
           next_state = INPUT;
           password_next = 0;
        end
        else if(enter0_valid_press) begin
           next_state = INPUT;
           password_next = {password_current[10:0],1'b0};
        end 
        else if(enter1_valid_press)begin
           next_state = INPUT;
           password_next = {password_current[10:0],1'b1};
        end
        else begin
          next_state = INPUT;
          password_next = password_current;
        end
      end
      VERIFY: begin
        cnt_next = 0;
        password_next = 0;
        change_next = 0;
        algorithm_selet_next = algorithm_selet_current;
        algorithm_mode_next = algorithm_mode_current;
        if(password_current == password_ref) begin
            next_state = PASS;
            wrong_password_time_next = wrong_password_time_current;
        end
        else begin
            next_state = FAIL;
            wrong_password_time_next = wrong_password_time_current + 1;
        end
      end
      PASS: begin
        wrong_password_time_next = wrong_password_time_current;
        password_next = 0;
        algorithm_selet_next = algorithm_selet_current;
        algorithm_mode_next = algorithm_mode_current;
        if(cnt_current == 6 * FRE) begin
          if(algorithm_selet_current == 1) begin
              next_state = ALGO_SELECT;
              change_next = 0;
          end
          else begin
              next_state = IDLE;
              change_next = 1;
          end
          cnt_next = 0;
        end 
        else begin
          cnt_next = cnt_current + 1;
          next_state = PASS;
          change_next = 0;
        end
      end
      ALGO_SELECT : begin
        password_next = 0;
        cnt_next = 0;
        algorithm_selet_next = 0;
        wrong_password_time_next = wrong_password_time_current;
        if(confirm_valid_press) begin
           next_state = IDLE;
           algorithm_mode_next = algorithm_mode_current;
           change_next = 1;
        end
        else if(clear_valid_press) begin
           next_state = ALGO_SELECT;
           algorithm_mode_next = 0;
           change_next = 0;
        end
        else if(enter0_valid_press) begin
           next_state = ALGO_SELECT;
           algorithm_mode_next = {algorithm_mode_current[1:0],1'b0};
           change_next = 0;
        end 
        else if(enter1_valid_press)begin
           next_state = ALGO_SELECT;
           algorithm_mode_next = {algorithm_mode_current[1:0],1'b1};
           change_next = 0;
        end
        else begin
           next_state = ALGO_SELECT;
           algorithm_mode_next = algorithm_mode_current;
           change_next = 0;
        end
      end
      FAIL: begin
        algorithm_mode_next = algorithm_mode_current;
        wrong_password_time_next = wrong_password_time_current;
        password_next = 0;
        algorithm_selet_next = 0;
        if(cnt_current == 6 * FRE) begin
          change_next = 1;
          cnt_next = 0;
          next_state = LOCK;
        end 
        else begin
          cnt_next = cnt_current + 1;
          next_state = FAIL;
          change_next = 0;
        end
      end
      LOCK: begin
         algorithm_mode_next = algorithm_mode_current;
         cnt_next = cnt_current + 1;
         wrong_password_time_next = wrong_password_time_current;
         password_next = 0;
         algorithm_selet_next = 0;
         if(wrong_password_time_current == 1) begin
            if(cnt_current == 15 * FRE) begin
              next_state = IDLE;
              change_next = 1;
            end
            else begin
              next_state = LOCK;
              change_next = 0;
            end
         end
         else if (wrong_password_time_current == 2) begin
            if(cnt_current == 30 * FRE) begin
              next_state = IDLE;
              change_next = 1;
            end
            else begin
               next_state = LOCK;
              change_next = 0;
            end 
         end
         else begin
            if(cnt_current == 60 * FRE) begin
                 next_state = IDLE;
                 change_next = 1;
            end
            else begin
              next_state = LOCK;
              change_next = 0;
            end
         end
      end
    endcase
  end

  //LED
  always_ff @(posedge clock or posedge reset) begin
    if(reset) led <= 6'b0;
    else if(current_state == PASS) led <= 6'b111111;
    else if(current_state == ALGO_SELECT) begin
        led = {4'b0, algorithm_mode_current};
    end
    else if(current_state == FAIL) begin
    if ((cnt_current >= FRE*1 && cnt_current < FRE*2) || 
        (cnt_current >= FRE*3 && cnt_current < FRE*4) || 
        (cnt_current >= FRE*5 && cnt_current < FRE*6))
        led <= 6'b0; 
    else
        led <= 6'b111111; 
    end
    else if(current_state == LOCK) led <= 6'b101010;
    else led <= OTP;
  end

endmodule

module password_generator(
    input logic clock,
    input logic reset,  
    input logic [2:0] algorithm_select,
    input logic [5:0] OTP,
    output logic [11:0] password
);
    
  always_ff @(posedge clock or posedge reset) begin
      if(reset) begin
          password <= 0;
      end
      else begin
        case(algorithm_select)
            3'd0: password <= OTP * 2 + 1;                    
            3'd1: password <= (OTP << 2) ^ 12'hA3; 
            // 3'd0: password <= OTP;                    
            // 3'd1: password <= OTP * 2;           
            3'd2: password <= (OTP * 3) + (OTP >> 1);         
            3'd3: password <= ~(OTP * 5) & 12'hFFF;           
            3'd4: password <= (OTP * OTP) % 4096;             
            3'd5: password <= ((OTP << 3) - OTP) ^ 12'h3C3;   
            3'd6: password <= {OTP[2:0], OTP[5:3]} + 12'h55A; 
            3'd7: password <= (OTP * 9) & 12'hFFF;            
        endcase
      end
  end
endmodule

module OTP_generator(
    input logic clock,
    input logic change,
    input reset,
    output logic [5:0] OTP 
);

    logic [5:0] lfsr;

    always_ff @(posedge clock or posedge reset) begin
        if (reset)
            lfsr <= 6'b101101;  
        else if (change)
            lfsr <= {lfsr[4:0], lfsr[5] ^ lfsr[3]};
    end

    assign OTP = lfsr;

endmodule

module button_handler (
    input  logic clock,        
    input  logic reset,
    input  logic btn,         
    output logic valid_press  
);
    parameter COUNT_MAX = 250_000;

    logic btn_pre;
    logic [$clog2(COUNT_MAX):0] count;
    logic armed;

    always_ff @(posedge clock or posedge reset) begin
        if (reset)
            btn_pre <= 0;
        else
            btn_pre <= btn;
    end

    always_ff @(posedge clock or posedge reset) begin
        if (reset) begin
            count <= 0;
            valid_press <= 0;
            armed <= 1;
        end else begin
            valid_press <= 0;  
            if (btn && btn_pre) begin  
                if (armed) begin
                    if (count < COUNT_MAX - 1) begin
                        count <= count + 1;
                    end else begin
                        valid_press <= 1;  
                        armed <= 0;        
                        count <= 0;
                    end
                end
            end else begin
                count <= 0;
                if (!btn) 
                    armed <= 1; 
            end
        end
    end
endmodule

module FF2_Synchronizer(
  input logic clock,
  input logic button,
  output logic sync_button
);
  logic [1:0] button_dff;
  always_ff @(posedge clock) begin
    button_dff[0] <= button;
    button_dff[1] <= button_dff[0];
  end
  assign sync_button = button_dff[1];
endmodule