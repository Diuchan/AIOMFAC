!****************************************************************************************
!*   :: Purpose ::                                                                      *
!*   Module to declare the character strings for the subgroup names and atomic          * 
!*   composition of organic subgrous. Also defined are the AIOMFAC main group names and *
!*   a subroutine for extracting a component's subgroup string is provided.             * 
!*                                                                                      *
!*   :: Author & Copyright ::                                                           *
!*   Andi Zuend,                                                                        *
!*   IACETH, ETH Zurich, (2004 - 2009)                                                  *
!*   Div. Chemistry and Chemical Engineering, Caltech, Pasadena, CA, USA (2009 - 2012)  *
!*   Dept. Atmospheric and Oceanic Sciences, McGill University                          *
!*                                                                                      *
!*   -> created:        2018 (based on non-module version from 2009)                    *
!*   -> latest changes: 2018/09/14                                                      *
!*                                                                                      *
!*   :: License ::                                                                      *
!*   This program is free software: you can redistribute it and/or modify it under the  *
!*   terms of the GNU General Public License as published by the Free Software          *
!*   Foundation, either version 3 of the License, or (at your option) any later         *
!*   version.                                                                           *
!*   The AIOMFAC model code is distributed in the hope that it will be useful, but      *
!*   WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or      *
!*   FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more      *
!*   details.                                                                           *
!*   You should have received a copy of the GNU General Public License along with this  *
!*   program. If not, see <http://www.gnu.org/licenses/>.                               *
!*                                                                                      *
!*   :: List of subroutines and functions contained in this module:                     *
!*   --------------------------------------------------------------                     *
!*   -  SUBROUTINE SubgroupAtoms                                                        *
!*   -  SUBROUTINE SubgroupNames                                                        *
!*   -  SUBROUTINE MaingroupNames                                                       *
!*   -  SUBROUTINE cpsubgrstring                                                        *
!*   -  SUBROUTINE O2C_H2C_component                                                    *
!*   -  SUBROUTINE OtoCandHtoCmix                                                       *
!*                                                                                      *
!****************************************************************************************
MODULE ModSubgroupProp

USE ModSystemProp, ONLY : Nmaingroups

IMPLICIT NONE

!module public vars:
INTEGER(4),DIMENSION(261),PUBLIC :: NKTAB   !lists AIOMFAC subgroup affiliations with main groups
INTEGER(4),DIMENSION(201:261),PUBLIC :: Ioncharge  !the (positive or negative) integer-valued relative el. charge of the ions.
INTEGER(4),DIMENSION(200),PUBLIC :: subgC, subgH, subgO, subgN, subgS !the C, H, O, etc. atoms in organic subgroups
REAL(8),DIMENSION(201:261),PUBLIC :: IonO2Cequiv
REAL(8),DIMENSION(200),PUBLIC :: GroupMW    !list of subgroup molar masses [g/mol]
REAL(8),DIMENSION(40),PUBLIC :: SMWA, SMWC  !lists of anion and cation molar masses [g/mol]
CHARACTER(LEN=100),DIMENSION(261),PUBLIC :: subgrname, subgrnameTeX, subgrnameHTML
CHARACTER(LEN=50),DIMENSION(Nmaingroups),PUBLIC :: maingrname

!load data arrays:
!-----------------
!NKTAB: assigns UNIFAC/AIOMFAC subgroups to corresponding main groups; listed is the main group of a subgroup (from subgroup 1 to 261). 
!subgroup no.: 1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, etc. (21, ..., 40 on next row, etc.)
DATA NKTAB /  01, 01, 01, 01, 02, 02, 02, 02, 03, 03, 04, 04, 04, 05, 06, 07, 08, 09, 09, 10, &
            & 11, 11, 12, 13, 13, 13, 13, 14, 14, 14, 15, 15, 15, 16, 16, 17, 18, 18, 18, 19, &
            & 19, 20, 20, 21, 21, 21, 22, 22, 22, 23, 23, 24, 25, 26, 26, 26, 27, 28, 29, 29, &
            & 30, 31, 32, 33, 34, 34, 35, 36, 37, 02, 38, 39, 39, 40, 40, 40, 41, 42, 42, 42, &
            & 42, 43, 43, 43, 44, 45, 45, 45, 45, 45, 45, 45, 45, 46, 46, 46, 46, 46, 46, 47, &
            & 47, 48, 48, 48, 49, 50, 50, 50, 52, 52, 52, 52, 53, 54, 55, 55, 56, 56, 56, 56, &
            & 57, 57, 57, 58, 59, 59, 59, 59, 60, 61, 62, 62, 62, 62, 63, 64, 65, 00, 00, 00, &
            & 66, 66, 66, 66, 67, 67, 67, 67, 68, 68, 68, 68, 69, 70, 71, 71, 71, 72, 72, 72, &
            & 73, 74, 74, 74, 74, 74, 74, 74, 74, 74, 74, 75, 00, 00, 00, 00, 00, 00, 00, 00, &
            & 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, &
            & 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, & !51 indicates that this main group is an ion
            & 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, &
            & 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, 51, &
            & 51 /
    
