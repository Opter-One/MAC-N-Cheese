/*
 * Copyright (c) 2026 Luca Colombo
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none
`include "mac.v"
`include "mac_32.v"

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
  
  assign uio_out = 8'b0; // Unused output, set to 0
  assign uio_oe = 8'b0; // Unused output enable, set
  // List all unused inputs to prevent warnings
  wire _unused = &{uio_in, 1'b0};
  
  // Internal wires and registers
  wire [19:0] out1, out2; // Intermediate outputs from the MAC units
  wire [40:0] sample_o; // Output from the final MAC unit
  wire [7:0] input2 = ui_in;

  mac #(.COUNT(8)) mac_1_paral (
    .clk(clk),
    .rst_n(rst_n),
    .ena(ena),
    .input_1(ui_in),
    .input_2(input2),
    .mac_out(out1)
  );

  mac #(.COUNT(8)) mac_2_paral (
    .clk(clk),
    .rst_n(rst_n),
    .ena(ena),
    .input_1(ui_in),
    .input_2(input2),
    .mac_out(out2)
  );

    mac_32 #(.COUNT(8)) mac_last (
    .clk(clk),
    .rst_n(rst_n),
    .ena(ena),
    .input_1(out1),
    .input_2(out2),
    .mac_out(sample_o)
  );

  assign uo_out = sample_o[40:33]; // Output the most significant byte of the accumulated result

endmodule
