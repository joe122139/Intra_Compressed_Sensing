/* common_memcomp Version: 4.0.5-beta22 */
/* lang compiler Version: 4.1.6-beta1 Jul 19 2012 13:55:19 */
//
//       CONFIDENTIAL AND PROPRIETARY SOFTWARE OF ARM PHYSICAL IP, INC.
//      
//       Copyright (c) 1993 - 2017 ARM Physical IP, Inc.  All Rights Reserved.
//      
//       Use of this Software is subject to the terms and conditions of the
//       applicable license agreement with ARM Physical IP, Inc.
//       In addition, this Software is protected by patents, copyright law 
//       and international treaties.
//      
//       The copyright notice(s) in this Software does not indicate actual or
//       intended publication of this Software.
//
//       Repair Verilog RTL for Synchronous Two-Port Register File
//
//       Instance Name:              rf_2p_hde_rtl_top
//       Words:                      1024
//       User Bits:                  8
//       Mux:                        4
//       Drive:                      6
//       Write Mask:                 Off
//       Extra Margin Adjustment:    On
//       Redundancy:                 off
//       Redundant Rows:             0
//       Redundant Columns:          0
//       Test Muxes                  Off
//       Ser:                        none
//       Retention:                  on
//       Power Gating:               off
//
//       Creation Date:  Sun Oct 22 16:21:24 2017
//       Version:      r1p1
//
//       Verified
//
//       Known Bugs: None.
//
//       Known Work Arounds: N/A
//
`timescale 1ns/1ps

module rf_2p_hde_rtl_top (
          QA, 
          CLKA, 
          CENA, 
          AA, 
          CLKB, 
          CENB, 
          AB, 
          DB, 
          EMAA, 
          EMAB, 
          RET1N, 
          COLLDISN
   );

   output [7:0]             QA;   //Data outputs, QA[0]=LSB.
   input                    CLKA;
   input                    CENA;
   input [9:0]              AA;   //Addresses, AA[0]=LSB, AB[0]=LSB.
   input                    CLKB;
   input                    CENB;
   input [9:0]              AB;   //Addresses, AA[0]=LSB, AB[0]=LSB.
   input [7:0]              DB;   //Data inputs, DB[0]=LSB.
   input [2:0]              EMAA;   //Extra margin adjustment.
   input [2:0]              EMAB;   //Extra margin adjustment.
   input                    RET1N;    //Retention mode 1 enable, active LOW
   input                    COLLDISN;   //Collision circuit disable, active LOW.
   wire [7:0]             QOA;
   wire [7:0]             DIB;

   assign QA = QOA;
   assign DIB = DB;
   rf_2p_hde_fr_top u0 (
         .QOA(QOA),
         .CLKA(CLKA),
         .CENA(CENA),
         .AA(AA),
         .CLKB(CLKB),
         .CENB(CENB),
         .AB(AB),
         .DIB(DIB),
         .EMAA(EMAA),
         .EMAB(EMAB),
         .RET1N(RET1N),
         .COLLDISN(COLLDISN)
);

endmodule

module rf_2p_hde_fr_top (
          QOA, 
          CLKA, 
          CENA, 
          AA, 
          CLKB, 
          CENB, 
          AB, 
          DIB, 
          EMAA, 
          EMAB, 
          RET1N, 
          COLLDISN
   );

   output [7:0]             QOA;
   input                    CLKA;
   input                    CENA;
   input [9:0]              AA;
   input                    CLKB;
   input                    CENB;
   input [9:0]              AB;
   input [7:0]              DIB;
   input [2:0]              EMAA;
   input [2:0]              EMAB;
   input                    RET1N;
   input                    COLLDISN;

   wire [7:0]    DB;
   wire [7:0]    QA;

   assign DB=DIB;
   assign QOA=QA;
   rf_2p_hde u0 (
         .QA(QA),
         .CLKA(CLKA),
         .CENA(CENA),
         .AA(AA),
         .CLKB(CLKB),
         .CENB(CENB),
         .AB(AB),
         .DB(DB),
         .EMAA(EMAA),
         .EMAB(EMAB),
         .RET1N(RET1N),
         .COLLDISN(COLLDISN)
   );

endmodule // rf_2p_hde_fr_top

