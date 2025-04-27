module Design_tb;

    // Declare testbench signals
    logic clock;
    logic confirm;
    logic clear;
    logic reset;
    logic enter0, enter1;
    logic algorithm_select_mode;
    logic [5:0] led;

    // Instantiate the Design module
    ChipInterface uut (
        .clock(clock),
        .confirm(confirm),
        .clear(clear),
        .reset(reset),
        .enter0(enter0),
        .enter1(enter1),
        .algorithm_select_mode(algorithm_select_mode),
        .led(led)
    );

    // Clock generation
    always #5 clock = ~clock; // 10 ns clock period

    task wait_cycles;
    input integer num_cycles;
    integer i;
    begin
        for (i = 0; i < num_cycles; i = i + 1) begin
            @(posedge clock); // Wait for each rising edge of clock
        end
    end
    endtask

    task enter_button;
    input string password;
    integer i;
    begin
        $display("Entering: %s", password);
        for (i = 0; i < password.len(); i = i + 1) begin
            if(password[i] == "1") begin
                @(posedge clock)
                enter1 <= 1;
                enter0 <= 0;
                clear <= 0;
                confirm <= 0;
                algorithm_select_mode <= 0;
                @(posedge clock)
                enter1 <= 1;
                enter0 <= 0;
                clear <= 0;
                confirm <= 0;
                algorithm_select_mode <= 0;
                @(posedge clock)
                enter1 <= 1;
                enter0 <= 0;
                clear <= 0;
                confirm <= 0;
                algorithm_select_mode <= 0;

                @(posedge clock)
                enter1 <= 0;
                enter0 <= 0;
                clear <= 0;
                confirm <= 0;
                algorithm_select_mode <= 0;
                @(posedge clock)
                enter1 <= 0;
                enter0 <= 0;
                clear <= 0;
                confirm <= 0;
                algorithm_select_mode <= 0;
                @(posedge clock)
                enter1 <= 0;
                enter0 <= 0;
                clear <= 0;
                confirm <= 0;
                algorithm_select_mode <= 0;
            end
            else if(password[i] == "0")begin
                @(posedge clock)
                enter1 <= 0;
                enter0 <= 1;
                clear <= 0;
                confirm <= 0;
                algorithm_select_mode <= 0;
                @(posedge clock)
                enter1 <= 0;
                enter0 <= 1;
                clear <= 0;
                confirm <= 0;
                algorithm_select_mode <= 0;
                @(posedge clock)
                enter1 <= 0;
                enter0 <= 1;
                clear <= 0;
                confirm <= 0;
                algorithm_select_mode <= 0;

                @(posedge clock)
                enter1 <= 0;
                enter0 <= 0;
                clear <= 0;
                confirm <= 0;
                algorithm_select_mode <= 0;
                @(posedge clock)
                enter1 <= 0;
                enter0 <= 0;
                clear <= 0;
                confirm <= 0;
                algorithm_select_mode <= 0;
                @(posedge clock)
                enter1 <= 0;
                enter0 <= 0;
                clear <= 0;
                confirm <= 0;
                algorithm_select_mode <= 0;
            end
            else if(password[i] == "f") begin //confirm
                @(posedge clock)
                confirm <= 1;
                enter1 <= 0;
                enter0 <= 0;
                clear <= 0;
                algorithm_select_mode <= 0;
                @(posedge clock)
                confirm <= 1;
                enter1 <= 0;
                enter0 <= 0;
                clear <= 0;
                algorithm_select_mode <= 0;
                @(posedge clock)
                confirm <= 1;
                enter1 <= 0;
                enter0 <= 0;
                clear <= 0;
                algorithm_select_mode <= 0;

                @(posedge clock)
                confirm <= 0;
                enter1 <= 0;
                enter0 <= 0;
                clear <= 0;
                algorithm_select_mode <= 0;
                @(posedge clock)
                confirm <= 0;
                enter1 <= 0;
                enter0 <= 0;
                clear <= 0;
                algorithm_select_mode <= 0;
                @(posedge clock)
                confirm <= 0;
                enter1 <= 0;
                enter0 <= 0;
                clear <= 0;
                algorithm_select_mode <= 0;
            end
            else if(password[i] == "c") begin //clear
                @(posedge clock)
                confirm <= 0;
                enter1 <= 0;
                enter0 <= 0;
                clear <= 1;
                algorithm_select_mode <= 0;
                @(posedge clock)
                confirm <= 0;
                enter1 <= 0;
                enter0 <= 0;
                clear <= 1;
                algorithm_select_mode <= 0;
                @(posedge clock)
                confirm <= 0;
                enter1 <= 0;
                enter0 <= 0;
                clear <= 1;
                algorithm_select_mode <= 0;

                @(posedge clock)
                confirm <= 0;
                enter1 <= 0;
                enter0 <= 0;
                clear <= 0;
                algorithm_select_mode <= 0;
                @(posedge clock)
                confirm <= 0;
                enter1 <= 0;
                enter0 <= 0;
                clear <= 0;
                algorithm_select_mode <= 0;
                @(posedge clock)
                confirm <= 0;
                enter1 <= 0;
                enter0 <= 0;
                clear <= 0;
                algorithm_select_mode <= 0;
            end
            else if(password[i] == "s") begin //select
                @(posedge clock)
                confirm <= 0;
                enter1 <= 0;
                enter0 <= 0;
                clear <= 0;
                algorithm_select_mode <= 1;
                @(posedge clock)
                confirm <= 0;
                enter1 <= 0;
                enter0 <= 0;
                clear <= 0;
                algorithm_select_mode <= 1;
                @(posedge clock)
                confirm <= 0;
                enter1 <= 0;
                enter0 <= 0;
                clear <= 0;
                algorithm_select_mode <= 1;

                @(posedge clock)
                confirm <= 0;
                enter1 <= 0;
                enter0 <= 0;
                clear <= 0;
                algorithm_select_mode <= 0;
                @(posedge clock)
                confirm <= 0;
                enter1 <= 0;
                enter0 <= 0;
                clear <= 0;
                algorithm_select_mode <= 0;
                @(posedge clock)
                confirm <= 0;
                enter1 <= 0;
                enter0 <= 0;
                clear <= 0;
                algorithm_select_mode <= 0;
            end
        end
            
            $display("Entering complete.");
    end
