module crypto_top (
    input clk,
    input reset,
    input [7:0] data_in,
    input [9:0] key,
    output [31:0] final_hash
);
    wire [7:0] enc_data;

    sdes encryptor (.plaintext(data_in), .key(key), .ciphertext(enc_data));
    lfsr_hash hasher (.clk(clk), .reset(reset), .data_in(enc_data), .hash_out(final_hash));
endmodule
