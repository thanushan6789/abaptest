CLASS LHC_RAP_TDAT_CTS DEFINITION FINAL.
  PUBLIC SECTION.
    CLASS-METHODS:
      GET
        RETURNING
          VALUE(RESULT) TYPE REF TO IF_MBC_CP_RAP_TABLE_CTS.

ENDCLASS.

CLASS LHC_RAP_TDAT_CTS IMPLEMENTATION.
  METHOD GET.
    result = mbc_cp_api=>rap_table_cts( table_entity_relations = VALUE #(
                                         ( entity = 'AcctAndPartner' table = 'ZSK_ACCT_PART' )
                                       ) ) ##NO_TEXT.
  ENDMETHOD.
ENDCLASS.
CLASS LHC_ZI_ACCTANDPARTNER_S DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_INSTANCE_FEATURES FOR INSTANCE FEATURES
        IMPORTING
          KEYS REQUEST requested_features FOR AcctAndPartnerAll
        RESULT result,
      SELECTCUSTOMIZINGTRANSPTREQ FOR MODIFY
        IMPORTING
          KEYS FOR ACTION AcctAndPartnerAll~SelectCustomizingTransptReq
        RESULT result,
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR AcctAndPartnerAll
        RESULT result.
ENDCLASS.

CLASS LHC_ZI_ACCTANDPARTNER_S IMPLEMENTATION.
  METHOD GET_INSTANCE_FEATURES.
    DATA: selecttransport_flag TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled,
          edit_flag            TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled.

    IF cl_bcfg_cd_reuse_api_factory=>get_cust_obj_service_instance(
        iv_objectname = 'ZSK_ACCT_PART'
        iv_objecttype = cl_bcfg_cd_reuse_api_factory=>simple_table )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    DATA(transport_service) = cl_bcfg_cd_reuse_api_factory=>get_transport_service_instance(
                                iv_objectname = 'ZSK_ACCT_PART'
                                iv_objecttype = cl_bcfg_cd_reuse_api_factory=>simple_table ).
    IF transport_service->is_transport_allowed( ) = abap_false.
      selecttransport_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    READ ENTITIES OF ZI_AcctAndPartner_S IN LOCAL MODE
    ENTITY AcctAndPartnerAll
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(all).
    IF all[ 1 ]-%IS_DRAFT = if_abap_behv=>mk-off.
      selecttransport_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result = VALUE #( (
               %TKY = all[ 1 ]-%TKY
               %ACTION-edit = edit_flag
               %ASSOC-_AcctAndPartner = edit_flag
               %ACTION-SelectCustomizingTransptReq = selecttransport_flag ) ).
  ENDMETHOD.
  METHOD SELECTCUSTOMIZINGTRANSPTREQ.
    MODIFY ENTITIES OF ZI_AcctAndPartner_S IN LOCAL MODE
      ENTITY AcctAndPartnerAll
        UPDATE FIELDS ( TransportRequestID HideTransport )
        WITH VALUE #( FOR key IN keys
                        ( %TKY               = key-%TKY
                          TransportRequestID = key-%PARAM-transportrequestid
                          HideTransport      = abap_false ) ).

    READ ENTITIES OF ZI_AcctAndPartner_S IN LOCAL MODE
      ENTITY AcctAndPartnerAll
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(entities).
    result = VALUE #( FOR entity IN entities
                        ( %TKY   = entity-%TKY
                          %PARAM = entity ) ).
  ENDMETHOD.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
    AUTHORITY-CHECK OBJECT 'S_TABU_NAM' ID 'TABLE' FIELD 'ZI_ACCTANDPARTNER' ID 'ACTVT' FIELD '02'.
    DATA(is_authorized) = COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
                                  ELSE if_abap_behv=>auth-unauthorized ).
    result-%UPDATE      = is_authorized.
    result-%ACTION-Edit = is_authorized.
    result-%ACTION-SelectCustomizingTransptReq = is_authorized.
  ENDMETHOD.
ENDCLASS.
CLASS LSC_ZI_ACCTANDPARTNER_S DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_SAVER.
  PROTECTED SECTION.
    METHODS:
      SAVE_MODIFIED REDEFINITION,
      CLEANUP_FINALIZE REDEFINITION.
ENDCLASS.

CLASS LSC_ZI_ACCTANDPARTNER_S IMPLEMENTATION.
  METHOD SAVE_MODIFIED.
    READ TABLE update-AcctAndPartnerAll INDEX 1 INTO DATA(all).
    IF all-TransportRequestID IS NOT INITIAL.
      lhc_rap_tdat_cts=>get( )->record_changes(
                                  transport_request = all-TransportRequestID
                                  create            = REF #( create )
                                  update            = REF #( update )
                                  delete            = REF #( delete ) )->update_last_changed_date_time( view_entity_name   = 'ZI_ACCTANDPARTNER'
                                                                                                        maintenance_object = 'ZACCTANDPARTNER' ).
    ENDIF.
  ENDMETHOD.
  METHOD CLEANUP_FINALIZE ##NEEDED.
  ENDMETHOD.
ENDCLASS.
CLASS LHC_ZI_ACCTANDPARTNER DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      VALIDATETRANSPORTREQUEST FOR VALIDATE ON SAVE
        IMPORTING
          KEYS FOR AcctAndPartner~ValidateTransportRequest,
      GET_GLOBAL_FEATURES FOR GLOBAL FEATURES
        IMPORTING
          REQUEST REQUESTED_FEATURES FOR AcctAndPartner
        RESULT result,
      COPYACCTANDPARTNER FOR MODIFY
        IMPORTING
          KEYS FOR ACTION AcctAndPartner~CopyAcctAndPartner,
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR AcctAndPartner
        RESULT result,
      GET_INSTANCE_FEATURES FOR INSTANCE FEATURES
        IMPORTING
          KEYS REQUEST requested_features FOR AcctAndPartner
        RESULT result.
