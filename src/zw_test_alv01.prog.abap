*&---------------------------------------------------------------------*
*& Report ZW_TEST_ALV01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zw_test_alv01.

*TABLES : spfli.

TYPE-POOLS : slis.

DATA : lt_fieldcat   TYPE slis_t_fieldcat_alv,
       ls_fieldcat   TYPE slis_fieldcat_alv,

       ls_layout     TYPE slis_layout_alv,
       lt_event      TYPE slis_t_event,
       ls_event      TYPE slis_alv_event,

       lt_sort       TYPE slis_t_sortinfo_alv,
       wa_sort       TYPE slis_sortinfo_alv,

       lt_listheader TYPE slis_t_listheader,
       wa_listheader TYPE slis_listheader,

       pgm           LIKE sy-repid.


TYPES : BEGIN OF gs_spfli,
          carrid   TYPE spfli-carrid,
          cityfrom TYPE spfli-cityfrom,
          cityto   TYPE spfli-cityto,
        END OF gs_spfli.


DATA : gwa_spfli TYPE          gs_spfli,
       gt_spfli  TYPE TABLE OF gs_spfli.

*&---------------------------------------------------------------------*
*get data
*&---------------------------------------------------------------------*

SELECT *
  FROM spfli
*  INTO TABLE gt_spfli.
   INTO CORRESPONDING FIELDS OF TABLE gt_spfli.

*&---------------------------------------------------------------------*
*setting header
*&---------------------------------------------------------------------*
wa_listheader-typ ='H'.
wa_listheader-info ='Demo Header'.
APPEND wa_listheader TO lt_listheader.

wa_listheader-typ ='S'.
wa_listheader-info ='by wijaya'.
APPEND wa_listheader TO lt_listheader.

*&---------------------------------------------------------------------*
* setting alv layout
*&---------------------------------------------------------------------*
ls_layout-zebra             = 'X'.
ls_layout-window_titlebar   = 'Demo ALV'.
ls_layout-detail_popup      = 'X'.
ls_layout-detail_titlebar   = 'by qinghao'.
ls_layout-zebra             = 'X'.
ls_layout-colwidth_optimize = 'X'.

*&---------------------------------------------------------------------*
* setting fieldcat
*&---------------------------------------------------------------------*
ls_fieldcat-col_pos     = 1.
ls_fieldcat-key         = 'X'.
ls_fieldcat-fieldname   = 'carrid'.
ls_fieldcat-datatype    = 'char'.   "char 3
ls_fieldcat-seltext_s   = 'carrid'.
ls_fieldcat-seltext_m   = 'carr. id'.
ls_fieldcat-seltext_l   = 'airline code'.
APPEND ls_fieldcat TO lt_fieldcat.

CLEAR ls_fieldcat.
ls_fieldcat-col_pos     = 2.
ls_fieldcat-key         = ''.
ls_fieldcat-fieldname   = 'cityfrom'.
ls_fieldcat-datatype    = 'char'.    "char 20
ls_fieldcat-seltext_s   = 'cityfrom'.
ls_fieldcat-seltext_m   = 'cityfrom'.
ls_fieldcat-seltext_l   = 'departure city'.
APPEND ls_fieldcat TO lt_fieldcat.

CLEAR ls_fieldcat.
ls_fieldcat-col_pos     = 3.
ls_fieldcat-key         = ''.
ls_fieldcat-fieldname   = 'cityto'.
ls_fieldcat-datatype    = 'char'.    "char 20
ls_fieldcat-seltext_s   = 'cityto'.
ls_fieldcat-seltext_m   = 'cityto'.
ls_fieldcat-seltext_l   = 'arrival city'.
APPEND ls_fieldcat TO lt_fieldcat.

*&---------------------------------------------------------------------*
* setting event
*&---------------------------------------------------------------------*
ls_event-name = 'USER_COMMAND'.
ls_event-form = 'FORM_USER_COMMAND'.
APPEND ls_event TO lt_event.

