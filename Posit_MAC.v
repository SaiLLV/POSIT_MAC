
// Create Date: 19.07.2024 02:03:59
// Design Name: POSIT MULTIPIER
// Module Name: Operand_Unpacking

`timescale 1ns / 1ps
module Operand_Unpacking(op1Two,op2Two,PositResult,mantissa_r,QLOD,QuireMag,SgRec,QuireRegTemp,ShiftVal1,MantissaMag,SFPdt,MantissaPdt,SF1,SF2,mantissa1,mantissa2,temp_expo1,temp_expo2,K1,K2,R1,R2,sg1,sg2,inf1,inf2,InFlag,op1,op2);
parameter N=8,ES=0,RS=3;
parameter QS=32,QF=12;
input [N-1:0]op1;
input [N-1:0]op2;   
output sg1,sg2,inf1,inf2,InFlag;
output [N-1:0]op1Two,op2Two;
output reg [2:0]R1,R2;
output reg [RS+1:0]K1,K2;
output [N-2:0]temp_expo1,temp_expo2;
output [N-ES-3:0]mantissa1,mantissa2;
output [RS+ES+1:0]SF1,SF2;
output [2*(N-3-ES)+1:0] MantissaPdt;
output reg [RS+ES+1:0]SFPdt;
output reg [2*(N-3-ES)+2:0]MantissaMag;
reg Mulsg;
wire sg1,sg2,inf1,inf2,InFlag;
reg [N-1:0]op1Two,op2Two;
reg [N-2:0] temp_regm1,temp_regm2;
wire [QS-1:0]QuireReg;
output reg [N-1:0]ShiftVal1;
output reg [QS-1:0]QuireRegTemp;
output SgRec;
output reg [QS-1:0]QuireMag;
output reg [N-1:0] QLOD;
output [QS-1:0] mantissa_r;
output reg [N-1:0] PositResult;
//Unpacking of Posit Operands
//Sign Extraction
assign sg1=op1[N-1];
assign sg2=op2[N-1];
//Special Number Checking
assign inf1=op1[N-1]&(~(|op1[N-2:0]));
assign inf2=op2[N-1]&(~(|op2[N-2:0]));
assign InFlag=inf1|inf2;
//Two’s complement calculation
always@(*)
begin
if(op1[N-1]&&inf1!=1'b1)
op1Two=~op1+1'b1;
else
op1Two=op1;
end
always@(*)
begin
if(op2[N-1]&&inf2!=1'b1)
op2Two=~op2+1'b1;
else
op2Two=op2;
end
//Regime Extraction
always@(*)
begin
if(op1Two[N-2]==1'b1)
 temp_regm1=~op1Two;//complementing the bits to find Leading One - op1Two
else
 temp_regm1=op1Two;
end
always@(*)
begin
if(op2Two[N-2]==1'b1)
 temp_regm2=~op2Two;//complementing the bits to find Leading One - op2Two
else
 temp_regm2=op2Two;
end
//Finding no of zeroes before the leading one for op1Two
integer i; reg found1;
always @(*) 
begin
R1 = 3'b000;
found1 = 0;
for (i = N-2; i >= 0; i = i - 1)
begin
if (!found1) begin
if (temp_regm1[i] == 1'b1)                    
found1 = 1;
else 
R1 = R1 + 1;                    
end                
end           
end      
//Finding no of zeroes before the leading one for op2Two
integer j; reg found2;
always @(*) 
begin
R2 = 3'b000;
found2 = 0;
for (j = N-2; j >= 0; j = j - 1)
begin
if (!found2) begin
if (temp_regm2[j] == 1'b1)                    
found2 = 1;
else 
R2 = R2 + 1;                    
end                
end           
end 
//Calculating the useed value for op1Two
always@(*)
begin
if(op1Two[N-2]==1'b1)
 K1=R1-1'b1;
else
 K1=~R1+1'b1;
end
//Calculating the useed value for op1Two
always@(*)
begin
if(op2Two[N-2]==1'b1)
 K2=R2-1'b1;
else
 K2=~R2+1'b1;
end    
assign temp_expo1=(op1Two[N-2:0])<<(R1+1'b1);
assign temp_expo2=(op2Two[N-2:0])<<(R2+1'b1);
//Mantissa Extraction
assign mantissa1 = {1'b1,temp_expo1[N-ES-2:2]};
assign mantissa2 = {1'b1,temp_expo2[N-ES-2:2]};
//Scaling Factor Calculation
assign SF1=K1;
assign SF2=K2;

//////////////ALGORITHM - 2 (Mantissa Multipication)/////////////// 
always @(*)
begin
Mulsg=sg1^sg2;
end
assign MantissaPdt=mantissa1*mantissa2;
always@(*)
begin
if(K1[RS+ES+1]==1'b1&&K2[RS+ES+1]==1'b1)
begin
SFPdt=(~SF1+1'b1)+(~SF2+1'b1);
SFPdt=~SFPdt+1;
end
else
SFPdt=SF1+SF2;
end
always @(*)
begin
if(Mulsg)
MantissaMag=~MantissaPdt+1;
else
MantissaMag=MantissaPdt;
end

//////////////ALGORITHM - 3 (QUIRE CONSTRUCTION)/////////////
reg [4:0]dummy;
assign QuireReg = {MantissaMag,19'b0000000000000000000};
always@(*)
begin
if(SFPdt[RS+ES+1]==1'b1)
begin
dummy=~SFPdt+1'b1;
ShiftVal1=5'b10001+dummy;
end
else
ShiftVal1=5'b10001-SFPdt;
end
always@(*)
begin
if(MantissaMag[12])
QuireRegTemp=({19'b1111111111111111111,MantissaMag})<<(19-ShiftVal1);
else
QuireRegTemp=QuireReg>>ShiftVal1;
end

///////////// ALGORITHM - 4 (QUIRE to POSIT RECONSTRUCTION)/////////////
assign SgRec = QuireRegTemp[QS-1];
always@(*)
begin
if(SgRec==1'b1)
QuireMag=~QuireRegTemp+1'b1;
else
QuireMag=QuireRegTemp;
end
////Finding no of zeroes before the leading one for QuireMag
integer k; reg found3; 
always @(*) 
begin
QLOD=8'b00000000;
found3 = 0;
for (k = QS-1; k >= 0; k = k - 1)
begin
if (!found3) begin
if (QuireMag[k] == 1'b1)                    
found3 = 1;
else 
QLOD = QLOD + 1;                  
end                
end           
end 
//
reg ZeroFlag;
always@(*)
begin
ZeroFlag=~(|QuireMag);
end
wire [N-1:0] SF_r;
wire [RS+ES+1:0] SF_final;
wire [RS+1:0] k_r;
reg [RS+1:0] m_r;
wire [QS-1:0] mantissa_r;

assign SF_r[N-1:0]=QS-QF-QLOD-1;
assign SF_final=SF_r[RS+ES+1:0];
assign k_r=SF_final[RS+ES+1:ES];
always@(*)
begin
if(k_r[RS+1]==1'b1)
m_r=~k_r+1'b1;
else
m_r=k_r+1'b1;
end
assign mantissa_r=QuireMag<<(QLOD+1);

/////////////ALGORITHM - 5 (Posit Reconstruction, Rounding & Post Processing)///////////
wire [N-1:0]ShiftVal2; reg [5:0]string;
reg [QS+N-2+ES:0]PositRecTemp;
reg [QS+N-2+ES:0]PositRec;
wire Sticky,Last,Guard,RoundBit;
reg Maxpos,Minpos;
reg [N-2:0]PositVal;

assign ShiftVal2=N-m_r-2;

always@(*)
begin
if(k_r[RS+1])
begin
string = 6'b000000;
PositRecTemp={string,k_r[RS+1],mantissa_r};
PositRec=PositRecTemp<<ShiftVal2;
end
else
begin
string = 6'b111111;
PositRecTemp={string,k_r[RS+1],mantissa_r};
PositRec=PositRecTemp<<ShiftVal2;
end
end

assign Sticky = (|PositRec[QS+ES-2:0]);
assign Last = PositRec[QS+ES];
assign Guard = PositRec[QS+ES-1];
assign RoundBit = Guard&(Last|Sticky);

always@(*)
begin
PositVal=PositRec[QS+N-2+ES:QS+ES]+RoundBit;
if(SgRec)
PositVal=~PositVal+1'b1;
else
PositVal=PositVal;
end

always@(*)
begin
if(k_r>=(N-2))
Maxpos=1'b1;
else
Maxpos=1'b0;
end

always@(*)
begin
if(k_r<(2-N))
Minpos=1'b1;
else
Minpos=1'b0;
end

always@(*)
begin
PositResult={SgRec, PositVal};
end
endmodule
