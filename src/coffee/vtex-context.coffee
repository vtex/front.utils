class Context
	whitelist: ['showErrorLog']
	rules: [/^VTEX\_.*/g]

	constructor: ->
		cookiesContextOptions = @searchCookies(@whitelist, @rules)
		queryStringContextOptions = @searchQueryString(@whitelist, @rules)
		localStorageContextOptions = @searchLocalStorage(@whitelist, @rules)
		_.extend(this, cookiesContextOptions, queryStringContextOptions, localStorageContextOptions)

	# Returns cookie maps
	searchCookies: (whitelist, rules) ->
		# NOT IMPLEMENTED

	searchQueryString: (whitelist, rules) =>
		if window.location.search.indexOf("showErrorLog=true")
			@showErrorLog = true

	searchLocalStorage: (whitelist, rules) ->
		# NOT IMPLEMENTED

window.vtex or= {}
window.vtex.Context = Context
window.vtex.context = new Context()