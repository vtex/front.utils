window.console or= {
  log: ->
  warn: ->
  error: ->
}
debug = (context = '') ->
  if /vtexlocal|vtexcommercebeta/.test(window.location.host)
    paddedContext = context.slice(0,16) + "                ".split('').splice(0, 16-context.length).join('')
    console.log.bind console, paddedContext + " >"
  else
    ->

window.vtex or= {}
window.vtex.common or= {}
window.vtex.common.debug = debug
