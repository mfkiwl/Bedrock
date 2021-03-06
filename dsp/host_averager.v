/* Host-side signal averager

This module accepts (nominally) periodic measurements,
and accumulates them.  It also keeps count, and makes both results
accessible to a host, so the host can divide and find an average.
This process is resilient to timing (polling) jitter on the host side.

The whole trick is that a read is "destructive", in that it clears
the accumulators.  The host can read at "any" interval it wants,
and always gets a valid reading.

If your host / bus infrastructure can only perform passive reads, I hope
it can at least order operations; then the snapshot function can be
triggered by a write, with the actual read following.

This version is all static-sized -- emphasizing clarity over generality.
The host has to read at least once for every 255 readings that come in,
in order to avoid overflows.  That condition is easily checked: the
sample counter saturates at 255, so that value flags the reading as invalid.

Input (data_in) is unsigned, as my use case takes in (non-negative)
values representing power.
Output word (data_out) is { 24-bits data, 8-bits count }.
Output appears the cycle after a single-cycle read_s strobe, and remains
static until the next such strobe.  The claim is this is fast enough
to generate an atomic-read-and-clear in the usual LBNL local bus structure,
using the same cycle usually used to cycle block RAM.

By necessity, the output and this logic are both in the _host_ clock domain.
The instantiating module will typically have to move a DSP-clocked result
into this domain before providing it as input to this module.

*/
module host_averager(
	input clk,
	input [23:0] data_in,
	input data_s,
	input read_s,
	output [31:0] data_out
);

reg [31:0] accum=0;
reg [7:0] count=0;
reg [31:0] data_out_r=0;

always @(posedge clk) begin
	if (read_s) data_out_r <= {accum[31:8], count};
	if (data_s | read_s) begin
		count <= (read_s ? 8'd0 : count) + data_s;
		accum <= (read_s ? 32'd0 : accum) + (data_s ? data_in : 24'b0);
	end
	if (data_s & ~read_s & (&count)) count <= 8'hff;
end
assign data_out = data_out_r;

endmodule
