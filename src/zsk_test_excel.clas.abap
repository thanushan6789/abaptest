CLASS zsk_test_excel DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: if_oo_adt_classrun.
    METHODS: get_data RETURNING VALUE(rv_subrc) TYPE sy-subrc,
      get_text EXPORTING ev_out TYPE zsk_char128.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zsk_test_excel IMPLEMENTATION.
  METHOD get_text.
    TYPES:
      BEGIN OF ts_itab,
        text(128) TYPE c,
      END OF ts_itab,

      tt_itab TYPE STANDARD TABLE OF ts_itab WITH DEFAULT KEY.

    DATA lt_itab TYPE tt_itab.
    DATA: lt_itab_str TYPE TABLE OF string.

    SELECT SINGLE attachment FROM zsk_invoice
    WHERE invoice EQ '0000001003'
    INTO @DATA(lv_content).

    DATA(lv_string) = xco_cp=>xstring( lv_content
    )->as_string( xco_cp_character=>code_page->utf_8
    )->value.

    SELECT SINGLE attachment FROM zsk_invoice
    WHERE invoice EQ '0000001005'
    INTO @DATA(lv_content1).

    DATA(lv_string1) = xco_cp=>xstring( lv_content1
    )->as_string( xco_cp_character=>code_page->utf_8
    )->value.

    DATA(lv_base64_encoding) = xco_cp=>xstring( lv_content1
  )->as_string( xco_cp_binary=>text_encoding->base64
  )->value.

    "DATA(lv_csv_data) = cl_abap_conv_codepage=>create_in( )->convert( lv_content ).
    "DATA lv_xstring TYPE xstring.

    " LV_BASE64_ENCODING is of type STRING and contains the Base64 encoded version
    " of LV_XSTRING.
    ""DATA(lv_base64_encoding) = xco_cp=>xstring( lv_xstring
    "" )->as_string( xco_cp_binary=>text_encoding->base64 )->value.

    " LV_ORIGINAL_XSTRING is of type XSTRING and contains the binary data encoded
    " in LV_BASE64_ENCODING
    "DATA(lv_original_xstring) = xco_cp=>string( lv_base64_encoding
    ")->as_xstring( xco_cp_binary=>text_encoding->base64
    " )->value.
    " cl_abap_char_utilites=>horizontal_tab
    " \t => tab delimited \r\n => new line
    SPLIT lv_string AT '\t' INTO TABLE lt_itab.
    LOOP AT lt_itab ASSIGNING FIELD-SYMBOL(<fs_itab>).
      IF <fs_itab>-text+0(3) EQ 'HDR'.
      ENDIF.
      ev_out = <fs_itab>-text+0(3).
    ENDLOOP.

    DATA(lo_string) = xco_cp=>string( lv_string1 ).

    " LV_SUBSTRING_1 = DEF
    DATA(lv_substring_1) = lo_string->from( 4 )->value.
    " LV_SUBSTRING_5 = CD
    DATA(lv_substring_5) = lo_string->from( 3 )->to( 2 )->value.

  ENDMETHOD.
  METHOD get_data.
    DATA lv_file_content TYPE xstring.
    " A selection pattern that was obtained via XCO_CP_XLSX_SELECTION=>PATTERN_BUILDER.
    "DATA lo_selection_pattern TYPE REF TO if_xco_xlsx_slc_pattern.

    " The read access to the worksheet.
    "DATA lo_worksheet TYPE REF TO if_xco_xlsx_ra_worksheet.

    " The type definition resembling the structure of the rows in the worksheet selection.
    TYPES:
      BEGIN OF ts_row,
        name        TYPE string,
        description TYPE string,
        comp        TYPE string,
        category    TYPE string,
      END OF ts_row,

      tt_row TYPE STANDARD TABLE OF ts_row WITH DEFAULT KEY.

    DATA lt_rows TYPE tt_row.
    rv_subrc = 4.

    SELECT SINGLE attachment FROM zsk_invoice
    WHERE invoice EQ '0000001002'
    INTO @DATA(lv_file).

    lv_file_content = lv_file.


    " LV_FILE_CONTENT must be populated with the complete file content of the .XLSX file
    " whose content shall be processed programmatically.

    DATA(lo_read_access) = xco_cp_xlsx=>document->for_file_content( lv_file_content
      )->read_access( ).

    DATA(lo_selection_pattern) = xco_cp_xlsx_selection=>pattern_builder->simple_from_to( )->get_pattern( ).


    " Read access for the worksheet with name INVOICES.
    DATA(lo_worksheet) = lo_read_access->get_workbook(
     )->worksheet->for_name( 'Sheet1' ).

    lo_worksheet->select( lo_selection_pattern
 )->row_stream(
 )->operation->write_to( REF #( lt_rows )
 )->if_xco_xlsx_ra_operation~execute( ).
    LOOP AT lt_rows ASSIGNING FIELD-SYMBOL(<fs_rows>) FROM 2.
      EXIT.
    ENDLOOP.
    IF  <fs_rows> IS ASSIGNED.
      rv_subrc = 0.
    ELSE.
      rv_subrc = 4.
    ENDIF.
  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.
    " DATA(lv_subrc) = get_data( ).
    "IF lv_subrc = 4.
    "out->write( 'Error' ).
    "ELSE.
    " out->write( 'Sucess' ).
    "ENDIF.

    get_text(  IMPORTING ev_out = DATA(lv_out) ).
    out->write( lv_out ).

  ENDMETHOD.
ENDCLASS.


