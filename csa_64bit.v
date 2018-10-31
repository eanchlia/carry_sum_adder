module half_adder (a,b, sum_ha, cout_ha);
  input a,b;
  output sum_ha, cout_ha;
  assign sum_ha = a^b;
  assign cout_ha = a&b;
endmodule

module full_adder (a, b,sum_fa, cout_fa, cin);
  input a,b, cin;
  output sum_fa, cout_fa;
  assign sum_fa = a^b^cin;
  assign cout_fa = (a&b)| ((a^b)&cin);
endmodule

module ripple_adder_no_cin (a, b, sum_rca_nc, cout_rca_nc);
  input [7:0] a,b;
  output [7:0] sum_rca_nc;
  output cout_rca_nc;
  wire [7:0] c_rca_nc;
 
  half_adder b1 (a[0], b[0], sum_rca_nc [0], c_rca_nc[0]);
  full_adder b2 (a[1], b[1], sum_rca_nc[1], c_rca_nc[1], c_rca_nc[0]);
  full_adder b3 (a[2], b[2], sum_rca_nc[2], c_rca_nc[2], c_rca_nc[1]);
  full_adder b4 (a[3], b[3], sum_rca_nc[3], c_rca_nc[3], c_rca_nc[2]);
  full_adder b5 (a[4], b[4], sum_rca_nc[4], c_rca_nc[4], c_rca_nc[3]);
  full_adder b6 (a[5], b[5], sum_rca_nc[5], c_rca_nc[5], c_rca_nc[4]);
  full_adder b7 (a[6], b[6], sum_rca_nc[6], c_rca_nc[6], c_rca_nc[5]);
  full_adder b8 (a[7], b[7], sum_rca_nc[7], cout_rca_nc, c_rca_nc[6]);
endmodule

module ripple_adder_cin (a, b, sum_rca_c, cout_rca_c, cin_rca);
  input [7:0] a,b;
  input cin_rca;
  output [7:0] sum_rca_c;
  output cout_rca_c;
  wire [7:0] c_rca_c;
 
  full_adder b1 (a[0], b[0], sum_rca_c[0], c_rca_c[0], cin_rca);
  full_adder b2 (a[1], b[1], sum_rca_c[1], c_rca_c[1], c_rca_c[0]);
  full_adder b3 (a[2], b[2], sum_rca_c[2], c_rca_c[2], c_rca_c[1]);
  full_adder b4 (a[3], b[3], sum_rca_c[3], c_rca_c[3], c_rca_c[2]);
  full_adder b5 (a[4], b[4], sum_rca_c[4], c_rca_c[4], c_rca_c[3]);
  full_adder b6 (a[5], b[5], sum_rca_c[5], c_rca_c[5], c_rca_c[4]);
  full_adder b7 (a[6], b[6], sum_rca_c[6], c_rca_c[6], c_rca_c[5]);
  full_adder b8 (a[7], b[7], sum_rca_c[7], cout_rca_c, c_rca_c[6]);
endmodule

