module sum_gen(
    input  [31:0] C, // Carry-in vector 
    input  [31:0] P, // Initial propagate vector from pg_gen
    output [31:0] S  // Final sum
);

    assign S = P ^ C;

endmodule
