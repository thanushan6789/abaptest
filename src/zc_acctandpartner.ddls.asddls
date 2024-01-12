@EndUserText.label: 'Maintain Acct and partner'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_AcctAndPartner
  as projection on ZI_AcctAndPartner
{
  key Dept,
  key AccNo,
  key StoreId,
  SoldTo,
  ShipTo,
  DeptName,
  AcctName,
  @Consumption.hidden: true
  SingletonID,
  _AcctAndPartnerAll : redirected to parent ZC_AcctAndPartner_S
  
}
