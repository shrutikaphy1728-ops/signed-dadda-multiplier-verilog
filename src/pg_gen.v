// Vectorized Propagate and Generate Block
module pg_gen (
    input  [31:0] A, 
    input  [31:0] B,
    output [31:0] P, 
    output [31:0] G
);

    // These operations are performed bit-wise on the 16-bit vectors.
    assign P = A ^ B; // P[i] = A[i] ^ B[i]
    assign G = A & B; // G[i] = A[i] & B[i]
    
endmodule
