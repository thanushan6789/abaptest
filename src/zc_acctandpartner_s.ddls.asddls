@EndUserText.label: 'Maintain Acct and partner Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: [ 'SingletonID' ]
define root view entity ZC_AcctAndPartner_S
  provider contract transactional_query
  as projection on ZI_AcctAndPartner_S
{
  key SingletonID,
  LastChangedAtMax,
  TransportRequestID,
  HideTransport,
  _AcctAndPartner : redirected to composition child ZC_AcctAndPartner
  
}
