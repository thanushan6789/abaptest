@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZR_SK_ACCT_PART'
@ObjectModel.semanticKey: [ 'Dept', 'AccNo', 'StoreID' ]
define root view entity ZC_SK_ACCT_PART
  provider contract transactional_query
  as projection on ZR_SK_ACCT_PART
{
  key Dept,
  key AccNo,
  key StoreID,
  SoldTo,
  ShipTo,
  DeptName,
  AcctName,
  LocalLastChanged
  
}
