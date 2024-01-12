@EndUserText.label: 'Invvoice Table'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity Zsk_c_INVOICE
  provider contract transactional_query
  as projection on ZSK_I_INVOICE
{
  key Invoice,
      Comments,
      Attachment,
      MimeType,
      Filename,
      LocalLastChangedAt
}
