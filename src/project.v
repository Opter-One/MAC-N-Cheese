/*
 * Copyright (c) 2026 Luca Colombo
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none
`include "mac.v"

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
  wire [31:0] sample_o;

  mac #(.COUNT(8)) mac_inst (
    .clk(clk),
    .rst_n(rst_n),
    .ena(ena),
    .input_1(ui_in),
    .input_2(uio_in),
    .mac_out(sample_o)
  );

  assign uo_out = sample_o[31:24]; // Output the most significant byte of the accumulated result

endmodule
