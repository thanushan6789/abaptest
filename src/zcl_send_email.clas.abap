CLASS zcl_send_email DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
   INTERFACES if_oo_adt_classrun .
   METHODS: send_email.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_send_email IMPLEMENTATION.
 METHOD send_email.
  try.
    data(lo_mail) = cl_bcs_mail_message=>create_instance( ).
    lo_mail->set_sender( 'siva.kokilathas@ca.panasonic.com' ).
    lo_mail->add_recipient( 'sivathanushan89@gmail.com' ).
    lo_mail->add_recipient( iv_address = 'sivathanushan2@gmail.com' iv_copy = cl_bcs_mail_message=>cc ).
    lo_mail->set_subject( 'Test Mail' ).
    lo_mail->set_main( cl_bcs_mail_textpart=>create_text_html( '<h1>Hello</h1><p>This is a test mail.</p>' ) ).
    lo_mail->add_attachment( cl_bcs_mail_textpart=>create_text_plain(
      iv_content      = 'This is a text attachment'
      iv_filename     = 'Text_Attachment.txt'
    ) ).
    lo_mail->add_attachment( cl_bcs_mail_textpart=>create_instance(
      iv_content      = '<note><to>John</to><from>Jane</from><body>My nice XML!</body></note>'
      iv_content_type = 'text/xml'
      iv_filename     = 'Text_Attachment.xml'
    ) ).
    lo_mail->send( importing et_status = data(lt_status) ).
  catch cx_bcs_mail into data(lx_mail).
"handle exceptions here
endtry.

 ENDMETHOD..
  METHOD if_oo_adt_classrun~main.
   DATA(lo_email) = NEW zcl_send_email(  ).
   lo_email->send_email(  ).
   out->write( 'success' ).
  ENDMETHOD.

ENDCLASS.
