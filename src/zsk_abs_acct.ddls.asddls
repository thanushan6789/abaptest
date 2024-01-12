@EndUserText.label: 'Abstract entity to extend the validity'
@Metadata.allowExtensions: true
define abstract entity Zsk_abs_acct
with parameters acc_no: abap.char( 10 )
 // with parameters parameter_name : parameter_type 
  {
    extend_till : /dmo/end_date;
    comments : abap.string( 300 );
    
}
