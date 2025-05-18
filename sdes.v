module sdes (
    input [7:0] plaintext,
    input [9:0] key,
    output [7:0] ciphertext
);
    // Internal signals
    wire [7:0] ip_out;
    wire [7:0] round1_out;
    wire [7:0] round2_out;
    wire [7:0] ip_inv_out;
    
    // Key generation signals
    wire [7:0] k1, k2;
    
    // Initial Permutation (IP)
    assign ip_out = {plaintext[1], plaintext[5], plaintext[2], plaintext[0],
                    plaintext[3], plaintext[7], plaintext[4], plaintext[6]};
    
    // Key Generation
    key_generator key_gen (
        .key(key),
        .k1(k1),
        .k2(k2)
    );
    
    // Round 1
    feistel_round round1 (
        .data_in(ip_out),
        .subkey(k1),
        .data_out(round1_out)
    );
    
    // Round 2 (with swap)
    feistel_round round2 (
        .data_in({round1_out[3:0], round1_out[7:4]}),
        .subkey(k2),
        .data_out(round2_out)
    );
    
    // Final Permutation (IP-1)
    assign ip_inv_out = {round2_out[3], round2_out[0], round2_out[2],
                        round2_out[4], round2_out[6], round2_out[1],
                        round2_out[7], round2_out[5]};
    
    assign ciphertext = ip_inv_out;
endmodule

// Key Generator Module
module key_generator(
    input [9:0] key,
    output [7:0] k1,
    output [7:0] k2
);
    wire [9:0] p10_out;
    wire [9:0] ls1_out;
    wire [9:0] ls2_out;
    
    // P10 Permutation
    assign p10_out = {key[2], key[4], key[1], key[6], key[3],
                     key[9], key[0], key[8], key[7], key[5]};
    
    // Left Shift 1
    assign ls1_out = {p10_out[8:0], p10_out[9]};
    
    // Left Shift 2
    assign ls2_out = {ls1_out[8:0], ls1_out[9]};
    
    // P8 Permutation for K1
    assign k1 = {ls1_out[5], ls1_out[2], ls1_out[6], ls1_out[3],
                ls1_out[7], ls1_out[4], ls1_out[9], ls1_out[8]};
    
    // P8 Permutation for K2
    assign k2 = {ls2_out[5], ls2_out[2], ls2_out[6], ls2_out[3],
                ls2_out[7], ls2_out[4], ls2_out[9], ls2_out[8]};
endmodule

// Feistel Round Module
module feistel_round(
    input [7:0] data_in,
    input [7:0] subkey,
    output [7:0] data_out
);
    wire [3:0] left_in, right_in;
    wire [3:0] left_out, right_out;
    wire [3:0] f_out;
    
    // Split input
    assign left_in = data_in[7:4];
    assign right_in = data_in[3:0];
    
    // F function
    f_function f_func (
        .right(right_in),
        .subkey(subkey),
        .f_out(f_out)
    );
    
    // XOR and swap
    assign right_out = left_in ^ f_out;
    assign left_out = right_in;
    
    // Combine outputs
    assign data_out = {left_out, right_out};
endmodule

// F Function Module
module f_function(
    input [3:0] right,
    input [7:0] subkey,
    output [3:0] f_out
);
    wire [7:0] expanded;
    wire [7:0] xored;
    wire [3:0] sbox_out;
    
    // Expansion/Permutation
    assign expanded = {right[3], right[0], right[1], right[2],
                      right[1], right[2], right[3], right[0]};
    
    // XOR with subkey
    assign xored = expanded ^ subkey;
    
    // S-boxes
    wire [1:0] s1_out, s2_out;
    
    // S-box 1
    sbox1 s1 (
        .in(xored[7:4]),
        .out(s1_out)
    );
    
    // S-box 2
    sbox2 s2 (
        .in(xored[3:0]),
        .out(s2_out)
    );
    
    // P4 Permutation
    assign f_out = {s1_out[1], s2_out[1], s2_out[0], s1_out[0]};
endmodule

// S-box 1
module sbox1(
    input [3:0] in,
    output [1:0] out
);
    reg [1:0] sbox [0:15];
    
    initial begin
        sbox[0] = 2'b01; sbox[1] = 2'b00; sbox[2] = 2'b11; sbox[3] = 2'b10;
        sbox[4] = 2'b11; sbox[5] = 2'b10; sbox[6] = 2'b01; sbox[7] = 2'b00;
        sbox[8] = 2'b00; sbox[9] = 2'b10; sbox[10] = 2'b01; sbox[11] = 2'b11;
        sbox[12] = 2'b11; sbox[13] = 2'b01; sbox[14] = 2'b11; sbox[15] = 2'b10;
    end
    
    assign out = sbox[in];
endmodule

// S-box 2
module sbox2(
    input [3:0] in,
    output [1:0] out
);
    reg [1:0] sbox [0:15];
    
    initial begin
        sbox[0] = 2'b00; sbox[1] = 2'b01; sbox[2] = 2'b10; sbox[3] = 2'b11;
        sbox[4] = 2'b10; sbox[5] = 2'b00; sbox[6] = 2'b01; sbox[7] = 2'b11;
        sbox[8] = 2'b11; sbox[9] = 2'b00; sbox[10] = 2'b01; sbox[11] = 2'b00;
        sbox[12] = 2'b10; sbox[13] = 2'b01; sbox[14] = 2'b00; sbox[15] = 2'b11;
    end
    
    assign out = sbox[in];
endmodule