endtask



    // Test sequence
    initial begin
        // Initialize signals
        clock = 0;
        reset = 1;
        confirm = 0;
        clear = 0;
        enter0 = 0;
        enter1 = 0;
        algorithm_select_mode = 0;
        
        // Apply reset
        #20 reset = 0;

        
        //test timeout
        reset = 1;
        #20 reset = 0;
        wait_cycles(360); //60*6


        //test correct password
        reset = 1;
        #20 reset = 0;
        enter_button("101101f"); //select 
        wait_cycles(36); //pass: 6 cycles 6*6

        //test wrong password
        reset = 1;
        #20 reset = 0;
        enter_button("111111f");
        wait_cycles(36); //fail
        wait_cycles(90); //lock
        wait_cycles(6);// idle
        enter_button("111111f");
        wait_cycles(36); //fail
        wait_cycles(180); //lock
        wait_cycles(6);// idle
        enter_button("111111f");
        wait_cycles(36); //fail
        wait_cycles(360); //lock
        wait_cycles(6);// idle

        //clear password
        enter_button("10c101101f"); //select 
        wait_cycles(36); //pass: 6 cycles 6*6

        //test mode select
        wait_cycles(4);
        enter_button("s101101f"); //select 
        wait_cycles(36); //pass: 6 cycles 6*6
        enter_button("001f"); //choose mode 2
        wait_cycles(6);//mode_select-> idle
        enter_button("110100f");
        wait_cycles(36); //pass: 5 cycles 6*5
        enter_button("s1101010f"); //select 
        wait_cycles(36);//pass: 5 cycles 6*5
        enter_button("000f"); //choose mode 2
        wait_cycles(6);
        enter_button("101011f"); //select 

        // End simulation
        #100 $finish;
    end

    // Monitor output
    initial begin
        $monitor("Time=%0t | reset=%b, confirm=%b, clear=%b, enter0=%b, enter1=%b, alg_mode=%b, led=%b", 
                 $time, reset, confirm, clear, enter0, enter1, algorithm_select_mode, led);
    end

endmodule