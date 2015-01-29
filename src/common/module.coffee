moduleKeywords = ['extended', 'included']
class Module
  @extend = (obj) ->
    for key, value of obj when key not in moduleKeywords
      if not @[key]?
        @[key] = value

    obj.extended?.apply(@)
    this

  @include = (obj) ->
    for key, value of obj when key not in moduleKeywords
      # Assign properties to the prototype
      @::[key] = value

    obj.included?.apply(@)
    this

window.vtex or= {}
window.vtex.common or= {}
window.vtex.common.Module = Module
