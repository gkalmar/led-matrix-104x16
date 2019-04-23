`timescale 1ns / 1ps

`define MAX_COL_IDX 4'd12

module LedMatrix
(
  input  clk,
  input  cs,
  input  sclk,
  input  mosi,
  output [103:0] columns,
  output [15:0] rows
);
/*
Pixels information is stored in bytes. The following order is applied:
  column 0, row 0 --->|7|6|5|4|3|2|1|0| |7|6|5|4|3|2|1|0|<--- column 1, row 0 : |7|6|5|4|3|2|1|0|<-- column 12, row 0
  column 0, row 1 --->|7|6|5|4|3|2|1|0| |7|6|5|4|3|2|1|0|<--- column 1, row 1 : |7|6|5|4|3|2|1|0|<-- column 12, row 1
  column 0, row 2 --->|7|6|5|4|3|2|1|0| |7|6|5|4|3|2|1|0|<--- column 1, row 2 : |7|6|5|4|3|2|1|0|<-- column 12, row 2
  ...................................................................................................................
  column 0, row 15 -->|7|6|5|4|3|2|1|0| |7|6|5|4|3|2|1|0|<-- column 1, row 15 : |7|6|5|4|3|2|1|0|<-- column 12, row 15
*/
reg  [103:0]  pixels [0:15];
reg  [15:0]   spi_shift_register    = 16'd0;
reg  [12:0]   scan_rate_counter     = 13'd0;
reg  [7:0]    intensity             = 8'd0;
reg  [7:0]    column_idx            = 8'd0;
wire [3:0]    active_row            = scan_rate_counter[12:9];
wire [7:0]    pwm_counter           = scan_rate_counter[9:2];
wire [7:0]    address               = spi_shift_register[15:8];
wire [7:0]    data                  = spi_shift_register[7:0];
wire [3:0]    row_idx               = address[3:0];
wire [3:0]    column_byte_idx       = address[7:4];


// Reading the mosi line and store the data
always@(posedge sclk) begin
  if(!cs)
    spi_shift_register = spi_shift_register << 1;
    spi_shift_register[0] = mosi;
end
  
