/*
 * Copyright (c) 2026 Luca Colombo
 * SPDX-License-Identifier: Apache-2.0
 */

// The final MAC using 32 bits
 module mac_32#(parameter COUNT = 4) (
    input wire clk,          // Clock signal
    input wire rst_n,        // Active low reset signal
    input wire ena,          // Enable signal (active high)
    input wire [19:0] input_1,  // 8-bit input from dedicated input
    input wire [19:0] input_2, // 8-bit input from IO input
    output wire [40:0] mac_out  // 8-bit output to dedicated output
 );
    // Wire declarations for internal logic
    // 32 bits accumulatore to hold the result of the multiplication
    reg [40:0] accumulator, out;
    reg [3:0] counter; // Counter to keep track of the number of multiplications

    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
        accumulator <= 0;
        out <= 0;
        counter <= 0;
        end else if (ena) begin
        // After 8 multiplications, output the result and reset the accumulator and counter
        if (counter == COUNT-1) begin
            out <= (accumulator + (input_1 * input_2)); // Output the least significant byte of the result
            accumulator <= 0; // Reset the accumulator for the next round of multiplications
            counter <= 0; // Reset the counter
        end else begin
            out <= 0; // Clear the output until we have a valid result
            // Perform multiplication and accumulate the result
            accumulator <= accumulator + (input_1 * input_2);
            // Increment the counter
            counter <= counter + 1;
        end
        end
    end

    assign mac_out = out; // Output the accumulated result

 endmodule