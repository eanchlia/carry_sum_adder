module testbench();

reg [63:0] a,b;
reg addsum,clock, start, reset;
wire [63:0] sum;
wire cout, overflow;

csa_64bit t2 (a, b, addsum, clock, overflow, start, reset, sum, cout );
//Clock
initial clock = 0;
always #5 clock = ~ clock;

initial
begin
    reset = 0;
    addsum = 0;
    start = 0;
    a[63:0] = 64'h0000_0000_0000_0000; 
    b[63:0] = 64'h0000_0000_0000_0000; 
    #10 start = 1;
    #5 start = 0;
    #20 $display("A : %h, B : %h, sum : %h, cout : %d , overflow : %b ",a[63:0],b[63:0], sum[63:0],cout, overflow);
    
    a[63:0] = 64'hffff_ffff_ffff_ffff; 
    b[63:0] = 64'h0000_0000_0000_0001; // Overflow = 1
    #10 start = 1;
    #5 start = 0;
    #20 $display("A : %h, B : %h, sum : %h, cout : %d , overflow : %b ",a[63:0],b[63:0], sum[63:0],cout, overflow);
    
    reset = 1;
    #10 reset = 0;
    #20 $display("A : %h, B : %h, sum : %h, cout : %d , overflow : %b ",a[63:0],b[63:0], sum[63:0],cout, overflow);
    
    addsum = 1;
    a[63:0] = 64'hffff_ffff_ffff_ffff; 
    b[63:0] = 64'h0000_0000_0000_0001; 
    #10 start = 1;
    #5 start = 0;
    #20 $display("A : %h, B : %h, sum : %h, cout : %d , overflow : %b ",a[63:0],b[63:0], sum[63:0],cout, overflow);

    reset = 1;
    #10 reset = 0;
    #10 start = 1;
    #5 start = 0;
    addsum = 0;
    a[63:0] = 64'h0000_aaaa_bbbb_ffff; 
    b[63:0] = 64'h0000_1000_1234_1001; 
    #20 $display("A : %h, B : %h, sum : %h, cout : %d , overflow : %b ",a[63:0],b[63:0], sum[63:0],cout, overflow);
    
     
     addsum = 1;
     a= 64'h1111_2222_3333_4444;
     b[63:0]=64'h0000_0000_0000_0001; ; //43
    #10
    start = 1;
    #5 start = 0;
    #20 $display("A : %d, B : %d, sum : %d, cout : %d , overflow : %b ",a[63:0],b[63:0], sum[63:0],cout, overflow);
     #100
     $finish ();
end


 endmodule

