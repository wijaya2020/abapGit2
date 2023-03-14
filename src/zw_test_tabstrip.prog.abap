*&---------------------------------------------------------------------*
*& Report ZW_TEST_TABSTRIP
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZW_TEST_TABSTRIP.


TABLES : ZPU110_017_RESTO.

data : gs_resto type ZPU110_017_RESTO.

SELECTION-SCREEN begin of BLOCK blk1.
  PARAMETERS : p_restid TYPE ZPU110_017_RESTO-restoid.
SELECTION-SCREEN END OF BLOCK blk1.


START-OF-SELECTION.
  select single *
    FROM ZPU110_017_RESTO
    into CORRESPONDING FIELDS OF gs_RESTO
    WHERE restoid = p_restid.

   call SCREEN 100.
end-of-SELECTION.
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE STATUS_0100 OUTPUT.
 SET PF-STATUS 'PF1'.
 SET TITLEBAR 'T1'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0100 INPUT.
  CASE sy-ucomm.
    when 'BACK' OR 'EXIT' OR 'CANCEL'.
      SET SCREEN 0.
   WHEN 'SAVE'.
     PERFORM SAVE.

   ENDCASE.

   CLEAR : SY-UCOMM.

ENDMODULE.

*&SPWIZARD: FUNCTION CODES FOR TABSTRIP 'TS1'
CONSTANTS: BEGIN OF C_TS1,
             TAB1 LIKE SY-UCOMM VALUE 'TS1_FC1',
             TAB2 LIKE SY-UCOMM VALUE 'TS1_FC2',
             TAB3 LIKE SY-UCOMM VALUE 'TS1_FC3',
             TAB4 LIKE SY-UCOMM VALUE 'TS1_FC4',
           END OF C_TS1.
*&SPWIZARD: DATA FOR TABSTRIP 'TS1'
CONTROLS:  TS1 TYPE TABSTRIP.
DATA:      BEGIN OF G_TS1,
             SUBSCREEN   LIKE SY-DYNNR,
             PROG        LIKE SY-REPID VALUE 'ZW_TEST_TABSTRIP',
             PRESSED_TAB LIKE SY-UCOMM VALUE C_TS1-TAB1,
           END OF G_TS1.
DATA:      OK_CODE LIKE SY-UCOMM.

*&SPWIZARD: OUTPUT MODULE FOR TS 'TS1'. DO NOT CHANGE THIS LINE!
*&SPWIZARD: SETS ACTIVE TAB
MODULE TS1_ACTIVE_TAB_SET OUTPUT.
  TS1-ACTIVETAB = G_TS1-PRESSED_TAB.
  CASE G_TS1-PRESSED_TAB.
    WHEN C_TS1-TAB1.
      G_TS1-SUBSCREEN = '0101'.
    WHEN C_TS1-TAB2.
      G_TS1-SUBSCREEN = '0102'.
    WHEN C_TS1-TAB3.
      G_TS1-SUBSCREEN = '0103'.
    WHEN C_TS1-TAB4.
      G_TS1-SUBSCREEN = '0104'.
    WHEN OTHERS.
*&SPWIZARD:      DO NOTHING
  ENDCASE.
ENDMODULE.

*&SPWIZARD: INPUT MODULE FOR TS 'TS1'. DO NOT CHANGE THIS LINE!
*&SPWIZARD: GETS ACTIVE TAB
MODULE TS1_ACTIVE_TAB_GET INPUT.
  OK_CODE = SY-UCOMM.
  CASE OK_CODE.
    WHEN C_TS1-TAB1.
      G_TS1-PRESSED_TAB = C_TS1-TAB1.
    WHEN C_TS1-TAB2.
      G_TS1-PRESSED_TAB = C_TS1-TAB2.
    WHEN C_TS1-TAB3.
      G_TS1-PRESSED_TAB = C_TS1-TAB3.
    WHEN C_TS1-TAB4.
      G_TS1-PRESSED_TAB = C_TS1-TAB4.
    WHEN OTHERS.
*&SPWIZARD:      DO NOTHING
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Form SAVE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SAVE .
  GS_RESTO-restoid = p_RESTID.
  MODIFY ZPU110_017_RESTO FROM GS_RESTO.
  MESSAGE 'SAVE SUCCESS' TYPE 'S'.
  SET SCREEN 0.
ENDFORM.
