module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output done
); 
    parameter IDLE=2'd0, START=4'd1, DATA=2'd2,  XXX=2'd3;
        
    reg[1:0] state, next_state;
    reg d, dn;
    reg [8:0] q;
    always @(*) begin
        d = 0;
        case (state)
            IDLE: next_state = in ? IDLE : START;
            START: next_state = DATA;
            DATA:   if (!q[0]) next_state = DATA;
                    else begin
                        if (in) begin
                            next_state = IDLE;
                            d = 1;
                        end
                        else next_state = XXX;
                    end
            XXX: next_state = (in) ? IDLE : XXX;
            default: next_state = 2'bxx;
        endcase
    end

    assign done = dn;

    always@(posedge clk)begin
        if (reset) begin
            state <= IDLE;
            dn <= 0;
            q <= 0;
        end
        else begin
            if (next_state == START) begin
                q <= 9'h100;
            end
            else if (next_state == DATA) begin
                q <= {in, q[8:1]};
            end
            state <= next_state;
            dn <= d;
        end
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
    #11 reset = 1'b0; in = 1'b0;
    #90 in = 1'b1;
    #10 in = 1'b0;
end

initial begin
    #150 $finish;
end

endmodule
