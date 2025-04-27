## One-Time Password (OTP) Electronic Lock
This project implements a One-Time Password (OTP) Challenge-Response Electronic Lock, designed to avoid using non-volatile memory for password storage. Instead of saving a password, the system generates a random number on each authentication attempt and displays it via LEDs. Users compute the correct response based on a predefined algorithm and input it through buttons. If the response matches, the lock opens. Additional features include a progressive lockout mechanism after multiple wrong attempts, automatic OTP regeneration after periods of inactivity, and dynamic algorithm switching after password verification. The system architecture includes a random number generator using shift registers and XOR gates, a locking counter, a 12 I/O distribution system with LEDs and buttons for input/output control, and a finite state machine (FSM) to manage the overall logic.

## IO

An IO table listing all of your inputs and outputs and their function, like the one below:

| Input/Output	| Description|																
|-------------|--------------------------------------------------|
| io_in[0]    | confirm the input data |
| io_in[1] | clear the input data                                           |
| io_in[2] | algorithm selection mode button                                      |
| io_in[3] | enter 0                                    |
| io_in[4] | enter 1                                     |
| io_out[5:0]   | led display                              |
## How to Test
Software Simulation  

Goal:  

To verify the correctness of OTP/password handling logic and timing behaviors.
Scenarios to Cover:  

(1) Timeout  

Test Case 1.1: Wait for more than 60 seconds without input, system should generate a new OTP.  

Validation: Assert that a new OTP is generated and old OTP is invalidated.  

(2) Correct Password Entry  

Test Case 2.1: Input correct password and press Confirm, then system unlocks.  

Validation: Check LED signal.  

(3) Incorrect Password  

Test Case 3.1: Input incorrect password once and press Confirm, system is locked.  

Test Case 3.2: Input incorrect password three times, system is locked for longer time after each try.  

Validation: Check LED signal and ensure new OTP is generated after returning to IDLE.  

(4) Clear Input  

Test Case 4.1: Input some digits and press Clear, password buffer should be empty.  

Validation: Check password buffer.  

(5) Algorithm Selection  

Test Case 5.1: Enter correct password to enter algorithm selection mode. Enter the binary code to choose a different algorithm. Then repeat tests listed above.  

FPGA-based Hardware Testing  

Goal:  

Validate the design on real hardware, including button inputs, debounce (joggle), and long presses.
Scenarios to Cover:  

(1) Button Debounce  

Simulate noisy input: rapidly toggle a button pin within short time (simulate bounce).  

Validation: Ensure system only registers one press.  

(2) Long Button Press  

Hold down a button for more than 1 second.   

Validation: Should either be interpreted as a single input, or trigger alternate behavior if specified.  

(3) All 5 Functional Scenarios from Software Simulation  

(4) Stress Test  

Repeated random input and clear presses.
Rapid confirm and cancel toggles.


