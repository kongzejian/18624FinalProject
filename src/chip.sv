`default_nettype none

module my_chip (
    input logic [11:0] io_in, // Inputs to your chip
    output logic [11:0] io_out, // Outputs from your chip
    input logic clock,
    input logic reset // Important: Reset is ACTIVE-HIGH
);
    

    ChipInterface #(.FRE(25000000)) chipInterface_inst(
        .clock(clock),
        .confirm(io_in[0]),
        .clear(io_in[1]),
        .algorithm_select_mode(io_in[2]),
        .reset(reset),
        .enter0(io_in[3]), 
        .enter1(io_in[4]),
        .led(io_out[5:0])
    );

endmodule
