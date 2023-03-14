*&---------------------------------------------------------------------*
*& Report ZW_TEST_ALV01_ALV_MERGE2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zw_test_alv01_alv_merge2.


TYPE-POOLS: slis.
  DATA: lt_fields TYPE slis_t_fieldcat_alv,
        wa_fields TYPE slis_fieldcat_alv,
        wa_layout TYPE slis_layout_alv.

DATA:BEGIN OF s_tabi occurs 0,
        vkorg     LIKE vbak-vkorg,
        name1     LIKE kna1-name1,
        vbeln     LIKE vbak-vbeln,
        audat     LIKE vbak-audat,
        vbeln_d   LIKE likp-vbeln,
        wadat_ist LIKE likp-wadat_ist,
        vbeln_b   LIKE vbrk-vbeln,
        fkdat     LIKE vbrk-fkdat,
        gbstk     LIKE vbuk-gbstk,
END OF s_tabi.

DATA: tabi LIKE standard table of s_tabi.
DATA: I_REPID             LIKE SY-REPID.

I_REPID = SY-REPID.

CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_program_name         = I_REPID
      i_internal_tabname     = 'S_TABI'
      i_inclname             = I_REPID
    CHANGING
      ct_fieldcat            = LT_FIELDS
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
   EXPORTING
     i_callback_program                = sy-repid
     i_callback_pf_status_set          = 'SET_PF_STATUS'
     i_callback_user_command           = 'USER_COMMAND'
     is_layout                         = wa_layout
     it_fieldcat                       = LT_FIELDS
    TABLES
      t_outtab                          = TABI.
