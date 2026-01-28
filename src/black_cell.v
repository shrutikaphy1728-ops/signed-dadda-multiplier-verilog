// Black Cell with more descriptive port names
module black_cell (
    // Inputs from the 'left' (more significant) group
    input P_in_L, G_in_L,
    
    // Inputs from the 'right' (less significant) group
    input P_in_R, G_in_R,

    // Combined group outputs
    output P_out, G_out
);

    assign P_out = P_in_L & P_in_R;
    assign G_out = G_in_L | (P_in_L & G_in_R);

endmodule