/*
 * Copyright (c) 2026 Luca Colombo
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_mac_n_cheese (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  assign uio_out = 0;
  assign uio_oe  = 0;
  
  // List all unused inputs to prevent warnings
  wire _unused = &{1'b0};

  // Wire declarations for internal logic
  // 32 bits accumulatore to hold the result of the multiplication
  reg [31:0] accumulator = 0, sample_o;
  reg [3:0] counter = 0; // Counter to keep track of the number of multiplications

  always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
      accumulator <= 0;
      sample_o <= 0;
      counter <= 0;
    end else if (ena) begin
      // After 8 multiplications, output the result and reset the accumulator and counter
      if (counter == 7) begin
        sample_o <= (accumulator + (ui_in * uio_in)); // Output the least significant byte of the result
        accumulator <= 0; // Reset the accumulator for the next round of multiplications
        counter <= 0; // Reset the counter
      end else begin
        sample_o <= 0; // Clear the output until we have a valid result
        // Perform multiplication and accumulate the result
        accumulator <= accumulator + (ui_in * uio_in);
        // Increment the counter
        counter <= counter + 1;
      end
    end
  end

  assign uo_out = sample_o[31:24]; // Output the most significant byte of the accumulated result

endmodule
