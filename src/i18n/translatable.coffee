Translatable =
  extendTranslations: (translation, locale) ->
    if window.vtex.i18n[locale]
      window.vtex.i18n[locale] = _.extend(translation, window.vtex.i18n[locale])
      i18n.addResourceBundle(locale, 'translation', window.vtex.i18n[locale])
    else
      i18n.addResourceBundle(locale, 'translation', translation)

window.vtex or= {}
window.vtex.i18n or= {}
window.vtex.i18n.Translatable = Translatable
