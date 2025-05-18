module lfsr_hash (
    input clk,
    input reset,
    input [7:0] data_in,
    output reg [31:0] hash_out
);
    // LFSR state
    reg [31:0] lfsr;
    
    // Toeplitz matrix (32x8 bits)
    reg [7:0] toeplitz_matrix [0:31];
    
    // OTP mask
    reg [31:0] otp_mask;
    
    // Internal signals
    wire [31:0] toeplitz_hash;
    wire [31:0] lfsr_next;
    
    // Initialize Toeplitz matrix with pseudo-random values
    initial begin
        toeplitz_matrix[0] = 8'hA5; toeplitz_matrix[1] = 8'h3C; toeplitz_matrix[2] = 8'hF7;
        toeplitz_matrix[3] = 8'h92; toeplitz_matrix[4] = 8'h1E; toeplitz_matrix[5] = 8'h4D;
        toeplitz_matrix[6] = 8'h8B; toeplitz_matrix[7] = 8'h6A; toeplitz_matrix[8] = 8'hC3;
        toeplitz_matrix[9] = 8'h5F; toeplitz_matrix[10] = 8'hE8; toeplitz_matrix[11] = 8'hB1;
        toeplitz_matrix[12] = 8'h7D; toeplitz_matrix[13] = 8'h2A; toeplitz_matrix[14] = 8'h9C;
        toeplitz_matrix[15] = 8'h4E; toeplitz_matrix[16] = 8'hF2; toeplitz_matrix[17] = 8'h8D;
        toeplitz_matrix[18] = 8'h6B; toeplitz_matrix[19] = 8'hC4; toeplitz_matrix[20] = 8'h5A;
        toeplitz_matrix[21] = 8'hE9; toeplitz_matrix[22] = 8'hB2; toeplitz_matrix[23] = 8'h7E;
        toeplitz_matrix[24] = 8'h2B; toeplitz_matrix[25] = 8'h9D; toeplitz_matrix[26] = 8'h4F;
        toeplitz_matrix[27] = 8'hF3; toeplitz_matrix[28] = 8'h8E; toeplitz_matrix[29] = 8'h6C;
        toeplitz_matrix[30] = 8'hC5; toeplitz_matrix[31] = 8'h5B;
    end
    
    // LFSR feedback polynomial: x^32 + x^22 + x^2 + x + 1
    assign lfsr_next = {lfsr[30:0], lfsr[31] ^ lfsr[21] ^ lfsr[1] ^ lfsr[0]};
    
    // Toeplitz hashing
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : toeplitz_gen
            assign toeplitz_hash[i] = ^(toeplitz_matrix[i] & data_in);
        end
    endgenerate
    
    // Main process
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr <= {data_in, 24'b0}; // Initialize with data_in
            otp_mask <= 32'hFFFFFFFF; // Initialize OTP mask
            hash_out <= 0;
        end else begin
            // Update LFSR
            lfsr <= lfsr_next;
            
            // Update OTP mask using LFSR output
            otp_mask <= {otp_mask[30:0], otp_mask[31] ^ otp_mask[21] ^ otp_mask[1] ^ otp_mask[0]};
            
            // Combine Toeplitz hash with LFSR output and OTP mask
            hash_out <= (toeplitz_hash ^ lfsr) ^ otp_mask;
        end
    end
endmodule
