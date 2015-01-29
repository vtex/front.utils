appendTemplate = (templateId, template) ->
  document.body.innerHTML += "<script type='text/html' id='#{templateId}'>#{template}</script>"
  return templateId

window.vtex or= {}
window.vtex.common or= {}
window.vtex.common.appendTemplate = appendTemplate
