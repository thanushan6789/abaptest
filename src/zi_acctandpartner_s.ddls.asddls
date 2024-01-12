@EndUserText.label: 'Acct and partner Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZI_AcctAndPartner_S
  as select from I_Language
    left outer join I_CstmBizConfignLastChgd on I_CstmBizConfignLastChgd.ViewEntityName = 'ZI_ACCTANDPARTNER'
  composition [0..*] of ZI_AcctAndPartner as _AcctAndPartner
{
  key 1 as SingletonID,
  _AcctAndPartner,
  I_CstmBizConfignLastChgd.LastChangedDateTime as LastChangedAtMax,
  cast( '' as SXCO_TRANSPORT) as TransportRequestID,
  cast( 'X' as ABAP_BOOLEAN preserving type) as HideTransport
  
}
where I_Language.Language = $session.system_language
