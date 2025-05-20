module crypto_top (
    input clk,
    input reset,
    input [7:0] data_in, // This will be plaintext for encryption, ciphertext for decryption
    input [9:0] key,
    input mode, // 0 for encrypt, 1 for decrypt
    output [7:0] sdes_data_out, // Output of SDES (ciphertext or plaintext)
    output [31:0] final_hash     // Hash of sdes_data_out
);
    // wire [7:0] enc_data; // This is now sdes_data_out

    sdes sdes_unit (
        .data_input(data_in),
        .key(key),
        .mode(mode),
        .data_output(sdes_data_out)
    );
    
    lfsr_hash hasher (
        .clk(clk),
        .reset(reset),
        .data_in(sdes_data_out), // Hash the output of SDES
        .hash_out(final_hash)
    );
endmodule
