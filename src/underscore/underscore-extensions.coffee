class Utils
  ###
  Formats monetary value as a string with decimal and thousands separators

  @param [Number] value the value to format
  @param [Object] options
  @option options [String] decimalSeparator the character used to separate the decimal and integer parts. Default: ','
  @option options [String] thousandsSeparator the character used to separate the thousands. Default: '.'
  @option options [Boolean] absolute whether to use an absolute value or not. Default: false
  @option options [Integer] decimalPlaces the number of decimal places to use. Default: 2
  @return [String] the value formatted according to the options given

  @example Default usage
    formatCurrency(1050)
    #=> '1.050,00'

  @example Usage with options
    formatCurrency(-1050.99, {'decimalSeparator': '.', 'thousandsSeparator': ',', 'absolute': true, 'decimalPlaces': 3}
    #=> '1,050.990'
  ###
  formatCurrency: (value, options) =>
    defaults =
      decimalSeparator: @_getDecimalSeparator()
      thousandsSeparator: @_getThousandsSeparator()
      absolute: false
      decimalPlaces: @_getDecimalDigits()
    opts = @_extend(defaults, options)

    value = -value if opts.absolute and value < 0
    value = value.toFixed(opts.decimalPlaces)

    [wholePart, decimalPart] = value.split('.')
    wholePart = wholePart.replace(/\B(?=(\d{3})+(?!\d))/g, opts.thousandsSeparator)

    if opts.decimalPlaces > 0
      return wholePart + opts.decimalSeparator + decimalPart
    else
      return wholePart

  intAsCurrency: (value, options) ->
    currencySymbol = if options and options.currencySymbol then options.currencySymbol else @_getCurrency()
    startsWithCurrency = if options and options.currencySymbol then options.currencySymbol else @_getStartsWithCurrency()
    if startsWithCurrency
      return currencySymbol + @formatCurrency(value / 100, options)
    return @formatCurrency(value / 100, options) + ' ' + currencySymbol
  ###
  Pads a string until it reaches a certain length. Non-strings will be converted.

  @param [String] str the string to be padded. Any other type will be converted to string
  @param [Integer] max the length desired
  @param [Object] options
  @option options [String] char the character used to pad the string. Default: '0'
  @option options [String] position where to pad. Valid: 'left', 'right'. Default: 'left'
  @return [String] the string padded according to the options given

  @example Default usage
    pad('19,99', 6)
    #=> '019,99'

  @example Usage with options
    pad('Hello', 7, {'char': ' ', 'position': 'right'})
    #=> 'Hello  '
  ###
  pad: (str, max, options) =>
    defaults =
      char: '0'
      position: 'left'
    opts = @_extend(defaults, options)
    opts.char = opts.char.charAt(0)

    str = str+''
    toadd = Array(max - str.length + 1).join(opts.char)

    if opts.position is 'right' then str + toadd else toadd + str

  ###
  Returns the content of the cooke with the given name

  @param [String] name the name of the cookie to be read
  @return [String] the content of the cookie with the given name

  @example Default usage
    # Assuming document.cookie is 'a=123; b=xyz'
    readCookie(a)
    #=> '123'
    readCookie(b)
    #=> 'xyz'
  ###
  readCookie: (name) =>
    ARRcookies = document.cookie.split(";")
    for pair in ARRcookies
      key = pair.substr(0, pair.indexOf("=")).replace(/^\s+|\s+$/g, "")
      value = pair.substr(pair.indexOf("=") + 1)
      return unescape(value) if key is name

  ###
  Receives a cookie that has "subcookies" in the format a=b&c=d
  Returns the content of the "subcookie" with the given name

  @param [String] cookie a string with "subcookies" in the format 'a=b&c=d'
  @param [String] name the name of the "subcookie" to get the value of
  @return [String] the content of the "subcookie" with the given name

  @example Get subcookies
    c = readCookie('sub')
    #=> 'a=b&c=d'
    getCookieValue(c, 'a')
    #=> 'b'
    getCookieValue(c, 'c')
    #=> 'd'
  ###
  getCookieValue: (cookie, name) =>
    subcookies = cookie.split("&")
    for subcookie in subcookies
      key = subcookie.substr(0, subcookie.indexOf("="))
      value = subcookie.substr(subcookie.indexOf("=") + 1)
      return unescape(value) if key is name

  ###
  Parses the querystring and returns its object representation.
  It decodes URI components (such as %3D to =) and replaces + with space.

  @return [Object] an object representation of the querystring parameters

  @example
    # URL is http://google.com/?a=b&c=hello+%3D+hi
    urlParam()
    #=> {'a': 'b', 'c': 'hello = hi'}
  ###
  urlParams: =>
    params = {}
    search = /([^&=]+)=?([^&]*)/g
    plus = /\+/g
    decode = (s) ->
      try
        decodeURIComponent s.replace(plus, " ")
      catch
        return s.replace(plus, " ")

    query = window.location.search.substring(1)
    params[decode(match[1])] = decode(match[2]) while match = search.exec(query)
    return params

  ###
  Transforms a ISO8061 compliant date string into a Date object

  @param [String] isostr a string in the format YYYY-MM-DDThh:mm:ss
  @return [Date] a Date object created from the date information in the string

  @example Default usage
    dateFromISO8601('1997-07-16T19:20:30')
    #=> Date object ("Thu Jul 18 2013 15:08:08 GMT-0300 (BRT)")
  ###
  dateFromISO8601: (isostr) =>
    parts = isostr.match(/\d+/g);
    part1 = parts[1] - 1
    return new Date(parts[0], part1, parts[2], parts[3], parts[4], parts[5]);

  ###
  Capitalizes the first character of a given string.

  @param [String] word the word to be capitalized
  @return [String] the capitalized word

  @example Default usage
    capitalizeWord('hello')
    #=> 'Hello'

  @example It only capitalizes the first character
    capitalizeWord(' hi ')
    #=> ' hi '
  ###
  capitalizeWord: (word = '') =>
    word.charAt(0).toUpperCase() + word.slice(1)

  ###
  @see {Utils#capitalizeWord}.
  ###
  capitalize: (word = '') =>
    @capitalizeWord(word)

  ###
  Capitalizes each word in a given sentende.

  @param [String] sentence the sentence to be capitalized
  @return [String] the capitalized sentence

  @example Default usage
    capitalizeSentence('* hello world!')
    #=> '* Hello Wordl!'
  ###
  capitalizeSentence: (sentence = '') =>
    oldWords = sentence.toLowerCase().split(' ')
    newWords = (@capitalizeWord(word) for word in oldWords)
    newWords.join(' ')

  maskString: (str, mask, fixedChars = '[(),.:/ -]') =>
    argString = if typeof str is "string" then str else String(str)
    maskString = mask?.mask or mask
    fixedCharsRegex = new RegExp(fixedChars)
    digitMask = '9'
    letterMask = 'A'
    applyMask = (valueArray, maskArray, fixed) ->
      maskedValueArray = valueArray.slice(0) # clone values to preserve original in case of no match

      for v, i in maskArray
        # Stop if mask or value ended prematurely
        if not (maskedValueArray[i] and maskArray[i])
          break

        noMatchDigit = maskArray[i] is digitMask and not /\d/.test(maskedValueArray[i])
        noMatchLetter = maskArray[i].toUpperCase() is letterMask and not /[a-zA-Z\u00C0-\u017F]/.test(maskedValueArray[i])
        # Return original if no-match found
        if noMatchDigit or noMatchLetter
          return valueArray

        if fixed.test(maskArray[i])
          # Disconsider if this position is already mask
          continue if maskArray[i] is maskedValueArray[i]
          maskedValueArray.splice i, 0, maskArray[i]

      maskedValueArray

    applyMask(argString.split(""), maskString.split(""), fixedCharsRegex).join("")

  ###
  Substitutes each * in a string with span.masked-info *

  @param [String] info the string to mask
  @return [String] the masked string

  @example Default usage
    maskInfo('abc**')
    #=> 'abc<span class="masked-info">*</span><span class="masked-info">*</span>'
  ###
  maskInfo: (info) =>
    maskRegex = /\*/g;
    maskText = '<span class="masked-info">*</span>';
    if info
      return info.replace(maskRegex, maskText)
    else
      return info

  plainChars: (str) =>
    return if not str?

    specialChars = 	"ąàáäâãåæćęèéëêìíïîłńòóöôõøśùúüûñçżź"
    plain = "aaaaaaaaceeeeeiiiilnoooooosuuuunczz"
    regex = new RegExp "[#{specialChars}]", 'g'

    str += ""
    str.replace regex, (char) -> plain.charAt(specialChars.indexOf char)

  # Sanitizes text: "Caçoá (teste 2)" becomes "Cacoateste2"
  sanitize: (str) =>
    s = @plainChars str.replace(/\s/g, '')
    .replace(/\/|\\/g, '-')
    .replace(/\(|\)|\'|\"/g, '')
    .toLowerCase()
    .replace(/\,/g, 'V')
    .replace(/\./g, 'P')
    .replace(/\:/g, 'D')
    return s.charAt(0).toUpperCase() + s.slice(1)

  ###
  Replaces all space charactes with hyphen characters

  @param [String] str the string
  @return [Stirng] the string with all space characters replaced with hyphen characters

  @example
    spacesToHyphens("Branco e Preto")
    #=> "Branco-e-Preto"
  ###
  spacesToHyphens: (str) =>
    str.replace(/\ /g, '-')

  ###
  Creates a (mostly) unique hashcode from a string

  @param [String] str the string
  @return [Number] the created hashcode

  @example Typical usage is to give an object a unique ID
    uid = hash(Date.now())
    #=> -707575924
  ###
  hash: (str) =>
    hashed = 0
    for char in str
      charcode = char.charCodeAt(0)
      hashed = ((hashed << 5) - hashed) + charcode
      hashed = hashed & hashed # Convert to 32bit integer
    hashed

  ###
  Produces a new object mapping each key:value pair to a key:f(value) pair.

  @param [Object] obj the object
  @param [Function] f a function that will receive (key, value) and should return a replacement value
  @return [Object] a new object with each value mapped according to the function

  @example
    obj = {a: 1, b: 2};
    mapObj(obj, function(key, value){
      return value*10
    });
    #=> {a: 10, b: 20}
  ###
  mapObj: (obj, f) =>
    obj2 = {}
    for own k, v of obj
      obj2[k] = f k, v
    obj2

  ###
  Produces a new flattened object

  @param [Object] obj the object
  @param [Object] target (optional) object
  @param [String] prefix (optional)
  @return [Object] flattened object

  @example
    obj = {attr: {address: {street: 'Wall'}}};
    flattenObj(obj)
    #=> { 'attr.address.street': 'Wall' }
  ###
  flattenObj: (obj, target, prefix) =>
    unless window?._?.reduce? then throw "This function requires Underscore"

    prefix = prefix || ''

    return _.reduce(obj, (result, value, key) =>
      if _.isObject(value)
        @flattenObj(value, result, prefix + key + '.')
      else
        result[prefix + key] = value

      return result;
    , target || {})

  ###
  Produces a new un-flattened object

  @param [Object] obj the object

  @example
    obj = { 'attr.address.street': 'Wall' }
    unFlattenObj(obj)
    #=> {attr: {address: {street: 'Wall'}}};
  ###
  unFlattenObj: (obj) =>
    unless window?._?.reduce? then throw "This function requires Underscore"

    return _.reduce(obj, (result, value, keys) =>
      current = result
      partitions = keys.split('.')
      limit = partitions.length - 1

      _.each(partitions, (key, index) =>
        if index == limit
          current = current[key] = value
        else
          current = current[key] = current[key] || {}
      )

      return result
    , {})

  ###
  Padding left

  @param [String] string to insert padding
  @param [Number] limit
  @param [String] padding characters

  @example
    padStr('1', 2, '00')
    #=> '01';
  ###
  padStr: (str, limit, padding) ->
    (padding + str).split('').reverse().slice(0, limit).reverse().join('')

  ###
  Format date as DD/MM/YYYY

  @param [Date|String] date

  @example
    dateFormat('2014/01/23')
    #=> 23/01/2014;
  ###
  dateFormat: (date) ->
    if typeof date == 'string'
      date = new Date(date)
    return "#{@padStr(date.getDate(), 2, '00')}/#{@padStr(date.getMonth()+1, 2, '00')}/#{date.getFullYear()}"

  ###
  Format date as M/DD/YYYY

  @param [Date|String] date

  @example
    dateFormatUS('2014/01/23')
    #=> 1/23/2014;
  ###
  dateFormatUS: (date) ->
    if typeof date == 'string'
      date = new Date(date)
    return "#{date.getMonth()+1}/#{@padStr(date.getDate(), 2, '00')}/#{date.getFullYear()}"

  #
  # PRIVATE
  #
  _getCurrency: =>
    window.vtex?.i18n?.getCurrency?() or 'R$ '

   _getStartsWithCurrency: =>
    if window.vtex?.i18n?.getStartsWithCurrency
      return window.vtex?.i18n?.getStartsWithCurrency()
    else
      return true

  _getDecimalSeparator: =>
    window.vtex?.i18n?.getDecimalSeparator?() or ','

  _getThousandsSeparator: =>
    window.vtex?.i18n?.getThousandsSeparator?() or '.'

  _getDecimalDigits: =>
    if window.vtex?.i18n?.getDecimalDigits? then window.vtex?.i18n?.getDecimalDigits() else 2

  _extend: (obj, sources...) =>
    for source in sources when source
      obj[prop] = source[prop] for prop of source

    return obj

utils = new Utils()
if window._? # Is Underscore namespace being used?
	if window._.mixin? # Is it underscore?
    window._.mixin(utils) # Mixin it
  else
    utils._extend(window._, utils) # Extend this thing
else
	window._ = utils # Take namespace
	# polyfill for Underscores's extend
	window._.extend = utils._extend
