Gustavo Pelayo  - 201606773
Rui Barbosa     - 201605740


reg_bank.v
    implements the registers fill of the register bank


/*****************************************************************************|
|OPR| DESCRIPTION              |MAX CLKS|                                     |
|---|--------------------------|--------|-------------------------------------|
| 0 |                          |  1 clk | outAB <= A                          |
| 1 |                          |  1 clk | outAB <= B                          |
| 2 | Complex & Real add       |  2 clk | outAB <= A + B                      |
| 3 | Complex & Real sub       |  2 clk | outAB <= A – B                      |
| 4 | Complex multiplication   |  6 clk | outAB <= A * B                      |
| 5 | Complex division         | 40 clk | outAB <= A / B                      |
| 6 | Real multiplication      |  4 clk | outAB <= RE(A)*RE(B) , IM(A)*IM(B)  |  
| 7 | Real division            | 34 clk | outAB <= RE(A)/RE(B) , IM(A)/IM(B)  | 
| 8 | Equality compare         |  1 clk | outAB <= (A == B)                   |
| 9 | Conv inA to polar coords | 38 clk | outAB <= { MOD(A), ANG(A) }         |
| 10| Conv inB to polar coords | 38 clk | outAB <= { MOD(B), ANG(B) }         |
******************************************************************************/

alu.v: 
    implements alu arithmetic and logical operations 0, 1, 2, 3, 6, 7, 8

cmplxMult.v   
    implements alu operation 4, complex multiplication 

cmplxDiv.v    
    implements alu operation 5, complex division

rec2pol.v
    implements alu operations 9 and 10, conversion to polar coordinates


tb_reg.v 
    responsible to test if the input number is corretly stored in the selected register
    we compare the input word, 20+20i, with the corresponding selected register by
    cycling trough the 16 registers

tb.v
    responsible to test if all operations performed by alu and auxiliar modules are correct
    
