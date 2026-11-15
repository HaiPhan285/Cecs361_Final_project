`timescale 1ns/1ps

module sha256_tb;

    reg clk;
    reg reset;
    reg capture_enable;
    reg [7:0] ascii;

    wire [3:0] upper_hexa_converter;
    wire [3:0] lower_hexa_converter;
    wire [7:0] captured_byte;
    wire [511:0] padded_block;

    sha256 uut (
        .reset(reset),
        .clk(clk),
        .capture_enable(capture_enable),
        .ascii(ascii),
        .upper_hexa_converter(upper_hexa_converter),
        .lower_hexa_converter(lower_hexa_converter),
        .captured_byte(captured_byte),
        .padded_block(padded_block)
    );

    always #5 clk = ~clk;

    localparam STRING_LENGTH = 14;

    integer i;
    reg [8*STRING_LENGTH-1:0] test_string;

    initial begin
        clk = 1'b0;
        reset = 1'b1;
        capture_enable = 1'b0;
        ascii = 8'h00;
        test_string = "hai phan thanh";

        @(negedge clk);
        reset = 1'b0;
        capture_enable = 1'b1;

        $write("Input bytes: ");

        for (i = 0; i < STRING_LENGTH; i = i + 1) begin
            ascii = test_string[8*(STRING_LENGTH-i)-1 -: 8];

            @(posedge clk);
            #1;
            $write("%02h ", captured_byte);

            @(negedge clk);
        end

        capture_enable = 1'b0;

        $display("");
        $display("Padded block:");

        for (i = 0; i < 64; i = i + 1) begin
            $write("%02h ", padded_block[511 - (i * 8) -: 8]);

            // Print eight bytes per line.
            if ((i % 8) == 7)
                $display("");
        end

        #10 $finish;
    end

endmodule