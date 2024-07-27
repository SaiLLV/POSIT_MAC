// Create Date: 19.07.2024 02:28:04
// Design Name: POSIT MULTIPLIER
// Module Name: Operand_Unpacking_TB
`timescale 1ns / 1ps
module Operand_Unpacking_TB();
reg [7:0]op1,op2;
wire sg1,sg2,inf1,inf2,InFlag;
wire [7:0]op1Two,op2Two;
wire[2:0] R1,R2;
wire [4:0]K1,K2;
wire [6:0]temp_expo1,temp_expo2;
wire [5:0]mantissa1,mantissa2;
wire [4:0]SF1,SF2;
wire [11:0]MantissaPdt;
wire [4:0]SFPdt;
wire [12:0]MantissaMag;
wire [7:0]ShiftVal1;
wire [31:0]QuireRegTemp;
wire SgRec;
wire [31:0]QuireMag;
wire [7:0] QLOD;
wire [31:0] mantissa_r;
wire [7:0] PositResult;

Operand_Unpacking dut(op1Two,op2Two,PositResult,mantissa_r,QLOD,QuireMag,SgRec,QuireRegTemp,ShiftVal1,MantissaMag,SFPdt,MantissaPdt,SF1,SF2,mantissa1,mantissa2,temp_expo1,temp_expo2,K1,K2,R1,R2,sg1,sg2,inf1,inf2,InFlag,op1,op2);
initial begin
op1=8'b01101101;op2=8'b01111010;
#10
$display("op1Two=%b;op2Two=%b;PositResult=%b;mantissa_r=%b;QLOD=%d;QuireMag=%b;SgRec=%b;QuireRegTemp=%b;ShiftVal1=%b;MantissaMag=%b,SFPdt=%b,MantissaPdt=%b,SF1=%b;SF2=%b;mantissa1=%b;mantissa2=%b;temp_expo1=%b;tenp_expo2=%b;K1=%d,K2=%d;R1=%d;R2=%d;op1=%b;op2=%b;sg1=%b;sg2=%b;inf1=%b;inf2=%b;Inflag=%b",op1Two,op2Two,PositResult,mantissa_r,QLOD,QuireMag,SgRec,QuireRegTemp,ShiftVal1,MantissaMag,SFPdt,MantissaPdt,SF1,SF2,mantissa1,mantissa2,temp_expo1,temp_expo2,K1,K2,R1,R2,op1,op2,sg1,sg2,inf1,inf2,InFlag);
op1=8'b10000010;op2=8'b01000001;
#10
$display("op1Two=%b;op2Two=%b;PositResult=%b;mantissa_r=%b;QLOD=%d;QuireMag=%b;SgRec=%b;QuireRegTemp=%b;ShiftVal1=%b;MantissaMag=%b,SFPdt=%b,MantissaPdt=%b,SF1=%b;SF2=%b;mantissa1=%b;mantissa2=%b;temp_expo1=%b;tenp_expo2=%b;K1=%d,K2=%d;R1=%d;R2=%d;op1=%b;op2=%b;sg1=%b;sg2=%b;inf1=%b;inf2=%b;Inflag=%b",op1Two,op2Two,PositResult,mantissa_r,QLOD,QuireMag,SgRec,QuireRegTemp,ShiftVal1,MantissaMag,SFPdt,MantissaPdt,SF1,SF2,mantissa1,mantissa2,temp_expo1,temp_expo2,K1,K2,R1,R2,op1,op2,sg1,sg2,inf1,inf2,InFlag);
op1=8'b10110111;op2=8'b11111111;
#10
$display("op1Two=%b;op2Two=%b;PositResult=%b;mantissa_r=%b;QLOD=%d;QuireMag=%b;SgRec=%b;QuireRegTemp=%b;ShiftVal1=%b;MantissaMag=%b,SFPdt=%b,MantissaPdt=%b,SF1=%b;SF2=%b;mantissa1=%b;mantissa2=%b;temp_expo1=%b;tenp_expo2=%b;K1=%d,K2=%d;R1=%d;R2=%d;op1=%b;op2=%b;sg1=%b;sg2=%b;inf1=%b;inf2=%b;Inflag=%b",op1Two,op2Two,PositResult,mantissa_r,QLOD,QuireMag,SgRec,QuireRegTemp,ShiftVal1,MantissaMag,SFPdt,MantissaPdt,SF1,SF2,mantissa1,mantissa2,temp_expo1,temp_expo2,K1,K2,R1,R2,op1,op2,sg1,sg2,inf1,inf2,InFlag);
end
initial begin
#40
$finish();
end
endmodule
