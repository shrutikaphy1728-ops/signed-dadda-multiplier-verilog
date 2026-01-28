module grey_cell(
    // Inputs from the 'left' (more significant) group
    input P_in_L, G_in_L,

    // Input from the 'right' (less significant) group
    input G_in_R,

    // Output
    output G_out
);
    assign G_out = G_in_L | (P_in_L & G_in_R);

endmodule