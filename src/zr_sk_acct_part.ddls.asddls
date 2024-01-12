@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '##GENERATED ZSK_ACCT_PART'
define root view entity ZR_SK_ACCT_PART
  as select from zsk_acct_part
{
  key dept as Dept,
  key acc_no as AccNo,
  key store_id as StoreID,
  sold_to as SoldTo,
  ship_to as ShipTo,
  dept_name as DeptName,
  acct_name as AcctName,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed as LocalLastChanged,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed as LastChanged
  
}
