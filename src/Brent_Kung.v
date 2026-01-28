module Brent_Kung(
    input  [31:0] A,
    input  [31:0] B,
    input         CIN,
    output [31:0] S,
    output        COUT
);

    // --- Configuration for 32-bit ---
    // Reduction Stages = log2(32) = 5
    // Expansion Stages = log2(32) - 1 = 4
    // Total Stages = 9
    localparam STAGES = 9;
    localparam ExpSTAGES = 5; 

    // Internal wires
    // [31:0] is the width of each element
    // [0:STAGES] is the number of elements (array depth)
    wire [31:0] p_stage [0:STAGES];
    wire [31:0] g_stage [0:STAGES];
    wire [31:0] C_final;

    // 1. Initial PG Generation
    pg_gen PG_inst (
        .A(A), .B(B),
        .P(p_stage[0]), .G(g_stage[0])
    );

    // 2. Prefix Tree (Reduction + Expansion)
    genvar i, j;
    generate
        for (i = 0; i < STAGES; i = i + 1) begin : STAGE_LOOP
            for (j = 0; j < 32; j = j + 1) begin : BIT_LOOP
                
                // === FORWARD TREE (Reduction) ===
                if (i < ExpSTAGES) begin
                    // Standard Brent-Kung Reduction
                    // Target indices: 1, 3, 7, 15... (2^(i+1) - 1)
                    if ( (j + 1) % (1 << (i + 1)) == 0 ) begin
                        
                        // Determine if we need Black or Grey cell
                        // Black cell if we are "far enough" to need P output for next stages
                        if ( j > ( (2 * (1 << i)) - 1 ) ) begin
                            black_cell bc_inst (
                                .P_in_L(p_stage[i][j]), .G_in_L(g_stage[i][j]),
                                .P_in_R(p_stage[i][j - (1 << i)]), .G_in_R(g_stage[i][j - (1 << i)]),
                                .P_out(p_stage[i+1][j]), .G_out(g_stage[i+1][j])
                            );
                        end else begin
                            grey_cell gc_inst (
                                .P_in_L(p_stage[i][j]), .G_in_L(g_stage[i][j]),
                                .G_in_R(g_stage[i][j - (1 << i)]),
                                .G_out(g_stage[i+1][j])
                            );
                            // CORRECTED LINE: Calculate Group Propagate using AND
                            assign p_stage[i+1][j] = p_stage[i][j] & p_stage[i][j - (1 << i)];
                        end
                    end else begin
                        // Buffer/Pass-through
                        assign p_stage[i+1][j] = p_stage[i][j];
                        assign g_stage[i+1][j] = g_stage[i][j];
                    end

                // === INVERSE TREE (Expansion) ===
                end else begin 
                    // Calculate 'dist' based on current expansion stage
                    if ( ((j - (1<<(STAGES-1-i)) + 1) % (2*(1<<(STAGES-1-i))) == 0) && (j >= (3*(1<<(STAGES-1-i)) - 1)) ) begin
                         grey_cell gc_final (
                            .P_in_L(p_stage[i][j]), .G_in_L(g_stage[i][j]),
                            .G_in_R(g_stage[i][j - (1 << (STAGES - 1 - i))]),
                            .G_out(g_stage[i+1][j])
                         );
                         // CORRECTED LINE: Calculate Group Propagate using AND
                         assign p_stage[i+1][j] = p_stage[i][j] & p_stage[i][j - (1 << (STAGES - 1 - i))];
                    end else begin
                        assign p_stage[i+1][j] = p_stage[i][j];
                        assign g_stage[i+1][j] = g_stage[i][j];
                    end
                end
            end
        end
    endgenerate

    // 3. Final Sum Generation
    assign C_final[0] = CIN;
    // We combine the Group Generate signal with the Group Propagate signal ANDed with CIN
    assign C_final[31:1] = g_stage[STAGES][30:0] | (p_stage[STAGES][30:0] & {31{CIN}});

    sum_gen SG_inst (
        .C(C_final),
        .P(p_stage[0]), // Use initial Propagate for Sum logic
        .S(S)
    );

    // 4. Carry Out Logic
    assign COUT = g_stage[STAGES][31] | (p_stage[STAGES][31] & CIN);

endmodule