!Molecular mass of the neutral (UNIFAC) subgroups [g/mol]:
!subgroup no.:       1,             2,            3,            4,            5,            6,            7,            8,            9,           10,  etc. (11, ..., 20 on next row, etc.)
DATA GroupMW / 1.50340D+01,  1.40260D+01,  1.30180D+01,  1.20100D+01,  2.70440D+01,  2.60000D+01,  2.60000D+01,  2.50280D+01,  1.30180D+01,  1.20100D+01, &
            &  2.70440D+01,  2.60000D+01,  2.50000D+01,  1.70080D+01,  3.20000D+01,  1.801528D+1,  2.90000D+01,  4.30000D+01,  4.20000D+01,  2.90000D+01, &
            &  5.90000D+01,  5.80000D+01,  4.50000D+01,  3.10000D+01,  3.00268D+01,  2.90000D+01,  3.00000D+01,  3.10500D+01,  3.00000D+01,  2.90000D+01, &
            &  3.00000D+01,  2.90000D+01,  2.80000D+01,  2.90000D+01,  2.80000D+01,  2.80000D+01,  7.90000D+01,  7.80000D+01,  7.70000D+01,  4.10000D+01, &
            &  4.00000D+01,  4.50000D+01,  4.60000D+01,  4.95000D+01,  4.85000D+01,  4.75000D+01,  8.50000D+01,  8.40000D+01,  8.30000D+01,  1.19500D+02, &
            &  1.18500D+02,  1.54000D+02,  4.75000D+01,  6.10000D+01,  6.00000D+01,  5.90000D+01,  5.80000D+01,  7.60000D+01,  4.80000D+01,  4.70000D+01, &
            &  9.60900D+01,  1.90000D+01,  1.26900D+02,  7.99000D+01,  2.50000D+01,  2.40000D+01,  7.81300D+01,  5.30600D+01,  5.95000D+01,  2.40200D+01, &
            &  7.30900D+01,  7.10000D+01,  6.90000D+01,  5.00000D+01,  3.10000D+01,  4.40000D+01,  3.10000D+01,  3.00000D+01,  3.00000D+01,  2.90000D+01, &
            &  2.80000D+01,  4.60000D+01,  4.50000D+01,  4.40000D+01,  9.91300D+01,  1.37500D+02,  1.02000D+02,  1.03000D+02,  8.75000D+01,  8.55000D+01, &
            &  8.65000D+01,  1.04500D+02,  1.21000D+02,  4.40000D+01,  5.80000D+01,  5.70000D+01,  7.20000D+01,  7.10000D+01,  7.00000D+01,  6.10000D+01, &
            &  6.00000D+01,  4.70000D+01,  4.60000D+01,  4.50000D+01,  8.71200D+01,  8.40000D+01,  8.30000D+01,  8.20000D+01,  1.50000D+01,  1.40000D+01, &
            &  1.30000D+01,  1.20000D+01,  1.70000D+01,  4.50000D+01,  4.30000D+01,  4.20000D+01,  1.50000D+01,  1.40000D+01,  1.30000D+01,  1.20000D+01, &
            &  3.10000D+01,  3.00000D+01,  2.90000D+01,  1.70000D+01,  1.50000D+01,  1.40000D+01,  1.30000D+01,  1.20000D+01,  4.50000D+01,  1.70000D+01, &
            &  1.50000D+01,  1.40000D+01,  1.30000D+01,  1.20000D+01,  4.50000D+01,  1.70000D+01,  4.50000D+01,  0.00000D+00,  0.00000D+00,  0.00000D+00, &
            &  1.50340D+01,  1.40260D+01,  1.30180D+01,  1.20100D+01,  1.50340D+01,  1.40260D+01,  1.30180D+01,  1.20100D+01,  1.50340D+01,  1.40260D+01, &
            &  1.30180D+01,  1.20100D+01,  1.70080D+01,  4.40528D+01,  7.60260D+01,  7.50180D+01,  7.40100D+01,  4.70340D+01,  4.60260D+01,  4.50180D+01, &
            &  6.10180D+01,  6.20680D+01,  6.10600D+01,  6.00520D+01,  5.90440D+01,  6.00520D+01,  5.90440D+01,  5.80360D+01,  5.80360D+01,  5.70280D+01, &
            &  5.60200D+01,  1.06010D+02,  0.00000D+00,  0.00000D+00,  0.00000D+00,  0.00000D+00,  0.00000D+00,  0.00000D+00,  0.00000D+00,  0.00000D+00, &
            &  0.00000D+00,  0.00000D+00,  0.00000D+00,  0.00000D+00,  0.00000D+00,  0.00000D+00,  0.00000D+00,  0.00000D+00,  0.00000D+00,  0.00000D+00, &
            &  0.00000D+00,  0.00000D+00,  0.00000D+00,  0.00000D+00,  0.00000D+00,  0.00000D+00,  0.00000D+00,  0.00000D+00,  0.00000D+00,  0.00000D+00 /
   
!List of the molecular masses of the ions [g/mol]; The order is ion ID -200 for cations, e.g. SMWC(2) is molar mass of ion 202 = Na+, and ion-ID -240 for anions, e.g.(e.g. SMWA(3) is molar mass of ion 243 = Br-). 
!cation no.:       1,             2,            3,            4,            5,            6,            7,            8,            9,           10,  etc. (11, ..., 20 on next row, etc.)
DATA SMWC /  6.94100D+00,  2.29900D+01,  3.90980D+01,  1.80380D+01,  1.00800D+00,  0.00000D+00,  0.00000D+00,  0.00000D+00,  0.00000D+00,  0.00000D+00, &
          &  0.00000D+00,  0.00000D+00,  0.00000D+00,  0.00000D+00,  0.00000D+00,  0.00000D+00,  0.00000D+00,  0.00000D+00,  0.00000D+00,  0.00000D+00, &
          &  4.00780D+01,  1.37330D+02,  2.43050D+01,  8.76200D+01,  5.89330D+01,  5.86930D+01,  6.35460D+01,  6.53900D+01,  2.00590D+02,  0.00000D+00, &
          &  0.00000D+00,  0.00000D+00,  0.00000D+00,  0.00000D+00,  0.00000D+00,  0.00000D+00,  0.00000D+00,  0.00000D+00,  0.00000D+00,  0.00000D+00 /
  
!anion no.:       1,             2,            3,            4,            5,            6,            7,            8,            9,           10,  etc. (11, ..., 20 on next row, etc.)
DATA SMWA /  1.89980D+01,  3.54530D+01,  7.99040D+01,  1.26905D+02,  6.20040D+01,  5.90440D+01,  5.80840D+01,  9.70710D+01,  9.50925D+01,  0.00000D+00, &
          &  0.00000D+00,  0.00000D+00,  0.00000D+00,  0.00000D+00,  0.00000D+00,  0.00000D+00,  0.00000D+00,  0.00000D+00,  0.00000D+00,  0.00000D+00, &
          &  9.60630D+01,  0.00000D+00,  0.00000D+00,  0.00000D+00,  0.00000D+00,  0.00000D+00,  0.00000D+00,  0.00000D+00,  0.00000D+00,  0.00000D+00, &
          &  0.00000D+00,  0.00000D+00,  0.00000D+00,  0.00000D+00,  0.00000D+00,  0.00000D+00,  0.00000D+00,  0.00000D+00,  0.00000D+00,  0.00000D+00 /

!assign the (positive or negative) integer-valued relative electric charges to the different ion categories.
DATA Ioncharge(201:220) / 20*1 /     !single-charge cations
DATA Ioncharge(221:240) / 20*2 /     !double-charge cations
DATA Ioncharge(241:260) / 20*-1 /    !single-charge anion
DATA Ioncharge(261:261) / -2 /       !double-charge anion   

!Assign an O:C-equivalent value to each ion (which is used to compute mean electrolyte O:C equivalent values).
!These values are used to generate initial guesses in PhaseSeparation.
!- cations
DATA IonO2Cequiv(201) / 3.6D0 / !Li+
DATA IonO2Cequiv(202) / 4.0D0 / !Na+
DATA IonO2Cequiv(203) / 3.0D0 / !K+
DATA IonO2Cequiv(204) / 3.0D0 / !NH4+
DATA IonO2Cequiv(205) / 2.8D0 / !H+
DATA IonO2Cequiv(206:220) / 15*3.0D0 / !unused (other) cations
DATA IonO2Cequiv(221) / 4.0D0 / !Ca++
DATA IonO2Cequiv(223) / 4.0D0 / !Mg+
DATA IonO2Cequiv(223:240) / 18*3.0D0 / !unused (other) cations
!- anions  
DATA IonO2Cequiv(241) / 3.0D0 / !unused (other) anions
DATA IonO2Cequiv(242) / 3.4D0 / !3.4D0 !Cl-
DATA IonO2Cequiv(243) / 3.0D0 / !Br-
DATA IonO2Cequiv(244) / 3.0D0 / !I-
DATA IonO2Cequiv(245) / 2.8D0 / !NO3-
DATA IonO2Cequiv(246:247) / 2*3.0D0 / !unused (other) anions
DATA IonO2Cequiv(248) / 3.2D0 / !HSO4-
DATA IonO2Cequiv(249) / 3.2D0 / !CH3SO3-
DATA IonO2Cequiv(250:260) / 11*3.0D0 / !unused (other) anions
DATA IonO2Cequiv(261) / 4.0D0 / !SO4--


