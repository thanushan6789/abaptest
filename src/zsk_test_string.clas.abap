CLASS zsk_test_string DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: if_oo_adt_classrun.
    METHODS: parse_data RETURNING VALUE(rv_string) TYPE string.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zsk_test_string IMPLEMENTATION.
  METHOD parse_data.
    TYPES: BEGIN OF ty_tab,
             data(2056) TYPE c,
           END OF ty_tab.
    DATA: lt_table TYPE TABLE OF ty_tab WITH DEFAULT KEY.
    CONSTANTS: lc_max TYPE i VALUE 10.
    DATA: lv_test_str TYPE string VALUE 'This is toagsjagsjasgjag veridhahdahdkahd jsagsjasajsgj'.
    DATA(lv_len) = strlen( lv_test_str ).
    DATA(lv_len_temp) = lv_len.
*    DATA(lv_substring_1) = lo_string->from( 1 )->value.
    DO.
      DATA(lo_string) = xco_cp=>string( lv_test_str ).
      DATA(lv_substring) = lo_string->to( lc_max )->value.
      APPEND lv_substring TO lt_table.
      SHIFT lv_test_str LEFT BY lc_max PLACES.
      lv_len_temp =  lv_len_temp - lc_max.
      IF  lv_len_temp <= 0.
        EXIT.
      ENDIF.
    ENDDO.
    IF lt_table[] IS NOT INITIAL.
      READ TABLE lt_table ASSIGNING FIELD-SYMBOL(<fs_tab>) INDEX 1.
      IF sy-subrc IS INITIAL.
        rv_string = <fs_tab>-data.
      ENDIF.
    ENDIF.
  ENDMETHOD.
  METHOD if_oo_adt_classrun~main.
    DATA(lv_string) = parse_data(  ).
  ENDMETHOD.
ENDCLASS.
