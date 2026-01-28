module controllar (
    input wire clka,        
    input wire rst,
    input wire [31:0] douta,
    input wire start_stop,
    output reg [3:0] addra,
    output reg ena,
    output reg [15:0] a, b         
);

    always @(posedge clka) begin
        if (rst == 1'b1) begin      
            addra <= 4'b0000;
            ena   <= 1'b0;
            a     <= 16'b0;
            b     <= 16'b0;
        end 
        else begin                  
            if (start_stop == 1'b1) begin
                ena   <= 1'b1;
                addra <= addra + 1;
                a     <= douta[15:0];
                b     <= douta[31:16];
            end 
            else begin
                ena   <= 1'b0;
                addra <= addra;     
                a     <= a;
                b     <= b;
            end
        end
    end 

endmodule