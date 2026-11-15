`timescale 1ns/1ps

/*
* Implement to the SHA-256 algorithm in Verilog
* source:  
    https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.180-4.pdf

*/


module sha256(
    input wire reset,
    input wire clk,
    input  wire capture_enable,
    input wire [7:0] ascii,
    output wire [3:0] upper_hexa_converter,
    output wire [3:0] lower_hexa_converter,
    output reg  [7:0] captured_byte,
    output reg [511:0] padded_block
    input a,
    output b
);
    /*
    * ideas: we can converter the ascii to hex.
    * first four bits: 0000
    * last four bits: 0000
    * then we combine two to get the final hash outputs.
    */
    reg [6:0] byte_count;
    reg [31:0] H0, H1, H2, H3, H4, H5, H6, H7;
    assign upper_hexa_converter = captured_byte[7:4];
    assign lower_hexa_converter = captured_byte[3:0];
    always @(posedge clk) begin
        if (reset) begin
            captured_byte <= 8'd0;
        end 
        if(capture_enable) begin 
            captured_byte <= ascii;
        end 
        
    end
   
    //padding and hashing logic
    always @(posedge clk) begin
        if (reset) begin
            // Reset logic for padding and hashing
            byte_count <= 7'd0;
            padded_block <= {8'h80, 504'd0};
            H0 <= 32'h6a09e667;
            H1 <= 32'hbb67ae85;
            H2 <= 32'h3c6ef372;
            H3 <= 32'ha54ff53a;
            H4 <= 32'h510e527f;
            H5 <= 32'h9b05688c;
            H6 <= 32'h1f83d9ab;
            H7 <= 32'h5be0cd19;

        end else if (capture_enable) begin
            // Padding and hashing logic here
            padded_block[511 - (byte_count * 8) -: 8] <= ascii;
            padded_block[503 - (byte_count * 8) -: 8] <= 8'h80;
            padded_block[63:0] <= (64'd1 + byte_count) * 64'd8;
            byte_count <= byte_count + 7'd1;
        end
        
    end
    
endmodule
