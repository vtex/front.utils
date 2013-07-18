class VtexContext

	# Recebe um nome e preenche vtex.context com todos os cookies que tem esse nome
	getContextByCookieName: (name) ->
		window.vtex.context.cookie utils.readCookie(name)?

	# Recebe um modo e preenche vtex.context com todas as queryString que tem esse modo
	getContextByQueryStringMode: (mode) ->
		qsArray = window.location.search
		for key in qsArray
			qs = utils.urlParams()
			window.vtex.context.queryString qs.mode if qs.mode is mode

	getContextByLocalStorage: (name) ->
		for value in localStorage
			window.vtex.context.localStorage value if value is name
