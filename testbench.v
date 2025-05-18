`timescale 1ns/1ps

module crypto_tb;
    // Test signals
    reg clk;
    reg reset;
    reg [7:0] data_in;
    reg [9:0] key;
    wire [31:0] final_hash;
    
    // Instantiate the top module
    crypto_top dut (
        .clk(clk),
        .reset(reset),
        .data_in(data_in),
        .key(key),
        .final_hash(final_hash)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clock
    end
    
    // Test stimulus
    initial begin
        // Initialize
        reset = 1;
        data_in = 8'h00;
        key = 10'h000;
        #20;
        
        // Release reset
        reset = 0;
        #20;
        
        // Test case 1: All zeros
        data_in = 8'h00;
        key = 10'h000;
        #100;
        
        // Test case 2: All ones
        data_in = 8'hFF;
        key = 10'h3FF;
        #100;
        
        // Test case 3: Alternating bits
        data_in = 8'hAA;
        key = 10'h155;
        #100;
        
        // Test case 4: Random pattern
        data_in = 8'h5A;
        key = 10'h2A5;
        #100;
        
        // Test case 5: Another random pattern
        data_in = 8'hC3;
        key = 10'h3C3;
        #100;
        
        // End simulation
        #100;
        $finish;
    end
    
    // Monitor results
    initial begin
        $monitor("Time=%t data_in=%h key=%h final_hash=%h",
                 $time, data_in, key, final_hash);
    end
    
    // Generate waveform
    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, crypto_tb);
    end
endmodule
