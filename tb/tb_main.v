`timescale 1ns / 1ps

module tb_main;

    // 1. Inputs (Drivers)
    reg signed [15:0] A;
    reg signed [15:0] B;

    // 2. Output (Result)
    wire signed [31:0] PRODUCT;

    // 3. Instantiate the Multiplier
    main uut (
        .A(A),
        .B(B),
        .PRODUCT(PRODUCT)
    );

    // 4. Drive the Signals
    initial begin
        // Initialize
        A = 0; B = 0;
        
        // Wait for Global Reset (GSR) - Standard for Post-Synthesis Sim
        #100; 

        // Case 1: Positive * Positive
        A = 15; B = 15;
        #100; // Increased to 100ns to allow for gate delays

        // Case 2: Positive * Negative
        A = 5; B = -4;
        #100;

        // Case 3: Negative * Negative
        A = -10; B = -10;
        #100;

        // Case 4: Zero Multiplication
        A = 12345; B = 0;
        #100;

        // Case 5: Max Values
        A = 16'h7FFF; B = 16'h7FFF; 
        #100;

        // Case 6: Random Inputs (Loop)
        repeat (10) begin
            A = $random;
            B = $random;
            #100;
        end

        $finish;
    end

endmodule