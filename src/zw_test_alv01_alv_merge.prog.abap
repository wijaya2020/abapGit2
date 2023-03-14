*&---------------------------------------------------------------------*
*& Report ZW_TEST_ALV01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zw_test_alv01_alv_merge.

TYPE-POOLS: slis.

DATA : lt_fieldcat TYPE slis_t_fieldcat_alv,
       ls_fieldcat TYPE slis_fieldcat_alv,
       ls_layout   TYPE slis_layout_alv.

DATA : BEGIN OF gs_spfli occurs 0,
          carrid   TYPE spfli-carrid,
          cityfrom TYPE spfli-cityfrom,
          cityto   TYPE spfli-cityto,
        END OF gs_spfli.


DATA : gt_spfli like STANDARD TABLE OF gs_spfli.


*get data

*SELECT *
*  FROM spfli
**  INTO TABLE gt_spfli.
*   INTO CORRESPONDING FIELDS OF TABLE gt_spfli.


CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
  EXPORTING
    i_program_name         = sy-repid
    i_internal_tabname     = 'GS_SPFLI'
*      i_structure_name    = 'gs_spfli'
    i_inclname             = sy-repid
changing
  ct_fieldcat              = lt_fieldcat
exceptions
  inconsistent_interface   = 1
  program_error            = 2
  others                   = 3.
IF sy-subrc <> 0.
  MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
ENDIF.

CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
  EXPORTING
    i_callback_program       = sy-repid
    i_callback_pf_status_set = 'SET_PF_STATUS'
    i_callback_user_command  = 'USER_COMMAND'
    is_layout                = ls_layout
    it_fieldcat              = lt_fieldcat
  TABLES
    t_outtab                 = gt_spfli.
