module life1(input [7:0] x, input in, output out);
    wire [3:0] c;
    assign c = x[0] + x[1] + x[2] + x[3] + x[4] + x[5] + x[6] + x[7];
    assign out = (c == 4'd2) ? in: ((c == 4'd3) ? 1'b1 : 1'b0);
endmodule

module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q ); 
    wire [255:0] x;
    
    genvar i, j;
    generate
        for (i = 0; i < 16; i = i + 1) begin : i_
            for (j = 0; j < 16; j = j + 1) begin : j_
                wire [3:0] a1 = i + 1, a2 = j;
                wire [7:0] a = {a1, a2};
                wire [3:0] b1 = i + 1, b2 = j+1;
                wire [7:0] b = {b1, b2};
                wire [3:0] c1 = i + 1, c2 = j-1;
                wire [7:0] c = {c1, c2};
                
                wire [3:0] d1 = i, d2 = j+1;
                wire [7:0] d = {d1, d2};
                wire [3:0] e1 = i, e2 = j-1;
                wire [7:0] e = {e1, e2};
                wire [3:0] f1 = i - 1, f2 = j + 1;
                wire [7:0] f = {f1, f2};
                wire [3:0] g1 = i - 1, g2 = j;
                wire [7:0] g = {g1, g2};
                wire [3:0] h1 = i - 1, h2 = j - 1;
                wire [7:0] h = {h1, h2};
                
                life1 l({q[a],
                         q[b],
                         q[c],
                         q[d],
                         q[e],
                         q[f],
                         q[g],
                         q[h]},
                        q[(i << 4) | j], x[(i << 4) | j]);
            end
        end
    endgenerate
    always @(posedge clk) begin
        if (load)
            q <= data;
        else begin
            q <= x;
        end
    end
endmodule

module life_tb();
    reg clk;
    reg load;
    wire [255:0] data = 256'h200010007;
    wire [255:0] q;
    top_module dut(clk, load, data, q);
initial begin
    $dumpfile("test.vcd");
    $dumpvars(0,life_tb);

    forever begin
        #5 clk = ~clk;
        $display("%d", $time);
        $display("%b", q[255:240]);
        $display("%b", q[239:224]);
        $display("%b", q[223:208]);
        $display("%b", q[207:192]);
        $display("%b", q[191:176]);
        $display("%b", q[175:160]);
        $display("%b", q[159:144]);
        $display("%b", q[143:128]);
        $display("%b", q[127:112]);
        $display("%b", q[111:96]);
        $display("%b", q[95:80]);
        $display("%b", q[79:64]);
        $display("%b", q[63:48]);
        $display("%b", q[47:32]);
        $display("%b", q[31:16]);
        $display("%b", q[15:0]);
    end
end    

initial begin
    clk = 1'b0;
    load = 1'b1;
    #10
    load = 1'b0;
end

initial begin
    #50 $finish;
end

endmodule
