// Hacked to support Ethernet
module crc8e_guts(
	input clk,
	input gate,
	input first,  // set this during the first clock cycle of a new block of data
	input [7:0] d_in,
	output [7:0] d_out,
	output zero
);
// http://en.wikipedia.org/wiki/Cyclic_redundancy_check
parameter wid=32;
parameter init=32'hffffffff;

// Three names are magic to crc_guts.vh:
//   D    data in
//   O    old CRC value
//   crc  new CRC value
reg [wid-1:0] crc=0;
wire [7:0] D = d_in;
wire [wid-1:0] O = first ? init : crc;
always @(posedge clk) if (gate) begin
// Machine generated by ./crc_derive -lsb 32 0x4c11db7 8
// D is the 8-bit input data (lsb-first)
// crc and O are the new and old 32-bit CRC
// Generating polynomial is 0x4c11db7 (normal form, leading 1 suppressed)
// Reference: https://en.wikipedia.org/wiki/Cyclic_redundancy_check
crc[0] <= D[7]^D[1]^O[24]^O[30];
crc[1] <= D[7]^D[6]^D[1]^D[0]^O[24]^O[25]^O[30]^O[31];
crc[2] <= D[7]^D[6]^D[5]^D[1]^D[0]^O[24]^O[25]^O[26]^O[30]^O[31];
crc[3] <= D[6]^D[5]^D[4]^D[0]^O[25]^O[26]^O[27]^O[31];
crc[4] <= D[7]^D[5]^D[4]^D[3]^D[1]^O[24]^O[26]^O[27]^O[28]^O[30];
crc[5] <= D[7]^D[6]^D[4]^D[3]^D[2]^D[1]^D[0]^O[24]^O[25]^O[27]^O[28]^O[29]^O[30]^O[31];
crc[6] <= D[6]^D[5]^D[3]^D[2]^D[1]^D[0]^O[25]^O[26]^O[28]^O[29]^O[30]^O[31];
crc[7] <= D[7]^D[5]^D[4]^D[2]^D[0]^O[24]^O[26]^O[27]^O[29]^O[31];
crc[8] <= D[7]^O[0]^D[6]^D[4]^D[3]^O[24]^O[25]^O[27]^O[28];
crc[9] <= D[6]^O[1]^D[5]^D[3]^D[2]^O[25]^O[26]^O[28]^O[29];
crc[10] <= D[7]^D[5]^O[2]^D[4]^D[2]^O[24]^O[26]^O[27]^O[29];
crc[11] <= D[7]^D[6]^D[4]^O[3]^D[3]^O[24]^O[25]^O[27]^O[28];
crc[12] <= D[7]^D[6]^D[5]^D[3]^O[4]^D[2]^D[1]^O[24]^O[25]^O[26]^O[28]^O[29]^O[30];
crc[13] <= D[6]^D[5]^D[4]^D[2]^O[5]^D[1]^D[0]^O[25]^O[26]^O[27]^O[29]^O[30]^O[31];
crc[14] <= D[5]^D[4]^D[3]^D[1]^O[6]^D[0]^O[26]^O[27]^O[28]^O[30]^O[31];
crc[15] <= D[4]^D[3]^D[2]^D[0]^O[7]^O[27]^O[28]^O[29]^O[31];
crc[16] <= D[7]^D[3]^D[2]^O[8]^O[24]^O[28]^O[29];
crc[17] <= D[6]^D[2]^D[1]^O[9]^O[25]^O[29]^O[30];
crc[18] <= D[5]^D[1]^D[0]^O[10]^O[26]^O[30]^O[31];
crc[19] <= D[4]^D[0]^O[11]^O[27]^O[31];
crc[20] <= D[3]^O[12]^O[28];
crc[21] <= D[2]^O[13]^O[29];
crc[22] <= D[7]^O[14]^O[24];
crc[23] <= D[7]^D[6]^D[1]^O[15]^O[24]^O[25]^O[30];
crc[24] <= D[6]^D[5]^D[0]^O[16]^O[25]^O[26]^O[31];
crc[25] <= D[5]^D[4]^O[17]^O[26]^O[27];
crc[26] <= D[7]^D[4]^D[3]^D[1]^O[18]^O[24]^O[27]^O[28]^O[30];
crc[27] <= D[6]^D[3]^D[2]^D[0]^O[19]^O[25]^O[28]^O[29]^O[31];
crc[28] <= D[5]^D[2]^D[1]^O[20]^O[26]^O[29]^O[30];
crc[29] <= D[4]^D[1]^D[0]^O[21]^O[27]^O[30]^O[31];
crc[30] <= D[3]^D[0]^O[22]^O[28]^O[31];
crc[31] <= D[2]^O[23]^O[29];
end
wire [7:0] dr = ~crc[wid-1:wid-8]; // note polarity inversion
assign d_out = {dr[0],dr[1],dr[2],dr[3],dr[4],dr[5],dr[6],dr[7]};
// note bit order reversal

// assign zero = ~(|crc);
assign zero = crc==32'hc704dd7b;
endmodule
