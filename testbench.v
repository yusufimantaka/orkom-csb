`timescale 1ns/1ps

module crypto_tb;
    // Test signals
    reg clk;
    reg reset;
    reg [7:0] data_in;
    reg [9:0] key;
    reg mode; // 0 for encrypt, 1 for decrypt
    wire [7:0] sdes_data_out; // Output of SDES module
    wire [31:0] final_hash;
    
    // Instantiate the top module
    crypto_top dut (
        .clk(clk),
        .reset(reset),
        .data_in(data_in),
        .key(key),
        .mode(mode),
        .sdes_data_out(sdes_data_out),
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
        mode = 1'b0; // Start with encryption mode
        #20;
        
        // Release reset
        reset = 0;
        #20;
        
        // --- Test Case 1: Encrypt and Decrypt --- 
        $display("Test Case 1: Encrypt then Decrypt");
        // Encryption
        mode = 1'b0; // Set to encrypt mode
        data_in = 8'hA9; // Example plaintext
        key = 10'h1A5;   // Example key
        #20; // Wait for encryption to complete
        $display("Time=%t Encrypting: data_in=%h, key=%h, mode=%b -> sdes_data_out (ciphertext)=%h", 
                 $time, data_in, key, mode, sdes_data_out);
        
        // Decryption
        mode = 1'b1;    // Set to decrypt mode
        data_in = sdes_data_out; // Feed ciphertext back as input
        // Key remains the same
        #20; // Wait for decryption to complete
        $display("Time=%t Decrypting: data_in (ciphertext)=%h, key=%h, mode=%b -> sdes_data_out (plaintext)=%h", 
                 $time, data_in, key, mode, sdes_data_out);
        
        if (sdes_data_out === 8'hA9) begin
            $display("Test Case 1 PASSED: Decrypted data matches original plaintext.");
        end else begin
            $display("Test Case 1 FAILED: Decrypted data %h, Original plaintext %h", sdes_data_out, 8'hA9);
        end
        #80;

        // --- Test Case 2: All zeros --- 
        $display("Test Case 2: All Zeros (Encryption)");
        mode = 1'b0;
        data_in = 8'h00;
        key = 10'h000;
        #100;
        
        // --- Test Case 3: All ones --- 
        $display("Test Case 3: All Ones (Encryption)");
        mode = 1'b0;
        data_in = 8'hFF;
        key = 10'h3FF;
        #100;
        
        // --- Test Case 4: Alternating bits --- 
        $display("Test Case 4: Alternating Bits (Encryption)");
        mode = 1'b0;
        data_in = 8'hAA;
        key = 10'h155;
        #100;
        
        // --- Test Case 5: Random pattern --- 
        $display("Test Case 5: Random Pattern (Encryption)");
        mode = 1'b0;
        data_in = 8'h5A;
        key = 10'h2A5;
        #100;
        
        // --- Test Case 6: Another random pattern --- 
        $display("Test Case 6: Another Random Pattern (Encryption)");
        mode = 1'b0;
        data_in = 8'hC3;
        key = 10'h3C3;
        #100;
        
        // End simulation
        #100;
        $finish;
    end
    
    // Monitor results
    initial begin
        $monitor("Time=%t mode=%b data_in=%h key=%h sdes_data_out=%h final_hash=%h",
                 $time, mode, data_in, key, sdes_data_out, final_hash);
    end
    
    // Generate waveform
    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, crypto_tb);
    end
endmodule