// Process input data frame
always@(posedge cs) begin
  if(address == 8'hff) begin
    intensity = data;
  end
  else if( column_byte_idx <= `MAX_COL_IDX ) begin
    column_idx = 8'd0;
    column_idx[6:3] = column_byte_idx;
    column_idx = 8'd103 - column_idx;
    pixels[row_idx][column_idx -: 8] = data;
  end
end

// Create scan rate
always@(posedge clk) begin
  scan_rate_counter <= scan_rate_counter + 13'd1;
end

// Update columns
assign columns = ( pwm_counter <= intensity ) ? ~(pixels[active_row]) : ~(104'd0);

// Update rows
assign rows = ~( 16'b0000000000000001 << active_row );


initial begin
  pixels[0] = 103'd0;
  pixels[1] = 103'd0;
  pixels[2] = 103'd0;
  pixels[3] = 103'd0;
  pixels[4] = 103'd0;
  pixels[5] = 103'd0;
  pixels[6] = 103'd0;
  pixels[7] = 103'd0;
  pixels[8] = 103'd0;
  pixels[9] = 103'd0;
  pixels[10] = 103'd0;
  pixels[11] = 103'd0;
  pixels[12] = 103'd0;
  pixels[13] = 103'd0;
  pixels[14] = 103'd0;
  pixels[15] = 103'd0;
end
endmodule


module LedMatrix_Test;
reg          clk;
reg          cs;
reg          sclk;
reg          mosi;
wire [103:0] columns;
wire [15:0]  rows;

// Create clock with 5.3MHz
always #90.909 clk = ~clk;
//always #50    sclk = ~sclk;
parameter clk_period = 181.818;
parameter sclk_half_period = 50;

LedMatrix DUT (.clk(clk), .cs(cs), .sclk(sclk), .mosi(mosi), .columns(columns), .rows(rows));

initial begin
    clk  = 1'b0;
    cs   = 1'b1;
    sclk = 1'b0;
    mosi = 1'b0;
    #(clk_period)
    #(clk_period)
    cs = 1'b0; // Simulate a cs glitch
    #(clk_period)
    #(clk_period)
    cs = 1'b1;
    #(clk_period)
    #(clk_period)
    // Set intensity = 255
    cs = 1'b0;
    #20
    mosi = 1'b1;
    #20
    sclk = 1'b1; // Bit 15
    #(sclk_half_period)
    sclk = 1'b0;
    #(sclk_half_period)
    sclk = 1'b1; // Bit 14
    #(sclk_half_period)
    sclk = 1'b0;
    #(sclk_half_period)
    sclk = 1'b1; // Bit 13
    #(sclk_half_period)
    sclk = 1'b0;
    #(sclk_half_period)
    sclk = 1'b1; // Bit 12
    #(sclk_half_period)
    sclk = 1'b0;
    #(sclk_half_period)
    sclk = 1'b1; // Bit 11
    #(sclk_half_period)
    sclk = 1'b0;
    #(sclk_half_period)
    sclk = 1'b1; // Bit 10
    #(sclk_half_period)
    sclk = 1'b0;
    #(sclk_half_period)
    sclk = 1'b1; // Bit 9
    #(sclk_half_period)
    sclk = 1'b0;
    #(sclk_half_period)
    sclk = 1'b1; // Bit 8
    #(sclk_half_period)
    sclk = 1'b0;
    #(sclk_half_period)
    sclk = 1'b1; // Bit 7
    #(sclk_half_period)
    sclk = 1'b0;
    #(sclk_half_period)
    sclk = 1'b1; // Bit 6
    #(sclk_half_period)
    sclk = 1'b0;
    #(sclk_half_period)
    sclk = 1'b1; // Bit 5
    #(sclk_half_period)
    sclk = 1'b0;
    #(sclk_half_period)
    sclk = 1'b1; // Bit 4
    #(sclk_half_period)
    sclk = 1'b0;
    #(sclk_half_period)
    sclk = 1'b1; // Bit 3
    #(sclk_half_period)
    sclk = 1'b0;
    #(sclk_half_period)
    sclk = 1'b1; // Bit 2
    #(sclk_half_period)
    sclk = 1'b0;
    #(sclk_half_period)
    sclk = 1'b1; // Bit 1
    #(sclk_half_period)
    sclk = 1'b0;
    #(sclk_half_period)
    sclk = 1'b1; // Bit 0
    #(sclk_half_period)
    sclk = 1'b0;
    #20
    mosi = 1'b0;
    cs   = 1'b1;

    #(clk_period)
    #(clk_period)

    // Turn on the pixel at x=0, y=0
    cs = 1'b0;
    #20
    mosi = 1'b0;
    #20
    sclk = 1'b1; // Bit 15
    #(sclk_half_period)
    sclk = 1'b0;
    #(sclk_half_period)
    sclk = 1'b1; // Bit 14
    #(sclk_half_period)
    sclk = 1'b0;
    #(sclk_half_period)
    sclk = 1'b1; // Bit 13
    #(sclk_half_period)
    sclk = 1'b0;
    #(sclk_half_period)
    sclk = 1'b1; // Bit 12
    #(sclk_half_period)
    sclk = 1'b0;
    #(sclk_half_period)
    sclk = 1'b1; // Bit 11
    #(sclk_half_period)
    sclk = 1'b0;
    #(sclk_half_period)
    sclk = 1'b1; // Bit 10
    #(sclk_half_period)
    sclk = 1'b0;
    #(sclk_half_period)
    sclk = 1'b1; // Bit 9
    #(sclk_half_period)
    sclk = 1'b0;
    #(sclk_half_period)
    sclk = 1'b1; // Bit 8
    #(sclk_half_period)
    sclk = 1'b0;
    #25
    mosi = 1'b1;
    #25
    sclk = 1'b1; // Bit 7
    #(sclk_half_period)
    sclk = 1'b0;
    mosi = 1'b0;
    #(sclk_half_period)
    sclk = 1'b1; // Bit 6
    #(sclk_half_period)
    sclk = 1'b0;
    #(sclk_half_period)
    sclk = 1'b1; // Bit 5
    #(sclk_half_period)
    sclk = 1'b0;
    #(sclk_half_period)
    sclk = 1'b1; // Bit 4
    #(sclk_half_period)
    sclk = 1'b0;
    #(sclk_half_period)
    sclk = 1'b1; // Bit 3
    #(sclk_half_period)
    sclk = 1'b0;
    #(sclk_half_period)
    sclk = 1'b1; // Bit 2
    #(sclk_half_period)
    sclk = 1'b0;
    #(sclk_half_period)
    sclk = 1'b1; // Bit 1
    #(sclk_half_period)
    sclk = 1'b0;
    #(sclk_half_period)
    sclk = 1'b1; // Bit 0
    #(sclk_half_period)
    sclk = 1'b0;
    #20
    mosi = 1'b0;
    cs   = 1'b1;

    #10000000;
end

endmodule