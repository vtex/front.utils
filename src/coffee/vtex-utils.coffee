utils =

	formatCurrency: (value, options = {}) ->
		value = @_fixValue(value, options)

		decimalSeparator = options.decimalSeparator or @_getDecimalSeparator()
		thousandsSeparator = options.thousandsSeparator or @_getThousandsSeparator()

		[wholePart, decimalPart] = value.split('.')
		wholePart = wholePart.replace(/\B(?=(\d{3})+(?!\d))/g, thousandsSeparator)

		wholePart + decimalSeparator + decimalPart


	intAsCurrency: (value, options = {}) ->
		(options.currencySymbol or @_getCurrencySymbol()) + utils.formatCurrency(value/100, options)

	pad: (str, max) ->
		return str if (str+"").length >= max
		return utils.pad("0" + str, max)

# returns the content of the cookie with the given name
	readCookie: (name) ->
		ARRcookies = document.cookie.split(";")
		for pair in ARRcookies
			key = pair.substr(0, pair.indexOf("=")).replace(/^\s+|\s+$/g, "")
			value = pair.substr(pair.indexOf("=") + 1)
			return unescape(value) if key is name

# receives a cookie that has "subcookies" in the format a=b&c=d
# returns the content of the "subcookie" with the given name
	getCookieValue: (cookie, name) ->
		subcookies = cookie.split("&")
		for subcookie in subcookies
			key = subcookie.substr(0, subcookie.indexOf("="))
			value = subcookie.substr(subcookie.indexOf("=") + 1)
			return unescape(value) if key is name

	urlParams: ->
		# TODO clarificar
		params = {}
		match = undefined
		pl = /\+/g # Regex for replacing addition symbol with a space
		search = /([^&=]+)=?([^&]*)/g
		decode = (s) ->
			decodeURIComponent s.replace(pl, " ")

		query = window.location.search.substring(1)
		params[decode(match[1])] = decode(match[2])  while match = search.exec(query)
		return params

	dateFromISO8601: (isostr) ->
		parts = isostr.match(/\d+/g);
		part1 = parts[1] - 1
		return new Date(parts[0], part1, parts[2], parts[3], parts[4], parts[5]);

	capitalizeWord: (word = '') ->
		word.charAt(0).toUpperCase() + word.slice(1)

	capitalize: (word = '') ->
		capitalizeWord(word)

	capitalizeSentence: (sentence = '') ->
		oldWords = sentence.toLowerCase().split(' ')
		newWords = (@capitalizeWord(word) for word in oldWords)
		newWords.join(' ')

	maskString: (str, mask) ->
		# TODO clarificar
		maskStr = mask.mask or mask
		applyMask = (valueArray, maskArray, fixedCharsReg) ->
			i = 0
			while i < valueArray.length
				valueArray.splice i, 0, maskArray[i]  if maskArray[i] and fixedCharsReg.test(maskArray[i]) and maskArray[i] isnt valueArray[i]
				i++
			valueArray
		o = {
			mask: maskStr
			fixedChars: '[(),.:/ -]'
		}
		argString = if typeof str is "string" then str else String(str)
		fixedCharsReg = new RegExp(o.fixedChars)
		applyMask(argString.split(""), o.mask.split(""), fixedCharsReg).join("").substring(0, o.mask.split("").length)

	maskInfo: (info) ->
		maskRegex = /\*/g;
		maskText = '<span class="masked-info">*</span>';
		if info
			return info.replace(maskRegex, maskText)
		else
			return info

	plainChars: (str) ->
		return if not str?

		specialChars = 	"ąàáäâãåæćęèéëêìíïîłńòóöôõøśùúüûñçżź"
		plain = "aaaaaaaaceeeeeiiiilnoooooosuuuunczz"
		regex = new RegExp "[#{specialChars}]", 'g'

		str += ""
		str.replace regex, (char) -> plain.charAt(specialChars.indexOf char)

	# Sanitizes text: "Caçoá (teste 2)" becomes "Cacoateste2"
	sanitize: (str) ->
		@plainChars str.replace(/\s/g, '')
		.replace(/\/|\\/g, '-')
		.replace(/\(|\)|\'|\"/g, '')
		.toLowerCase()
		.replace(/\,/g, 'V')
		.replace(/\./g, 'P')

	spacesToHyphens: (str) ->
		str.replace(/\ /g, '-')

	hash: (str) ->
		hashed = 0
		for char in str
			charcode = char.charCodeAt(0)
			hashed = ((hashed << 5) - hashed) + charcode
			hashed = hashed & hashed # Convert to 32bit integer
		hashed

	mapObj: (obj, f) ->
		obj2 = {}
		for own k, v of obj
			obj2[k] = f k, v
		obj2

	#
	# PRIVATE
	#
	_getCurrencySymbol: ->
		window.vtex?.i18n?.getCurrencySymbol() or 'R$ '

	_getDecimalSeparator: ->
		window.vtex?.i18n?.getDecimalSeparator() or ','

	_getThousandsSeparator: ->
		window.vtex?.i18n?.getThousandsSeparator() or '.'

	_fixValue: (value, options = {}) ->
		value = -value if options.absolute and value < 0
		value = value.toFixed(2)
		value

	_extend: (obj, sources...) ->
		for source in sources when source
			obj[prop] = source[prop] for prop of source

		return obj

# exports
if window._
	window._.mixin(utils)
else
	window._ = utils

	# polyfill for Underscores's extend
	window._.extend = utils._extend