ENDCLASS.

CLASS LHC_ZI_ACCTANDPARTNER IMPLEMENTATION.
  METHOD VALIDATETRANSPORTREQUEST.
    DATA change TYPE REQUEST FOR CHANGE ZI_AcctAndPartner_S.
    SELECT SINGLE TransportRequestID
      FROM ZSK_ACCT_PA_D_S
      WHERE SingletonID = 1
      INTO @DATA(TransportRequestID).
    lhc_rap_tdat_cts=>get( )->validate_changes(
                                transport_request = TransportRequestID
                                table             = 'ZSK_ACCT_PART'
                                keys              = REF #( keys )
                                reported          = REF #( reported )
                                failed            = REF #( failed )
                                change            = REF #( change-AcctAndPartner ) ).
  ENDMETHOD.
  METHOD GET_GLOBAL_FEATURES.
    DATA edit_flag TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled.
    IF cl_bcfg_cd_reuse_api_factory=>get_cust_obj_service_instance(
         iv_objectname = 'ZSK_ACCT_PART'
         iv_objecttype = cl_bcfg_cd_reuse_api_factory=>simple_table )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result-%UPDATE = edit_flag.
    result-%DELETE = edit_flag.
  ENDMETHOD.
  METHOD COPYACCTANDPARTNER.
    DATA new_AcctAndPartner TYPE TABLE FOR CREATE ZI_AcctAndPartner_S\_AcctAndPartner.

    IF lines( keys ) > 1.
      INSERT mbc_cp_api=>message( )->get_select_only_one_entry( ) INTO TABLE reported-%other.
      failed-AcctAndPartner = VALUE #( FOR fkey IN keys ( %TKY = fkey-%TKY ) ).
      RETURN.
    ENDIF.

    READ ENTITIES OF ZI_AcctAndPartner_S IN LOCAL MODE
      ENTITY AcctAndPartner
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(ref_AcctAndPartner)
        FAILED DATA(read_failed).

    IF ref_AcctAndPartner IS NOT INITIAL.
      ASSIGN ref_AcctAndPartner[ 1 ] TO FIELD-SYMBOL(<ref_AcctAndPartner>).
      DATA(key) = keys[ KEY draft %TKY = <ref_AcctAndPartner>-%TKY ].
      DATA(key_cid) = key-%CID.
      APPEND VALUE #(
        %TKY-SingletonID = 1
        %IS_DRAFT = <ref_AcctAndPartner>-%IS_DRAFT
        %TARGET = VALUE #( (
          %CID = key_cid
          %IS_DRAFT = <ref_AcctAndPartner>-%IS_DRAFT
          %DATA = CORRESPONDING #( <ref_AcctAndPartner> EXCEPT
          SingletonID
        ) ) )
      ) TO new_AcctAndPartner ASSIGNING FIELD-SYMBOL(<new_AcctAndPartner>).
      <new_AcctAndPartner>-%TARGET[ 1 ]-Dept = key-%PARAM-Dept.
      <new_AcctAndPartner>-%TARGET[ 1 ]-AccNo = key-%PARAM-AccNo.
      <new_AcctAndPartner>-%TARGET[ 1 ]-StoreId = key-%PARAM-StoreId.

      MODIFY ENTITIES OF ZI_AcctAndPartner_S IN LOCAL MODE
        ENTITY AcctAndPartnerAll CREATE BY \_AcctAndPartner
        FIELDS (
                 Dept
                 AccNo
                 StoreId
                 SoldTo
                 ShipTo
                 DeptName
                 AcctName
               ) WITH new_AcctAndPartner
        MAPPED DATA(mapped_create)
        FAILED failed
        REPORTED reported.

      mapped-AcctAndPartner = mapped_create-AcctAndPartner.
    ENDIF.

    INSERT LINES OF read_failed-AcctAndPartner INTO TABLE failed-AcctAndPartner.

    IF failed-AcctAndPartner IS INITIAL.
      reported-AcctAndPartner = VALUE #( FOR created IN mapped-AcctAndPartner (
                                                 %CID = created-%CID
                                                 %ACTION-CopyAcctAndPartner = if_abap_behv=>mk-on
                                                 %MSG = mbc_cp_api=>message( )->get_item_copied( )
                                                 %PATH-AcctAndPartnerAll-%IS_DRAFT = created-%IS_DRAFT
                                                 %PATH-AcctAndPartnerAll-SingletonID = 1 ) ).
    ENDIF.
  ENDMETHOD.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
    AUTHORITY-CHECK OBJECT 'S_TABU_NAM' ID 'TABLE' FIELD 'ZI_ACCTANDPARTNER' ID 'ACTVT' FIELD '02'.
    DATA(is_authorized) = COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
                                  ELSE if_abap_behv=>auth-unauthorized ).
    result-%ACTION-CopyAcctAndPartner = is_authorized.
  ENDMETHOD.
  METHOD GET_INSTANCE_FEATURES.
    result = VALUE #( FOR row IN keys ( %TKY = row-%TKY
                                        %ACTION-CopyAcctAndPartner = COND #( WHEN row-%IS_DRAFT = if_abap_behv=>mk-off THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled )
    ) ).
  ENDMETHOD.
ENDCLASS.