CLEAR ls_event.
ls_event-name = 'TOP_OF_PAGE'.
ls_event-form = 'FORM_TOP_OF_PAGE'.
APPEND ls_event TO lt_event.

CLEAR ls_event.
ls_event-name = 'PF_STATUS_SET'.
ls_event-form = 'FORM_PF_STATUS_SET'.
APPEND ls_event TO lt_event.

*&---------------------------------------------------------------------*
* sort
*&---------------------------------------------------------------------*
wa_sort-fieldname = 'CARRID'.
wa_sort-down      = 'X'.
APPEND wa_sort TO lt_sort.
CLEAR wa_sort.

wa_sort-fieldname = 'CITYFROM'.
wa_sort-down      = 'X'.
APPEND wa_sort TO lt_sort.
CLEAR wa_sort.

*&---------------------------------------------------------------------*
* program name
*&---------------------------------------------------------------------*
pgm = sy-repid.

*&---------------------------------------------------------------------*
* display alv
*&---------------------------------------------------------------------*
CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
*CALL FUNCTION 'REUSE_ALV_LIST_DISPLAY'
  EXPORTING
*   I_INTERFACE_CHECK        = ' '
*   I_BYPASSING_BUFFER       = ' '
*   I_BUFFER_ACTIVE          = ' '
    i_callback_program       = pgm
    i_callback_pf_status_set = 'PF_STATUS_SET'
    i_callback_user_command  = 'USER_COMMAND'
    i_callback_top_of_page   = 'TOP_OF_PAGE'
*   I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*   I_CALLBACK_HTML_END_OF_LIST       = ' '
*   I_STRUCTURE_NAME         =
*   I_BACKGROUND_ID          = ' '
*   I_GRID_TITLE             =
*   I_GRID_SETTINGS          =
    is_layout                = ls_layout
    it_fieldcat              = lt_fieldcat
*   IT_EXCLUDING             =
*   IT_SPECIAL_GROUPS        =
*    it_sort                  = lt_sort    "error if i run this, why?
*   IT_FILTER                =
*   IS_SEL_HIDE              =
*   I_DEFAULT                = 'X'
*   I_SAVE                   = ' '
*   IS_VARIANT               =
    it_events                = lt_event
*   IT_EVENT_EXIT            =
*   IS_PRINT                 =
*   IS_REPREP_ID             =
*   I_SCREEN_START_COLUMN    = 0
*   I_SCREEN_START_LINE      = 0
*   I_SCREEN_END_COLUMN      = 0
*   I_SCREEN_END_LINE        = 0
*   I_HTML_HEIGHT_TOP        = 0
*   I_HTML_HEIGHT_END        = 0
*   IT_ALV_GRAPHICS          =
*   IT_HYPERLINK             =
*   IT_ADD_FIELDCAT          =
*   IT_EXCEPT_QINFO          =
*   IR_SALV_FULLSCREEN_ADAPTER        =
*   O_PREVIOUS_SRAL_HANDLER  =
* IMPORTING
*   E_EXIT_CAUSED_BY_CALLER  =
*   ES_EXIT_CAUSED_BY_USER   =
  TABLES
    t_outtab                 = gt_spfli
  EXCEPTIONS
    program_error            = 1
    OTHERS                   = 2.
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.


FORM form_user_command USING r_ucomm LIKE sy-ucomm
      rs_selfield TYPE slis_selfield.
  IF r_ucomm ='ZADD'.
    MESSAGE 'you press add button' TYPE 'I'.
  ELSEIF r_ucomm ='ZCAS'.
    MESSAGE 'you press casper button' TYPE 'I'.
  ENDIF.
ENDFORM.

FORM form_pf_status_set USING rt_extab TYPE slis_t_extab.
  SET PF-STATUS 'STANDARD'.
ENDFORM.

FORM form_top_of_page.
  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = lt_listheader
     I_LOGO             = 'ZW'   "object key name
*     I_END_OF_LIST_GRID =
*     I_ALV_FORM         =
    .
ENDFORM.
