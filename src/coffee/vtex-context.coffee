class Context
	
	constructor: ->
		cookiesContextOptions = @searchCookies(@whitelist, @rules)
		queryStringContextOptions = @searchQueryString(@whitelist, @rules)
		localStorageContextOptions = @searchLocalStorage(@whitelist, @rules)
		_.extend(this, cookiesContextOptions, queryStringContextOptions, localStorageContextOptions)

	# Returns cookie maps
	searchCookies: (whitelist, rules) ->
		cookies = {}
		cookiesArray = document.cookie.split(";")
		for optionName in whitelist
			optionValue = _.readCookie(optionName)
			cookies[optionName] = JSON.parse optionValue if optionValue

		for rule in rules
			for cookieString in cookiesArray
				cookieKey = cookieString.substr(0, cookieString.indexOf("=")).replace(/^\s+|\s+$/g, "")
				cookieValue = cookieString.substr(cookieString.indexOf("=") + 1)
				cookies[cookieKey] = JSON.parse cookieValue if rule.test(cookieKey)
		return cookies

	searchQueryString: (whitelist, rules) =>
		qsArray = _.urlParams()
		qs = @searchThrough(whitelist, rules, qsArray)?
		return qs

	searchLocalStorage: (whitelist, rules) =>
		lsArray = localStorage
		ls = @searchThrough(whitelist, rules, lsArray)?
		return ls

	searchThrough: (whitelist, rules, array) ->
		a = {}
		for value in whitelist
			for content in array
				a[value] = JSON.parse content if content is value

		for rule in rules
			for content in array
				a[content] = JSON.parse content.match(rule) if content.match(rule)
		return a

window.vtex or= {}
window.vtex.Context = Context
window.vtex.context = new Context()