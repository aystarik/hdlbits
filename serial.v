module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output reg done
); 
	parameter IDLE = 2'd0, START = 2'b1, DATA = 2'd2, STOP = 2'd3;
    reg [1:0] s, ns;
    reg [9:0] d;
    always @(posedge clk) begin
        done = 1'b0;
        if (reset) begin
            s <= IDLE;
            d <= 9'b0;
        end
        else begin
            s <= ns;
            if (s == IDLE)
                d <= 9'd1;
            else if (s == DATA) begin
                d <= {d[7:0], in};
            end
            if (s == STOP) begin
                done <= 1'b1;
            end
        end
    end
    always @(*) begin
        case (s)
            IDLE, STOP: ns = ~in ? DATA: IDLE; 
            DATA: ns = d[8] ? (in ? STOP: IDLE):DATA;
        endcase
    end
endmodule

module serial_tb();
    reg clk;
    reg in;
    reg reset;
    wire done;


    top_module dut(clk, in, reset, done);
initial begin
    $dumpfile("serial.vcd");
    $dumpvars(0, serial_tb);

    forever begin
        #5 clk = ~clk;
    end
end    

initial begin
    clk = 1'b1;
    in = 1'b1;
    reset = 1'b1;
    #10 reset = 1'b0; in = 1'b0;
    #90 in = 1'b1;
    #10 in = 1'b0;
end

initial begin
    #150 $finish;
end

endmodule