!================================================================================================================================= 
    CONTAINS
!================================================================================================================================= 
    
    !***********************************************************************************************************
    !*                                                                                                         *
    !*  Subroutine tabulating the number of carbon (C), hydrogen (H), nitrogen (N), oxygen (O), and sulfur     *
    !*  (S) atoms in organic subgroups. This allows calculating e.g. the chemical sum formula of organic       *
    !*  compounds and the O:C ratio of multicomponent mixtures.                                                *
    !*                                                                                                         *   
    !*  (c) Andi Zuend, Div. Chemistry & Chemical Engineering, California Institute of Technology, 2012        *
    !***********************************************************************************************************

    SUBROUTINE SubgroupAtoms()

    IMPLICIT NONE
    !...........................................................

    !initialize arrays:
    subgC = 0
    subgH = 0
    subgO = 0
    subgN = 0
    subgS = 0

    !list of neutral component subgroups and corresponding number of atoms:
    subgC(1) = 1; subgH(1) = 3;  !subgrname(1) =  "(CH3)"             
    subgC(2) = 1; subgH(2) = 2;  !subgrname(2) =  "(CH2)"             
    subgC(3) = 1; subgH(3) = 1;  !subgrname(3) =  "(CH)"              
    subgC(4) = 1; subgH(4) = 0;  !subgrname(4) =  "(C)"               
    subgC(5) = 2; subgH(5) = 3;  !subgrname(5) =  "(CH2=CH)"          
    subgC(6) = 2; subgH(6) = 2;  !subgrname(6) =  "(CH=CH)"           
    subgC(7) = 2; subgH(7) = 2;  !subgrname(7) =  "(CH2=C)"           
    subgC(8) = 2; subgH(8) = 1;  !subgrname(8) =  "(CH=C)"            
    subgC(70) = 2; subgH(70) = 0;  !subgrname(70) = "(C=C)"             
    subgC(9) = 1; subgH(9) = 1;  !subgrname(9) =  "(ACH)"             
    subgC(10) = 1; subgH(10) = 0;  !subgrname(10) = "(AC)"              
    subgC(11) = 2; subgH(11) = 3;  !subgrname(11) = "(ACCH3)"           
    subgC(12) = 2; subgH(12) = 2;  !subgrname(12) = "(ACCH2)"           
    subgC(13) = 2; subgH(13) = 1;  !subgrname(13) = "(ACCH)"            
    subgC(14) = 0; subgH(14) = 1; subgO(14) = 1;  !subgrname(14) = "(OH)"              
    subgC(153) = 0; subgH(153) = 1; subgO(153) = 1;  !subgrname(153) = "(OH)"             
    subgC(16) = 0; subgH(16) = 2; subgO(16) = 1;  !subgrname(16) = "H2O"             
    subgC(17) = 1; subgH(17) = 1; subgO(17) = 1;  !subgrname(17) = "(ACOH)"            
    subgC(18) = 2; subgH(18) = 3; subgO(18) = 1;  !subgrname(18) = "(CH3CO)"           
    subgC(19) = 2; subgH(19) = 2; subgO(19) = 1;  !subgrname(19) = "(CH2CO)"           
    subgC(20) = 1; subgH(20) = 1; subgO(20) = 1;  !subgrname(20) = "(CHO[aldehyde])"   
    subgC(21) = 2; subgH(21) = 3; subgO(21) = 2;  !subgrname(21) = "(CH3COO)"          
    subgC(22) = 2; subgH(22) = 2; subgO(22) = 2;  !subgrname(22) = "(CH2COO)"          
    subgC(24) = 1; subgH(24) = 3; subgO(24) = 1;  !subgrname(24) = "(CH3O)"            
    subgC(25) = 1; subgH(25) = 2; subgO(25) = 1;  !subgrname(25) = "(CH2O)"            
    subgC(26) = 1; subgH(26) = 1; subgO(26) = 1;  !subgrname(26) = "(CHO[ether])"      
    subgC(27) = 1; subgH(27) = 2; subgO(27) = 1;  !subgrname(27) = "(THF[CH2O])"
    subgC(137) = 1; subgH(137) = 1; subgO(137) = 2;  !subgrname(137) ="(COOH)"            
    subgC(42) = 1; subgH(42) = 1; subgO(42) = 2;  !subgrname(42) ="(COOH)"             
    subgC(43) = 1; subgH(43) = 2; subgO(43) = 2;  !subgrname(43) = "(HCOOH)"           
    subgC(141) = 1; subgH(141) = 3;  !subgrname(141) ="(CH3[alc])"        
    subgC(142) = 1; subgH(142) = 2;  !subgrname(142) ="(CH2[alc])"        
    subgC(143) = 1; subgH(143) = 1;  !subgrname(143) ="(CH[alc])"         
    subgC(144) = 1; subgH(144) = 0;  !subgrname(144) ="(C[alc])"          
    subgC(145) = 1; subgH(145) = 3;  !subgrname(145) ="(CH3[alc-tail])"   
    subgC(146) = 1; subgH(146) = 2;  !subgrname(146) ="(CH2[alc-tail])"   
    subgC(147) = 1; subgH(147) = 1;  !subgrname(147) ="(CH[alc-tail])"    
    subgC(148) = 1; subgH(148) = 0;  !subgrname(148) ="(C[alc-tail])"     
    subgC(149) = 1; subgH(149) = 3;  !subgrname(149) ="(CH3[OH])"         
    subgC(150) = 1; subgH(150) = 2;  !subgrname(150) ="(CH2[OH])"         
    subgC(151) = 1; subgH(151) = 1;  !subgrname(151) ="(CH[OH])"          
    subgC(152) = 1; subgH(152) = 0;  !subgrname(152) ="(C[OH])"            
    subgC(154) = 2; subgH(154) = 4; subgO(154) = 1;  !subgrname(154) = "(CH2OCH2[PEG])"  
    subgC(155) = 1; subgH(155) = 2; subgO(155) = 3; subgN(155) = 1;  !subgrname(155) ="(CH2ONO2)"         
    subgC(156) = 1; subgH(156) = 1; subgO(156) = 3; subgN(156) = 1;  !subgrname(156) ="(CHONO2)"          
    subgC(157) = 1; subgH(157) = 0; subgO(157) = 3; subgN(157) = 1;  !subgrname(157) ="(CONO2)"           
    subgC(158) = 1; subgH(158) = 3; subgO(158) = 2;  !subgrname(158) ="(CH2OOH[perox])"   
    subgC(159) = 1; subgH(159) = 2; subgO(159) = 2;  !subgrname(159) ="(CHOOH[perox])"    
    subgC(160) = 1; subgH(160) = 1; subgO(160) = 2;  !subgrname(160) ="(COOH[perox])"     
    subgC(161) = 1; subgH(161) = 1; subgO(161) = 3;  !subgrname(161) ="(C(=O)OOH[perox])" 
    subgC(162) = 2; subgH(162) = 6; subgO(162) = 2;  !subgrname(162) ="(CH3OOCH3[perox])" 
    subgC(163) = 2; subgH(163) = 5; subgO(163) = 2;  !subgrname(163) ="(CH3OOCH2[perox])" 
    subgC(164) = 2; subgH(164) = 4; subgO(164) = 2;  !subgrname(164) ="(CH3OOCH[perox])"  
    subgC(165) = 2; subgH(165) = 3; subgO(165) = 2;  !subgrname(165) ="(CH3OOC[perox])"   
    subgC(166) = 2; subgH(166) = 4; subgO(166) = 2;  !subgrname(166) ="(CH2OOCH2[perox])" 
    subgC(167) = 2; subgH(167) = 3; subgO(167) = 2;  !subgrname(167) ="(CH2OOCH[perox])"  
    subgC(168) = 2; subgH(168) = 2; subgO(168) = 2;  !subgrname(168) ="(CH2OOC[perox])"   
    subgC(169) = 2; subgH(169) = 2; subgO(169) = 2;  !subgrname(169) ="(CHOOCH[perox])"   
    subgC(170) = 2; subgH(170) = 1; subgO(170) = 2;  !subgrname(170) ="(CHOOC[perox])"    
    subgC(171) = 2; subgH(171) = 0; subgO(171) = 2;  !subgrname(171) ="(COOC[perox])"     
    subgC(172) = 1; subgH(172) = 0; subgO(172) = 5; subgN(172) = 1;  !subgrname(172) ="(C(=O)OONO2[perox])"

    END SUBROUTINE SubgroupAtoms
    !================================================================================================================================= 
    
    
    !**********************************************************************************************************
    !*                                                                                                        *
    !*  Subroutine tabulating the character strings for the names of the different organic and inorganic      *
    !*  subgroups currently allowed in an AIOMFAC mixture.                                                    *
    !*                                                                                                        *   
    !*  (c) Andi Zuend, Div. Chemistry & Chemical Engineering, California Institute of Technology, 2012       *
    !**********************************************************************************************************

    SUBROUTINE SubgroupNames()

    IMPLICIT NONE
    !...........................................................

    subgrname = "-?-"
    subgrnameTeX = "-?-"
    subgrnameHTML = "-?-"

    !list of neutral component subgroup names (plain text, TeX, and HTML formatting):
    subgrname(1) =  "(CH3)"             ;  subgrnameTeX(1) =  "(CH$_3$)"                 ;  subgrnameHTML(1) =  "(CH<sub>3</sub>)"
    subgrname(2) =  "(CH2)"             ;  subgrnameTeX(2) =  "(CH$_2$)"                 ;  subgrnameHTML(2) =  "(CH<sub>2</sub>)"
    subgrname(3) =  "(CH)"              ;  subgrnameTeX(3) =  "(CH)"                     ;  subgrnameHTML(3) =  "(CH)"
    subgrname(4) =  "(C)"               ;  subgrnameTeX(4) =  "(C)"                      ;  subgrnameHTML(4) =  "(C)"
    subgrname(5) =  "(CH2=CH)"          ;  subgrnameTeX(5) =  "(CH$_2$=CH)"              ;  subgrnameHTML(5) =  "(CH<sub>2</sub>=CH)"
    subgrname(6) =  "(CH=CH)"           ;  subgrnameTeX(6) =  "(CH=CH)"                  ;  subgrnameHTML(6) =  "(CH=CH)"
    subgrname(7) =  "(CH2=C)"           ;  subgrnameTeX(7) =  "(CH$_2$=C)"               ;  subgrnameHTML(7) =  "(CH<sub>2</sub>=C)"
    subgrname(8) =  "(CH=C)"            ;  subgrnameTeX(8) =  "(CH=C)"                   ;  subgrnameHTML(8) =  "(CH=C)"
    subgrname(70) = "(C=C)"             ;  subgrnameTeX(70) = "(C=C)"                    ;  subgrnameHTML(70) = "(C=C)"
    subgrname(9) =  "(ACH)"             ;  subgrnameTeX(9) =  "(ACH)"                    ;  subgrnameHTML(9) =  "(ACH)"
    subgrname(10) = "(AC)"              ;  subgrnameTeX(10) = "(AC)"                     ;  subgrnameHTML(10) = "(AC)"
    subgrname(11) = "(ACCH3)"           ;  subgrnameTeX(11) = "(ACCH$_3$)"               ;  subgrnameHTML(11) = "(ACCH<sub>3</sub>)"
    subgrname(12) = "(ACCH2)"           ;  subgrnameTeX(12) = "(ACCH$_2$)"               ;  subgrnameHTML(12) = "(ACCH<sub>2</sub>)"
    subgrname(13) = "(ACCH)"            ;  subgrnameTeX(13) = "(ACCH)"                   ;  subgrnameHTML(13) = "(ACCH)"
    subgrname(14) = "(OH)"              ;  subgrnameTeX(14) = "(OH)"                     ;  subgrnameHTML(14) = "(OH)"
    subgrname(153) = "(OH)"             ;  subgrnameTeX(153) = "(OH)"                    ;  subgrnameHTML(153) = "(OH)"
    !subgrname(16) = "H2O"               ;  subgrnameTeX(16) = "H$_2$O"                   ;  subgrnameHTML(16) = "H<sub>2</sub>O" !water without ()
    subgrname(16) = "(H2O)"             ;  subgrnameTeX(16) = "(H$_2$O)"                 ;  subgrnameHTML(16) = "(H<sub>2</sub>O)" !water 
    subgrname(17) = "(ACOH)"            ;  subgrnameTeX(17) = "(ACOH)"                   ;  subgrnameHTML(17) = "(ACOH)"
    subgrname(18) = "(CH3CO)"           ;  subgrnameTeX(18) = "(CH$_3$CO)"               ;  subgrnameHTML(18) = "(CH<sub>3</sub>CO)"
    subgrname(19) = "(CH2CO)"           ;  subgrnameTeX(19) = "(CH$_2$CO)"               ;  subgrnameHTML(19) = "(CH<sub>2</sub>CO)"
    subgrname(20) = "(CHO[aldehyde])"   ;  subgrnameTeX(20) = "(CHO[aldehyde])"          ;  subgrnameHTML(20) = "(CHO[aldehyde])"
    subgrname(21) = "(CH3COO)"          ;  subgrnameTeX(21) = "(CH$_3$COO)"              ;  subgrnameHTML(21) = "(CH<sub>3</sub>COO)"
    subgrname(22) = "(CH2COO)"          ;  subgrnameTeX(22) = "(CH$_2$COO)"              ;  subgrnameHTML(22) = "(CH<sub>2</sub>COO)"
    subgrname(24) = "(CH3O)"            ;  subgrnameTeX(24) = "(CH$_3$O)"                ;  subgrnameHTML(24) = "(CH<sub>3</sub>O)"
    subgrname(25) = "(CH2O)"            ;  subgrnameTeX(25) = "(CH$_2$O)"                ;  subgrnameHTML(25) = "(CH<sub>2</sub>O)"
    subgrname(26) = "(CHO[ether])"      ;  subgrnameTeX(26) = "(CHO[ether])"             ;  subgrnameHTML(26) = "(CHO[ether])"
    subgrname(27) = "(THF[CH2O])"       ;  subgrnameTeX(27) = "(THF[CH$_2$O])"           ;  subgrnameHTML(27) = "(THF[CH<sub>2</sub>O])" !Tetrahydrofuran group (and molecule)
    subgrname(137) = "(COOH)"           ;  subgrnameTeX(137) = "(COOH)"                  ;  subgrnameHTML(137) = "(COOH)"
    subgrname(42) = "(COOH)"            ;  subgrnameTeX(42) = "(COOH)"                   ;  subgrnameHTML(42) = "(COOH)"
    subgrname(43) = "(HCOOH)"           ;  subgrnameTeX(43) = "(HCOOH)"                  ;  subgrnameHTML(43) = "(HCOOH)"
    subgrname(141) ="(CH3[alc])"        ;  subgrnameTeX(141) ="(CH$_3$$^{[alc]}$)"       ;  subgrnameHTML(141) ="(CH<sub>3</sub><sup>[alc]</sup>)"
    subgrname(142) ="(CH2[alc])"        ;  subgrnameTeX(142) ="(CH$_2$$^{[alc]}$)"       ;  subgrnameHTML(142) ="(CH<sub>2</sub><sup>[alc]</sup>)"
    subgrname(143) ="(CH[alc])"         ;  subgrnameTeX(143) ="(CH$^{[alc]}$)"           ;  subgrnameHTML(143) ="(CH<sup>[alc]</sup>)"
    subgrname(144) ="(C[alc])"          ;  subgrnameTeX(144) ="(C$^{[alc]}$)"            ;  subgrnameHTML(144) ="(C<sup>[alc]</sup>)"
    subgrname(145) ="(CH3[alc-tail])"   ;  subgrnameTeX(145) ="(CH$_3$$^{[alc-tail]}$)"  ;  subgrnameHTML(145) ="(CH<sub>3</sub><sup>[alc-tail]</sup>)"
    subgrname(146) ="(CH2[alc-tail])"   ;  subgrnameTeX(146) ="(CH$_2$$^{[alc-tail]}$)"  ;  subgrnameHTML(146) ="(CH<sub>2</sub><sup>[alc-tail]</sup>)"
    subgrname(147) ="(CH[alc-tail])"    ;  subgrnameTeX(147) ="(CH$^{[alc-tail]}$)"      ;  subgrnameHTML(147) ="(CH<sup>[alc-tail]</sup>)"
    subgrname(148) ="(C[alc-tail])"     ;  subgrnameTeX(148) ="(C$^{[alc-tail]}$)"       ;  subgrnameHTML(148) ="(C<sup>[alc-tail]</sup>)"
    subgrname(149) ="(CH3[OH])"         ;  subgrnameTeX(149) ="(CH$_3$$^{[OH]}$)"        ;  subgrnameHTML(149) ="(CH<sub>3</sub><sup>[OH]</sup>)"
    subgrname(150) ="(CH2[OH])"         ;  subgrnameTeX(150) ="(CH$_2$$^{[OH]}$)"        ;  subgrnameHTML(150) ="(CH<sub>2</sub><sup>[OH]</sup>)"
    subgrname(151) ="(CH[OH])"          ;  subgrnameTeX(151) ="(CH$^{[OH]}$)"            ;  subgrnameHTML(151) ="(CH<sup>[OH]</sup>)"
    subgrname(152) ="(C[OH])"           ;  subgrnameTeX(152) ="(C$^{[OH]}$)"             ;  subgrnameHTML(152) ="(C<sup>[OH]</sup>)"
    subgrname(154) = "(CH2OCH2[PEG])";  subgrnameTeX(154) ="(CH$_2$OCH$_2$[PEG])";  subgrnameHTML(154) ="(CH<sub>2</sub>$OCH<sub>2</sub>[PEG])" !special oxyethylene group of Poly(ethylene glycols) = Poly(oxyethylene).
    !peroxides and organonitrates; [perox] indicates that it contains a peroxide group:
    subgrname(155) ="(CH2ONO2)"         ;  subgrnameTeX(155) ="(CH$_2$ONO$_2$)"          ;  subgrnameHTML(155) ="(CH<sub>2</sub>ONO<sub>2</sub>)"
    subgrname(156) ="(CHONO2)"          ;  subgrnameTeX(156) ="(CHONO$_2$)"              ;  subgrnameHTML(156) ="(CHONO<sub>2</sub>)"
    subgrname(157) ="(CONO2)"           ;  subgrnameTeX(157) ="(CONO$_2$)"               ;  subgrnameHTML(157) ="(CONO<sub>2</sub>)"
    subgrname(158) ="(CH2OOH[perox])"   ;  subgrnameTeX(158) ="(CH$_2$OOH[perox])"       ;  subgrnameHTML(158) ="(CH<sub>2</sub>OOH[perox])"
    subgrname(159) ="(CHOOH[perox])"    ;  subgrnameTeX(159) ="(CHOOH[perox])"           ;  subgrnameHTML(159) ="(CHOOH[perox])"
    subgrname(160) ="(COOH[perox])"     ;  subgrnameTeX(160) ="(COOH[perox])"            ;  subgrnameHTML(160) ="(COOH[perox])"
    subgrname(161) ="(C(=O)OOH[perox])" ;  subgrnameTeX(161) ="(C(=O)OOH[perox])"        ;  subgrnameHTML(161) ="(C(=O)OOH[perox])"
    subgrname(162) ="(CH3OOCH3[perox])" ;  subgrnameTeX(162) ="(CH$_3$OOCH$_3$[perox])"  ;  subgrnameHTML(162) ="(CH<sub>3</sub>OOCH<sub>3</sub>[perox])"
    subgrname(163) ="(CH3OOCH2[perox])" ;  subgrnameTeX(163) ="(CH$_3$OOCH$_2$[perox])"  ;  subgrnameHTML(163) ="(CH<sub>3</sub>OOCH<sub>2</sub>[perox])"
    subgrname(164) ="(CH3OOCH[perox])"  ;  subgrnameTeX(164) ="(CH$_3$OOCH[perox])"      ;  subgrnameHTML(164) ="(CH<sub>3</sub>OOCH[perox])"
    subgrname(165) ="(CH3OOC[perox])"   ;  subgrnameTeX(165) ="(CH$_3$OOC[perox])"       ;  subgrnameHTML(165) ="(CH<sub>3</sub>OOC[perox])"
    subgrname(166) ="(CH2OOCH2[perox])" ;  subgrnameTeX(166) ="(CH$_2$OOCH$_2$[perox])"  ;  subgrnameHTML(166) ="(CH<sub>2</sub>OOCH<sub>2</sub>[perox])"
    subgrname(167) ="(CH2OOCH[perox])"  ;  subgrnameTeX(167) ="(CH$_2$OOCH[perox])"      ;  subgrnameHTML(167) ="(CH<sub>2</sub>OOCH[perox])"
    subgrname(168) ="(CH2OOC[perox])"   ;  subgrnameTeX(168) ="(CH$_2$OOC[perox])"       ;  subgrnameHTML(168) ="(CH<sub>2</sub>OOC[perox])"
    subgrname(169) ="(CHOOCH[perox])"   ;  subgrnameTeX(169) ="(CHOOCH[perox])"          ;  subgrnameHTML(169) ="(CHOOCH[perox])"
    subgrname(170) ="(CHOOC[perox])"    ;  subgrnameTeX(170) ="(CHOOC[perox])"           ;  subgrnameHTML(170) ="(CHOOC[perox])"
    subgrname(171) ="(COOC[perox])"     ;  subgrnameTeX(171) ="(COOC[perox])"            ;  subgrnameHTML(171) ="(COOC[perox])"
    subgrname(172) ="(C(=O)OONO2[perox])";  subgrnameTeX(172) ="(C(=O)OONO$_2$[perox])"  ;  subgrnameHTML(172) ="(C(=O)OONO<sub>2</sub>[perox])"
    

    !list of subgroup names of inorganic ions:
    subgrname(201) = "(Li+)"     ;  subgrnameTeX(201) = "(Li$^+$)"           ;  subgrnameHTML(201) = "(Li<sup>+</sup>)"
    subgrname(202) = "(Na+)"     ;  subgrnameTeX(202) = "(Na$^+$)"           ;  subgrnameHTML(202) = "(Na<sup>+</sup>)"
    subgrname(203) = "(K+)"      ;  subgrnameTeX(203) = "(K$^+$)"            ;  subgrnameHTML(203) = "(K<sup>+</sup>)"
    subgrname(204) = "(NH4+)"    ;  subgrnameTeX(204) = "(NH$_4$$^+$)"       ;  subgrnameHTML(204) = "(NH<sub>4</sub><sup>+</sup>)"
    subgrname(205) = "(H+)"      ;  subgrnameTeX(205) = "(H$^+$)"            ;  subgrnameHTML(205) = "(H<sup>+</sup>)"
    subgrname(221) = "(Ca++)"    ;  subgrnameTeX(221) = "(Ca$^{2+}$)"        ;  subgrnameHTML(221) = "(Ca<sup>2+</sup>)"
    subgrname(223) = "(Mg++)"    ;  subgrnameTeX(223) = "(Mg$^{2+}$)"        ;  subgrnameHTML(223) = "(Mg<sup>2+</sup>)"
    subgrname(241) = "(F-)"      ;  subgrnameTeX(241) = "(F$^-$)"            ;  subgrnameHTML(241) = "(F<sup>-</sup>)"  !this ion is not yet supported for calculations in AIOMFAC
    subgrname(242) = "(Cl-)"     ;  subgrnameTeX(242) = "(Cl$^-$)"           ;  subgrnameHTML(242) = "(Cl<sup>-</sup>)"
    subgrname(243) = "(Br-)"     ;  subgrnameTeX(243) = "(Br$^-$)"           ;  subgrnameHTML(243) = "(Br<sup>-</sup>)"
    subgrname(244) = "(I-)"      ;  subgrnameTeX(244) = "(I$^-$)"            ;  subgrnameHTML(244) = "(I<sup>-</sup>)"
    subgrname(245) = "(NO3-)"    ;  subgrnameTeX(245) = "(NO$_3$$^-$)"       ;  subgrnameHTML(245) = "(NO<sub>3</sub><sup>-</sup>)"
    subgrname(248) = "(HSO4-)"   ;  subgrnameTeX(248) = "(HSO$_4$$^-$)"      ;  subgrnameHTML(248) = "(HSO<sub>4</sub><sup>-</sup>)"
    subgrname(249) = "(CH3SO3-)" ;  subgrnameTeX(249) = "(CH$_3$SO$_3$$^-$)" ;  subgrnameHTML(249) = "(CH<sub>3</sub>SO<sub>3</sub><sup>-</sup>)"
    subgrname(261) = "(SO4--)"   ;  subgrnameTeX(261) = "(SO$_4$$^{2-}$)"    ;  subgrnameHTML(261) = "(SO<sub>4</sub><sup>2-</sup>)"

    END SUBROUTINE SubgroupNames
    !=================================================================================================================================
    
    
    !**********************************************************************************************************
    !*                                                                                                        *
    !*  Subroutine tabulating the character strings for the names of the different organic main groups        *
    !*                                                                                                        *   
    !*  (c) Andi Zuend, IACETH, ETH Zurich, 06/2013                                                           *
    !**********************************************************************************************************

    SUBROUTINE MaingroupNames()

    IMPLICIT NONE
    !...........................................................

    maingrname = "-?-" !initialize

    !list of neutral component main group names (standard ASCII formatting):
    maingrname(01) = "(CHn)"
    maingrname(02) = "(C=C)"
    maingrname(03) = "(ACHn)"
    maingrname(04) = "(ACCHn)"
    maingrname(05) = "(OH[standard_UNIFAC])"
    maingrname(06) = "(CH3OH[methanol])"
    maingrname(07) = "(H2O)"
    maingrname(08) = "(ACOH)"
    maingrname(09) = "(CHnCO)"
    maingrname(10) = "(CHO[aldehyde])"
    maingrname(11) = "(CCOO)"
    maingrname(12) = "(HCOO[formate])"
    maingrname(13) = "(CHnO[ether])"
    maingrname(14) = "(CNH2)"
    maingrname(15) = "(CNH)"
    maingrname(16) = "((C)3N)"
    maingrname(17) = "(ACNH2)"
    maingrname(18) = "(PYRIDINE)"
    maingrname(19) = "(CCN[nitrile])"
    maingrname(20) = "(COOH[standard_UNIFAC])"
    maingrname(21) = "(CCl)"
    maingrname(22) = "(CCl2)"
    maingrname(23) = "(CCl3)"
    maingrname(24) = "(CCl4)"
    maingrname(25) = "(ACCl)"
    maingrname(26) = "(CNO2)"
    maingrname(27) = "(ACNO2)"
    maingrname(28) = "(CS2)"
    maingrname(29) = "(CH3SH)"
    maingrname(30) = "(FURFURAL)"
    maingrname(31) = "(DOH)"
    maingrname(32) = "(I)"
    maingrname(33) = "(BR)"
    maingrname(34) = "(C-=C[triple_bond])"
    maingrname(35) = "(DMSO)"
    maingrname(36) = "(ACRY)"
    maingrname(37) = "(ClCC)"
    maingrname(38) = "(ACF)"
    maingrname(39) = "(DMF)"
    maingrname(40) = "(CF2)"
    maingrname(41) = "(COO)"
    maingrname(42) = "(SIH2)"
    maingrname(43) = "(SIO)"
    maingrname(44) = "(NMP)"
    maingrname(45) = "(CClF)"
    maingrname(46) = "(CON)"
    maingrname(47) = "(OCCOH)"
    maingrname(48) = "(CH2S)"
    maingrname(49) = "(MORPHOLINE)"
    maingrname(50) = "(THIOPHENE)"
    !Inorganic ions (not further specified in UNIFAC/AIOMFAC main groups (since subgroup = main group)
    maingrname(51) = "(Inorg_Ions)"
    !Extension by Ming and Russell (2001)
    maingrname(52) = "(CHn[MingR_long-chain])"
    maingrname(53) = "(OH[MingR_long-chain])"
    maingrname(54) = "(COOH[MingR_long-chain])"
    maingrname(55) = "(CHnCO[MingR_long-chain])"
    maingrname(56) = "(CHn[MingR_monosaccharides])"
    maingrname(57) = "(CHnO[MingR_monosaccharides])"
    maingrname(58) = "(OH[MingR_monosaccharides])"
    maingrname(59) = "(CHn[MingR_hydroxyacids])"
    maingrname(60) = "(COOH[MingR_hydroxyacids])"
    maingrname(61) = "(OH[MingR_hydroxyacids])"
    maingrname(62) = "(CHn[MingR_diacids])"
    maingrname(63) = "(COOH[MingR_diacids])"
    !Extension by Peng et al. (2001):
    maingrname(64) = "(OH[Peng])"
    maingrname(65) = "(COOH)" !this is the one now used as the standard COOH group in AIOMFAC (but not standard UNIFAC)
    !Extension by Marcolli and Peter (2005):
    maingrname(66) = "(CHn[alc])"
    maingrname(67) = "(CHn[alc-tail])"
    maingrname(68) = "(CHn[OH])"
    maingrname(69) = "(OH)"
    !Extension by A. Zuend
    maingrname(70) = "(CH2OCH2[PEG])"
    !Extension by Compernolle et al. (2009)
    maingrname(71) = "(CHnONO2)"
    maingrname(72) = "(CHnOOH[perox])"
    maingrname(73) = "(C(=O)OOH[perox])"
    maingrname(74) = "(CHnOOCHm[perox])"
    maingrname(75) = "(C(=O)OONO2[perox])"

    END SUBROUTINE MaingroupNames
    !=================================================================================================================================
    
    
    !**********************************************************************************************************
    !*                                                                                                        *
    !*  Subroutine to set the character strings for the different components / species in a mixture           *
    !*  composed of the names of different subgroups (using subroutine 'SubgroupNames').                      *
    !*                                                                                                        *   
    !*              (c) Andi Zuend, IACETH, ETH Zurich, 2009                                                  *
    !*              Div. Chem. Engineering, California Institute of Technology, 2009 - 2012                   *
    !**********************************************************************************************************

    SUBROUTINE cpsubgrstring() !compsubgroups, compsubgroupsTeX as output 

    USE ModSystemProp, ONLY : nindcomp, nneutral, nelectrol, ITAB_dimflip, compsubgroups, compsubgroupsTeX, &
        & compsubgroupsHTML, ElectComps, ElectNues

    IMPLICIT NONE

    !local vars:
    INTEGER(4) :: i, j, k, el
    CHARACTER(LEN=4) :: cn
    !...........................................................
    
    IF (ALLOCATED(compsubgroups)) THEN
        DEALLOCATE(compsubgroups, compsubgroupsTeX, compsubgroupsHTML)
    ENDIF
    ALLOCATE( compsubgroups(nindcomp), compsubgroupsTeX(nindcomp), compsubgroupsHTML(nindcomp) )
    !initialize:
    compsubgroups = ""
    compsubgroupsTeX = ""
    compsubgroupsHTML = ""

    !subgroup string for neutral components
    DO i = 1,nneutral !loop over neutral components
        DO k = 1,152 !loop first over standard CHn subgroups and different types of special CHn subgroups for alcohols / polyols
            SELECT CASE(k)
            CASE(1:4,141:152) !CHn subgroups
                IF (ITAB_dimflip(k,i) > 0) THEN !subgroup is present
                    IF (ITAB_dimflip(k,i) > 1) THEN
                        WRITE(cn,'(I4)') ITAB_dimflip(k,i) !string for number of subgroups k
                        cn = ADJUSTL(cn) !adjust left and remove leading blanks
                        compsubgroups(i) = TRIM(compsubgroups(i))//TRIM(subgrname(k))//"_"//TRIM(cn) !add subgroup to string
                        compsubgroupsTeX(i) = TRIM(compsubgroupsTeX(i))//TRIM(subgrnameTeX(k))//"$_"//TRIM(cn)//"$"
                        compsubgroupsHTML(i) = TRIM(compsubgroupsHTML(i))//TRIM(subgrnameHTML(k))//"<sub>"//TRIM(cn)//"</sub>"
                    ELSE
                        compsubgroups(i) = TRIM(compsubgroups(i))//TRIM(subgrname(k))
                        compsubgroupsTeX(i) = TRIM(compsubgroupsTeX(i))//TRIM(subgrnameTeX(k))
                        compsubgroupsHTML(i) = TRIM(compsubgroupsHTML(i))//TRIM(subgrnameHTML(k))
                    ENDIF
                ENDIF
            CASE DEFAULT 
                CYCLE  !to omit other subgroups for now
            END SELECT
        ENDDO
        DO k = 5,200 !loop over the rest of implemented subgroups
            SELECT CASE(k)
            CASE(5:140,153:200) !non-CHn subgroups
                IF (ITAB_dimflip(k,i) > 0) THEN !subgroup is present
                    IF (ITAB_dimflip(k,i) > 1) THEN
                        WRITE(cn,'(I4)') ITAB_dimflip(k,i) !string for number of subgroups k
                        cn = ADJUSTL(cn) !adjust left and remove leading blanks
                        compsubgroups(i) = TRIM(compsubgroups(i))//TRIM(subgrname(k))//"_"//TRIM(cn) !add subgroup to string
                        compsubgroupsTeX(i) = TRIM(compsubgroupsTeX(i))//TRIM(subgrnameTeX(k))//"$_"//TRIM(cn)//"$"
                        compsubgroupsHTML(i) = TRIM(compsubgroupsHTML(i))//TRIM(subgrnameHTML(k))//"<sub>"//TRIM(cn)//"</sub>"
                    ELSE
                        compsubgroups(i) = TRIM(compsubgroups(i))//TRIM(subgrname(k))
                        compsubgroupsTeX(i) = TRIM(compsubgroupsTeX(i))//TRIM(subgrnameTeX(k))
                        compsubgroupsHTML(i) = TRIM(compsubgroupsHTML(i))//TRIM(subgrnameHTML(k))
                    ENDIF
                ENDIF
            CASE DEFAULT
                CYCLE !omit CHn subgroups here as they were considered in the previous loop
            END SELECT
        ENDDO
    ENDDO

    !subgroup string for electrolye units / ions
    DO el = 1,nelectrol !loop over electrolyte components
        i = el+nneutral
        k = ElectComps(el,1) !cation
        j = ElectComps(el,2) !anion
        !add cation
        WRITE(cn,'(I4)') ElectNues(el,1) !string for number of subgroups k
        IF (ElectNues(el,1) > 1) THEN
            cn = ADJUSTL(cn) !adjust left and remove leading blanks
            compsubgroups(i) = TRIM(compsubgroups(i))//TRIM(subgrname(k))//"_"//TRIM(cn) !add subgroup to string
            compsubgroupsTeX(i) = TRIM(compsubgroupsTeX(i))//TRIM(subgrnameTeX(k))//"$_"//TRIM(cn)//"$" !add subgroup to string
            compsubgroupsHTML(i) = TRIM(compsubgroupsHTML(i))//TRIM(subgrnameHTML(k))//"<sub>"//TRIM(cn)//"</sub>"
        ELSE
            compsubgroups(i) = TRIM(compsubgroups(i))//TRIM(subgrname(k))
            compsubgroupsTeX(i) = TRIM(compsubgroupsTeX(i))//TRIM(subgrnameTeX(k))
            compsubgroupsHTML(i) = TRIM(compsubgroupsHTML(i))//TRIM(subgrnameHTML(k))
        ENDIF
        !add anion
        WRITE(cn,'(I4)') ElectNues(el,2) !string for number of subgroups j
        IF (ElectNues(el,2) > 1) THEN
            !add cation:
            cn = ADJUSTL(cn) !adjust left and remove leading blanks
            compsubgroups(i) = TRIM(compsubgroups(i))//TRIM(subgrname(j))//"_"//TRIM(cn) !add subgroup to string
            compsubgroupsTeX(i) = TRIM(compsubgroupsTeX(i))//TRIM(subgrnameTeX(j))//"$_"//TRIM(cn)//"$" !add subgroup to string
            compsubgroupsHTML(i) = TRIM(compsubgroupsHTML(i))//TRIM(subgrnameHTML(j))//"<sub>"//TRIM(cn)//"</sub>"
        ELSE
            compsubgroups(i) = TRIM(compsubgroups(i))//TRIM(subgrname(j))
            compsubgroupsTeX(i) = TRIM(compsubgroupsTeX(i))//TRIM(subgrnameTeX(j))
            compsubgroupsHTML(i) = TRIM(compsubgroupsHTML(i))//TRIM(subgrnameHTML(j))
        ENDIF
    ENDDO !i

    END SUBROUTINE cpsubgrstring
    !=================================================================================================================================
    
    
    !****************************************************************************************
    !*   :: Purpose ::                                                                      *
    !*   Subroutine to calculate the sum of carbons, hydrogens, and oxygens in a            * 
    !*   component of a system containing organics. Also includes the calculation of O:C    *
    !*   and H:C ratios of the pure components.                                             *
    !*                                                                                      *
    !*   :: Authors & Copyright ::                                                          *
    !*   Natalie Gervasi, Andi Zuend,                                                       *
    !*   Dept. Atmospheric and Oceanic Sciences, McGill University                          *
    !*                                                                                      *   
    !*   -> created:        2012                                                            *
    !*   -> latest changes: 2018/09/14                                                      * 
    !*                                                                                      *                                   
    !****************************************************************************************
    PURE SUBROUTINE O2C_H2C_component(ind, compC, compH, compO, O2C, H2C)

    USE ModSystemProp, ONLY : ITAB_dimflip, SolvSubs, NGN

    IMPLICIT NONE
    !..................................
    !interface input:
    INTEGER(4),INTENT(IN) :: ind  !the component index number in current mixture (e.g. index location of component in ITAB_dimflip)
    REAL(8),INTENT(OUT) :: compC, compH, compO, O2C, H2C
    !local variables:
    INTEGER(4) :: isub, k, nsub
    !..................................    
    
    !(1) determine number of oxygen, hydrogen and carbon for a given compound
    compO = 0.0D0
    compH = 0.0D0
    compC = 0.0D0
    !loop over subgroups to count the O, H, and C atoms:
    DO k = 1,NGN !loop over organic subgroups (SolvSubs excl. water)
        isub = SolvSubs(k) !subgoup
        IF (isub /= 16) THEN !exclude water (= subgroup 16) from the calculations
            nsub = ITAB_dimflip(isub,ind)
            IF (nsub > 0) THEN !subgroup is present
                compO = compO +REAL(nsub*subgO(isub), KIND=8)
                compH = compH +REAL(nsub*subgH(isub), KIND=8)
                compC = compC +REAL(nsub*subgC(isub), KIND=8)
            ENDIF
        ENDIF
    ENDDO
    
    !(2) compute O:C and H:C of this pure component:
    IF (compC > 0.0D0) THEN
        O2C = compO/compC
        H2C = compH/compC
    ELSE !O:C and H:C are undefined, labeled as negative numbers.
        O2C = -77.77777D0
        H2C = -77.77777D0
    ENDIF

    END SUBROUTINE O2C_H2C_component
    !=================================================================================================================================
    
    
    !****************************************************************************************
    !*                                                                                      *
    !*  Subroutine to calculate the average (organic) elemental O:C and H:C ratios of a     *
    !*  given mixture.                                                                      *
    !*                                                                                      *
    !*   :: Author & Copyright ::                                                           *
    !*   Andi Zuend,                                                                        *
    !*   Dept. Chem. Engineering, California Institute of Technology (2009 - 2012)          *
    !*   Dept. Atmospheric and Oceanic Sciences, McGill University                          *
    !*                                                                                      *
    !*   -> created:        2012                                                            *
    !*   -> latest changes: 2018/09/14                                                      *
    !*                                                                                      *
    !****************************************************************************************
    PURE SUBROUTINE OtoCandHtoCmix(n, x, OtoCorgmix, HtoCorgmix)

    USE ModSystemProp, ONLY : waterpresent

    IMPLICIT NONE
    !interface variables:
    INTEGER(4),INTENT(IN) :: n           !number of species in mixture (potentially with electrolytes dissociated into ions)
    REAL(8),DIMENSION(n),INTENT(IN) :: x !mole fractions of the species in the mixture
    REAL(8),INTENT(OUT) :: OtoCorgmix, HtoCorgmix
    !local variables:
    INTEGER(4) :: ind, istart
    REAL(8) :: compO, compH, compC, sumO, sumH, sumC, O2C, H2C
    !...........................................................
  
    sumC = 0.0D0
    sumH = 0.0D0
    sumO = 0.0D0
    !loop over organic components and sum up the contributions to total oxygen, carbon and hydrogen atoms for given mole fractions in mixture:
    IF (waterpresent) THEN
        istart = 2
    ELSE
        istart = 1
    ENDIF
    DO ind = istart,n 
        CALL O2C_H2C_component(ind, compC, compH, compO, O2C, H2C)
        sumC = sumC + x(ind)*compC
        sumH = sumH + x(ind)*compH
        sumO = sumO + x(ind)*compO
    ENDDO

    !calculate organic O:C and H:C ratios for the present mixture:
    IF (sumC > 0.0D0) THEN !the ratios are defined
        OtoCorgmix = sumO/sumC 
        HtoCorgmix = sumH/sumC
    ELSE
        OtoCorgmix = -77.77777D0  !indicate O:C not defined 
        HtoCorgmix = -77.77777D0  !indicate H:C not defined
    ENDIF

    END SUBROUTINE OtoCandHtoCmix
!==========================================================================================================================

END MODULE ModSubgroupProp