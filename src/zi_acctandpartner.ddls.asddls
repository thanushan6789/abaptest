@EndUserText.label: 'Acct and partner'
@AccessControl.authorizationCheck: #CHECK
define view entity ZI_AcctAndPartner
  as select from ZSK_ACCT_PART
  association to parent ZI_AcctAndPartner_S as _AcctAndPartnerAll on $projection.SingletonID = _AcctAndPartnerAll.SingletonID
{
  key DEPT as Dept,
  key ACC_NO as AccNo,
  key STORE_ID as StoreId,
  SOLD_TO as SoldTo,
  SHIP_TO as ShipTo,
  DEPT_NAME as DeptName,
  ACCT_NAME as AcctName,
  1 as SingletonID,
  _AcctAndPartnerAll
  
}
