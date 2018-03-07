/* ctl_memcomp Version: 4.0.5-EAC3 */
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
//      CTL model for Synchronous Two-Port Register File
//
//       Instance Name:              rf_2p_hde
//       Words:                      1024
//       Bits:                       8
//       Mux:                        4
//       Drive:                      6
//       Write Mask:                 Off
//       Write Thru:                 Off
//       Extra Margin Adjustment:    On
//       Redundant Columns:          0
//       Test Muxes                  Off
//       Power Gating:               Off
//       Retention:                  On
//       Pipeline:                   Off
//       Read Disturb Test:	        Off
//       
//       Creation Date:  Sun Oct 22 16:19:40 2017
//       Version: 	r1p1
STIL 1.0 {
   CTL P2001.10;
   Design P2001.01;
}
Header {
   Title "CTL model for `rf_2p_hde";
}
Signals {
   "QA[7]" Out;
   "QA[6]" Out;
   "QA[5]" Out;
   "QA[4]" Out;
   "QA[3]" Out;
   "QA[2]" Out;
   "QA[1]" Out;
   "QA[0]" Out;
   "CLKA" In;
   "CENA" In;
   "AA[9]" In;
   "AA[8]" In;
   "AA[7]" In;
   "AA[6]" In;
   "AA[5]" In;
   "AA[4]" In;
   "AA[3]" In;
   "AA[2]" In;
   "AA[1]" In;
   "AA[0]" In;
   "CLKB" In;
   "CENB" In;
   "AB[9]" In;
   "AB[8]" In;
   "AB[7]" In;
   "AB[6]" In;
   "AB[5]" In;
   "AB[4]" In;
   "AB[3]" In;
   "AB[2]" In;
   "AB[1]" In;
   "AB[0]" In;
   "DB[7]" In;
   "DB[6]" In;
   "DB[5]" In;
   "DB[4]" In;
   "DB[3]" In;
   "DB[2]" In;
   "DB[1]" In;
   "DB[0]" In;
   "EMAA[2]" In;
   "EMAA[1]" In;
   "EMAA[0]" In;
   "EMAB[2]" In;
   "EMAB[1]" In;
   "EMAB[0]" In;
   "RET1N" In;
   "COLLDISN" In;
}
SignalGroups {
   "all_inputs" = '"CLKA" + "CENA" + "AA[9]" + "AA[8]" + "AA[7]" + "AA[6]" + "AA[5]" + 
   "AA[4]" + "AA[3]" + "AA[2]" + "AA[1]" + "AA[0]" + "CLKB" + "CENB" + "AB[9]" + 
   "AB[8]" + "AB[7]" + "AB[6]" + "AB[5]" + "AB[4]" + "AB[3]" + "AB[2]" + "AB[1]" + 
   "AB[0]" + "DB[7]" + "DB[6]" + "DB[5]" + "DB[4]" + "DB[3]" + "DB[2]" + "DB[1]" + 
   "DB[0]" + "EMAA[2]" + "EMAA[1]" + "EMAA[0]" + "EMAB[2]" + "EMAB[1]" + "EMAB[0]" + 
   "RET1N" + "COLLDISN"';
   "all_outputs" = '"QA[7]" + "QA[6]" + "QA[5]" + "QA[4]" + "QA[3]" + "QA[2]" + "QA[1]" + 
   "QA[0]"';
   "all_ports" = '"all_inputs" + "all_outputs"';
   "_pi" = '"CLKA" + "CENA" + "AA[9]" + "AA[8]" + "AA[7]" + "AA[6]" + "AA[5]" + "AA[4]" + 
   "AA[3]" + "AA[2]" + "AA[1]" + "AA[0]" + "CLKB" + "CENB" + "AB[9]" + "AB[8]" + 
   "AB[7]" + "AB[6]" + "AB[5]" + "AB[4]" + "AB[3]" + "AB[2]" + "AB[1]" + "AB[0]" + 
   "DB[7]" + "DB[6]" + "DB[5]" + "DB[4]" + "DB[3]" + "DB[2]" + "DB[1]" + "DB[0]" + 
   "EMAA[2]" + "EMAA[1]" + "EMAA[0]" + "EMAB[2]" + "EMAB[1]" + "EMAB[0]" + "RET1N" + 
   "COLLDISN"';
   "_po" = '"QA[7]" + "QA[6]" + "QA[5]" + "QA[4]" + "QA[3]" + "QA[2]" + "QA[1]" + 
   "QA[0]"';
}
ScanStructures {
}
Timing {
   WaveformTable "_default_WFT_" {
      Period '100ns';
      Waveforms {
         "all_inputs" {
            01ZN { '0ns' D/U/Z/N; }
         }
         "all_outputs" {
            XHTL { '40ns' X/H/T/L; }
         }
         "CLKA" {
            P { '0ns' D; '45ns' U; '55ns' D; }
         }
         "CLKB" {
            P { '0ns' D; '45ns' U; '55ns' D; }
         }
      }
   }
}
Procedures {
   "capture" {
      W "_default_WFT_";
      V { "_pi" = #; "_po" = #; }
   }
   "capture_CLK" {
      W "_default_WFT_";
      V {"_pi" = #; "_po" = #;"CLKA" = P;"CLKB" = P; }
   }
   "load_unload" {
      W "_default_WFT_";
      V { "CLKA" = 0; "CLKB" = 0; }
      Shift {
         V { "CLKA" = P; "CLKB" = P; }
      }
   }
}
MacroDefs {
   "test_setup" {
      W "_default_WFT_";
      C {"all_inputs" = \r60 N; "all_outputs" = \r34 X; }
      V { "CLKA" = P; "CLKB" = P; }
   }
}
Environment "rf_2p_hde" {
   CTL {
   }
   CTL Internal_scan {
      TestMode InternalTest;
      Focus Top {
      }
      Internal {
      }
   }
}
Environment dftSpec {
   CTL {
   }
   CTL all_dft {
      TestMode ForInheritOnly;
   }
}