module csa_8bit(a,b, sum_csa_8bit_0, sum_csa_8bit_1, cout_csa_8bit_0, cout_csa_8bit_1);
  input [7:0] a,b;
  output [7:0] sum_csa_8bit_0, sum_csa_8bit_1;
  output cout_csa_8bit_0, cout_csa_8bit_1;

  ripple_adder_no_cin r1 (a, b, sum_csa_8bit_0, cout_csa_8bit_0);
  ripple_adder_cin    r2 (a, b, sum_csa_8bit_1, cout_csa_8bit_1, 1'b1);
endmodule

module mux_8 (s0, s1, c0, c1, sel, sum_8, cout_8);
  input [7:0] s0, s1;
  input c0, c1, sel;
  output [7:0] sum_8;
  output cout_8;
  assign sum_8  = sel ? s1 : s0;
  assign cout_8 = sel ? c1 : c0;
endmodule

module mux_16_tier1 (b_s_0, b_s_1, a_s_0, a_s_1, b_c_0, b_c_1, a_c_0, a_c_1, o_s_0, o_s_1, o_c_0, o_c_1);
  input [7:0] b_s_0, b_s_1, a_s_0, a_s_1;
  input a_c_0, a_c_1, b_c_0, b_c_1;
  output [15:0] o_s_0, o_s_1;
  output o_c_0, o_c_1;

  assign o_s_0 = a_c_0 ? {b_s_1,a_s_0}:{b_s_0,a_s_0};
  assign o_s_1 = a_c_1 ? {b_s_1,a_s_1}:{b_s_0,a_s_1};
  assign o_c_0 = a_c_0 ? b_c_0 : b_c_1;
  assign o_c_1 = a_c_1 ? b_c_1 : b_c_0;
endmodule

module mux_16_tier2 (o_s_0, o_s_1, o_c_0, o_c_1, cin, e_s, e_c);
  input [15:0] o_s_0, o_s_1;
  input o_c_0, o_c_1, cin;
  output [15:0] e_s;
  output e_c;

  assign e_s = cin ? o_s_1 : o_s_0;
  assign e_c = cin ? o_c_1 : o_c_0;
endmodule

module mux_32_tier2 (b_s_0, b_s_1, a_s_0, a_s_1, b_c_0, b_c_1, a_c_0, a_c_1, o_s_0, o_s_1, o_c_0, o_c_1);
  input [15:0] b_s_0, b_s_1, a_s_0, a_s_1;
  input a_c_0, a_c_1, b_c_0, b_c_1;
  output [31:0] o_s_0, o_s_1;
  output o_c_0, o_c_1;

  assign o_s_0 = a_c_0 ? {b_s_1,a_s_0}:{b_s_0,a_s_0};
  assign o_s_1 = a_c_1 ? {b_s_1,a_s_1}:{b_s_0,a_s_1};
  assign o_c_0 = a_c_0 ? b_c_0 : b_c_1;
  assign o_c_1 = a_c_1 ? b_c_1 : b_c_0;
endmodule

module mux_32_tier3 (o_s_0, o_s_1, o_c_0, o_c_1, cin, e_s, e_c);
  input [31:0] o_s_0, o_s_1;
  input o_c_0, o_c_1, cin;
  output [31:0]e_s;
  output e_c;

  assign e_s = cin ? o_s_1 : o_s_0;
  assign e_c = cin ? o_c_1 : o_c_0;
endmodule

module csa_64bit (a, b, addsum, clock, overflow, start, reset, sum_csa_64, cout_csa_64);
  input [63:0] a,b;
  input addsum, clock, start, reset;
  output overflow;
  output cout_csa_64;
  output [63:0] sum_csa_64;
  wire c_csa_7, c_csa_15, c_csa_31;
  reg [63:0] op1, op2;
  reg cin_addsum;
  //csa2
  wire[7:0] sum_csa2_0, sum_csa2_1;
  wire cout_csa2_0, cout_csa2_1;
  //csa3
  wire [7:0] sum_csa3_0, sum_csa3_1;
  wire cout_csa3_0, cout_csa3_1;
  //csa4
  wire [7:0] sum_csa4_0, sum_csa4_1;
  wire cout_csa4_0, cout_csa4_1;
  wire [15:0] mux_t1_31_s_0, mux_t1_31_s_1, mux_t2_31_s;
  wire mux_t1_31_c_0, mux_t1_31_c_1, mux_t2_31_c;
  //csa5
  wire [7:0] sum_csa5_0, sum_csa5_1;
  wire cout_csa5_0, cout_csa5_1;
  //csa6
  wire [7:0] sum_csa6_0, sum_csa6_1;
  wire cout_csa6_0, cout_csa6_1;
  wire [15:0] mux_t1_47_s_0, mux_t1_47_s_1 ;
  wire mux_t1_47_c_0, mux_t1_47_c_1 ;
  //csa7
  wire [7:0] sum_csa7_0, sum_csa7_1;
  wire cout_csa7_0, cout_csa7_1;
  //csa8
  wire [7:0] sum_csa8_0, sum_csa8_1;
  wire cout_csa8_0, cout_csa8_1;
  wire [15:0] mux_t1_63_s_0, mux_t1_63_s_1 ;
  wire [31:0] mux_t2_63_s_0, mux_t2_63_s_1 ;
  wire mux_t1_63_c_0, mux_t1_63_c_1, mux_t2_63_c_0, mux_t2_63_c_1 ;
  assign overflow = sum_csa_64[63];
  initial 
  begin
      op1 = 0;
      op2 = 0;
      cin_addsum = 0;
  end
  always @(clock)
  begin
     if (reset)
     begin
         op1 <= 0;
         op2 <= 0;
     end
     else if (start)
     begin
         op1 <= a;
         if (addsum) 
         begin
             op2 <= ~ b;
             cin_addsum = 1;
         end
         else begin
             op2 <= b;
         end
     end
 end

  //0-7 bit
 // ripple_adder_no_cin csa_1 (op1[7:0], op2[7:0], sum_csa_64[7:0], c_csa_7);
  ripple_adder_cin csa_1 (op1[7:0], op2[7:0], sum_csa_64[7:0], c_csa_7,cin_addsum);
  
  // 8-15 bit
  csa_8bit csa_2 (op1[15:8], op2[15:8], sum_csa2_0[7:0], sum_csa2_1[7:0], cout_csa2_0, cout_csa2_1);
  mux_8 mux_csa_2 (sum_csa2_0, sum_csa2_1, cout_csa2_0, cout_csa2_1, c_csa_7, sum_csa_64 [15:8], c_csa_15);

  // 16-23 bit
  csa_8bit csa_3 (op1[23:16], op2[23:16], sum_csa3_0[7:0], sum_csa3_1[7:0], cout_csa3_0, cout_csa3_1); 
  
  // 24-31 bit
  csa_8bit csa_4 (op1[31:24], op2[31:24], sum_csa4_0[7:0], sum_csa4_1[7:0], cout_csa4_0, cout_csa4_1); 
  
  mux_16_tier1 mux_t1_csa_3_4 (sum_csa4_0, sum_csa4_1, sum_csa3_0, sum_csa3_1, cout_csa4_0, cout_csa4_1, cout_csa3_0, cout_csa3_1, mux_t1_31_s_0, mux_t1_31_s_1, mux_t1_31_c_0, mux_t1_31_c_1 ); 
  
 mux_16_tier2 mux_t2_csa_3_4 (mux_t1_31_s_0, mux_t1_31_s_1, mux_t1_31_c_0, mux_t1_31_c_1, c_csa_15, sum_csa_64 [31:16], c_csa_31);
     //mux_t2_31_s, mux_t2_31_c); 
  
  // 32-39 bit
  csa_8bit csa_5 (op1[39:32], op2[39:32], sum_csa5_0[7:0], sum_csa5_1[7:0], cout_csa5_0, cout_csa5_1); 
  
  // 40-47 bit
  csa_8bit csa_6 (op1[47:40], op2[47:40], sum_csa6_0[7:0], sum_csa6_1[7:0], cout_csa6_0, cout_csa6_1); 
  
  mux_16_tier1 mux_t1_csa_5_6 (sum_csa6_0, sum_csa6_1, sum_csa5_0, sum_csa5_1, cout_csa6_0, cout_csa6_1, cout_csa5_0, cout_csa5_1, mux_t1_47_s_0, mux_t1_47_s_1, mux_t1_47_c_0, mux_t1_47_c_1 ); 
  
  // 48-55 bit
  csa_8bit csa_7 (op1[55:48], op2[55:48], sum_csa7_0[7:0], sum_csa7_1[7:0], cout_csa7_0, cout_csa7_1); 
  
  // 56-63 bit
  csa_8bit csa_8 (op1[63:56], op2[63:56], sum_csa8_0[7:0], sum_csa8_1[7:0], cout_csa8_0, cout_csa8_1); 
  
  mux_16_tier1 mux_t1_csa_7_8 (sum_csa8_0, sum_csa8_1, sum_csa7_0, sum_csa7_1, cout_csa8_0, cout_csa8_1, cout_csa7_0, cout_csa7_1, mux_t1_63_s_0, mux_t1_63_s_1, mux_t1_63_c_0, mux_t1_63_c_1 ); 

 mux_32_tier2 mux_t2_csa_5_8 (mux_t1_63_s_0, mux_t1_63_s_1, mux_t1_47_s_0, mux_t1_47_s_1, mux_t1_63_c_0, mux_t1_63_c_1, mux_t1_47_c_0, mux_t1_47_c_1, mux_t2_63_s_0, mux_t2_63_s_1, mux_t2_63_c_0, mux_t2_63_c_1 );

 mux_32_tier3 mux_t3_csa_5_8 (mux_t2_63_s_0, mux_t2_63_s_1, mux_t2_63_c_0, mux_t2_63_c_1, c_csa_31, sum_csa_64[63:32],cout_csa_64 );
endmodule

