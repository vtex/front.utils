describe 'utils', ->

  describe 'formatCurrency', ->
    it 'should return the value string with 2 decimals', ->
      # Assert
      expect(_.formatCurrency(123)).toEqual('123,00')
      expect(_.formatCurrency(123.45)).toEqual('123,45')
      expect(_.formatCurrency(123.451)).toEqual('123,45')
      expect(_.formatCurrency(-123)).toEqual('-123,00')

    it 'should return the absolute value when options.absolute is true', ->
      # Assert
      expect(_.formatCurrency(-123, absolute: true)).toEqual('123,00')

  describe '_getCurrency', ->
    it 'should default to R$ when vtex.i18n is undefined', ->
      # Arrange
      window.vtex = undefined

      # Assert
      expect(_._getCurrency()).toEqual('R$ ')

  describe '_getDecimalSeparator', ->
    it 'should default to . when vtex.i18n is undefined', ->
      # Arrange
      window.vtex = undefined

      # Assert
      expect(_._getDecimalSeparator()).toEqual(',')


  describe '_getThousandsSeparator', ->
    it 'should default to , when vtex.i18n is undefined', ->
      # Arrange
      window.vtex = undefined

      # Assert
      expect(_._getThousandsSeparator()).toEqual('.')

  describe '_getDecimalDigits', ->
    it 'should default to 2 when vtex.i18n is undefined', ->
      # Arrange
      window.vtex = undefined

      # Assert
      expect(_._getDecimalDigits()).toEqual(2)

  describe 'pad', ->
    it 'should not modify strings larger than max', ->
      # Assert
      expect(_.pad('123', 2)).toEqual('123')
      expect(_.pad('abc', 2)).toEqual('abc')

    it 'should not modify strings that are the same size as max', ->
      # Assert
      expect(_.pad('123', 3)).toEqual('123')
      expect(_.pad('abc', 3)).toEqual('abc')

    it 'should pad strings with zeroes', ->
      # Assert
      expect(_.pad('123', 4)).toEqual('0123')
      expect(_.pad('123', 5)).toEqual('00123')
      expect(_.pad('abc', 4)).toEqual('0abc')
      expect(_.pad('abc', 5)).toEqual('00abc')

    it 'should pad strings with the given char', ->
      # Arrange
      options =
        char: ' '

      # Assert
      expect(_.pad('123', 4, options)).toEqual(' 123')

    it 'shoudl pad strings on the right', ->
      #Arrange
      options =
        position: 'right'

      #Assert
      expect(_.pad('123', 4, options)).toEqual('1230')


  describe 'readCookie', ->
    beforeEach ->
      # Arrange
      document.cookie = 'a=123'
      document.cookie = 'b=456;'

    it 'should return undefined for an invalid name', ->
      # Assert
      expect(_.readCookie('abc')).not.toBeDefined()

    it 'should return the corresponding value for a valid name', ->
      # Assert
      expect(_.readCookie('a')).toEqual('123')
      expect(_.readCookie('b')).toEqual('456')


  describe 'getCookieValue', ->
    beforeEach ->
      # Arrange
      @cook = 'a=b&c=d'

    it 'should return undefined for an invalid name', ->
      # Assert
      expect(_.getCookieValue(@cook, 'abc')).not.toBeDefined()

    it 'should return the corresponding value for a valid name', ->
      # Assert
      expect(_.getCookieValue(@cook, 'a')).toEqual('b')
      expect(_.getCookieValue(@cook, 'c')).toEqual('d')


  describe 'capitalizeWord', ->
    it 'should capitalize the first character', ->
      # Assert
      expect(_.capitalizeWord('hello')).toEqual('Hello')

    it 'should not trim', ->
      # Assert
      expect(_.capitalizeWord(' hello   ')).toEqual(' hello   ')

    it 'should not modify other characters', ->
      # Assert
      expect(_.capitalizeWord('WorlD!@#$%¨&*()')).toEqual('WorlD!@#$%¨&*()')

  describe 'capitalizeSentence', ->
    it 'should call capitalizeWord for every word', ->
      # Arrange
      sentence = 'The quick brown fox jumps over the lazy dog'
      sentenceExp = 'The Quick Brown Fox Jumps Over The Lazy Dog'

      # Act
      result = _.capitalizeSentence(sentence)

      # Assert
      expect(result).toEqual(sentenceExp)

  describe 'maskString', ->
    it 'should receive a raw Brazilian postal code value, a mask and return a masked value', ->
      # Arrange
      raw = '22030030'
      mask = '99999-999'
      masked = '22030-030'

      # Assert
      expect(_.maskString(raw,mask)).toEqual(masked)

    it 'should receive a raw Brazilian document value, a mask and return a masked value', ->
      # Arrange
      raw = '12345678909'
      mask = '999.999.999-99'
      masked = '123.456.789-09'

      # Assert
      expect(_.maskString(raw,mask)).toEqual(masked)

    it 'should receive a masked value, a mask and return the same masked value', ->
      # Arrange
      raw = '123.456.789-09'
      mask = '999.999.999-99'
      masked = '123.456.789-09'

      # Assert
      expect(_.maskString(raw,mask)).toEqual(masked)

    it 'should receive a raw value, a mask smaller than the raw value, and return the masked value preserving the remaining value', ->
      # Arrange
      raw = '1234567890912'
      mask = '999.999.999-99'
      masked = '123.456.789-0912'

      # Assert
      expect(_.maskString(raw,mask)).toEqual(masked)

    it 'should receive a raw value smaller than the mask, a mask, and return a masked value', ->
      # Arrange
      raw = '123456789'
      mask = '999.999.999-99'
      masked = '123.456.789'

      # Assert
      expect(_.maskString(raw,mask)).toEqual(masked)

    it 'should receive a half-masked raw value, a mask, and return a masked value', ->
      # Arrange
      raw = '4444 33332'
      mask = '9999 9999 9999 9999'
      masked = '4444 3333 2'

      # Assert
      expect(_.maskString(raw,mask)).toEqual(masked)

    it 'should receive a numeric raw value not matching mask and return raw value', ->
      # Arrange
      raw = '12345'
      mask = 'AAA-AA'
      masked = '12345'

      # Assert
      expect(_.maskString(raw,mask)).toEqual(masked)

    it 'should receive a all-letters raw value, a mask and return masked value', ->
      # Arrange
      raw = 'ABCDE'
      mask = 'AAA-AA'
      masked = 'ABC-DE'

      # Assert
      expect(_.maskString(raw,mask)).toEqual(masked)

    it 'should receive a all-letters raw value not matching mask and return raw value', ->
      # Arrange
      raw = 'ABCDE'
      mask = '999-99'
      masked = 'ABCDE'

      # Assert
      expect(_.maskString(raw,mask)).toEqual(masked)

    it 'should receive a mixed raw value not matching mask and return raw value', ->
      # Arrange
      raw = '1232ABB'
      mask = '999-AA-99'
      masked = '1232ABB'

      # Assert
      expect(_.maskString(raw,mask)).toEqual(masked)

    it 'should receive a mixed raw value, a matching mask and return masked value', ->
      # Arrange
      raw = '123rj28'
      mask = '999-AA-99'
      masked = '123-rj-28'

      # Assert
      expect(_.maskString(raw,mask)).toEqual(masked)

    it 'should receive a mixed raw value with punctuation, a matching mask and return masked value', ->
      # Arrange
      raw = '123äéöã28'
      mask = '999-AAAA-99'
      masked = '123-äéöã-28'

      # Assert
      expect(_.maskString(raw,mask)).toEqual(masked)

    it 'should ignore mask characters outside of 9 or A', ->
      # Arrange
      raw = 'bana99'
      mask = '123-ABC'
      masked = 'ban-a99'

      # Assert
      expect(_.maskString(raw,mask)).toEqual(masked)

    it 'should respect user fixedChar parameter', ->
      # Arrange
      raw = 'banana'
      fixedChars = 'X'
      mask = 'AAAXAAA'
      masked = 'banXana'

      # Assert
      expect(_.maskString(raw,mask,fixedChars)).toEqual(masked)

  describe 'maskInfo', ->
    it 'should substitute * for some html', ->
      # Arrange
      html = '<span class="masked-info">*</span>'

      # Assert
      expect(_.maskInfo('***aaa**a')).toEqual(html+html+html+'aaa'+html+html+'a')

  describe 'plainChars', ->
    it 'should planify characters', ->
      # Assert
      expect(_.plainChars('ąàáäâãåæćęèéëêìíïîłńòóöôõøśùúüûñçżź')).toEqual('aaaaaaaaceeeeeiiiilnoooooosuuuunczz')

    it 'should planify even if the characters are repeated', ->
      # Assert
      expect(_.plainChars('ąąąąą')).toEqual('aaaaa')

    it 'should not modify other characters', ->
      # Assert
      expect(_.plainChars('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890!@#$%¨&*()')).toEqual('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890!@#$%¨&*()')

  describe 'mapObj', ->
    it '', ->

  describe 'flattenObj', ->
    it 'should flatten an object', ->
      # Arrange
      obj =
        person:
          job:
            name: "Singer"

      # Act
      result = _.flattenObj(obj)

      # Assert
      expect(result["person.job.name"]).toEqual("Singer")

  describe 'unFlattenObj', ->
    it 'should unflatten an object', ->
      # Arrange
      obj =
        "person.job.name": "Singer"

      # Act
      result = _.unFlattenObj(obj)

      # Assert
      expect(result.person.job.name).toEqual("Singer")

  describe 'padStr', ->
    it 'should pad left', ->
      # Arrange
      number = 1
      limit = 2
      padding = '00'

      # Act
      result = _.padStr(number, limit, padding)

      # Assert
      expect(result).toEqual('01')

  describe 'dateFormat', ->
    it 'should format', ->
      # Arrange
      date = '2014/01/23'

      # Act
      result = _.dateFormat(date)

      # Assert
      expect(result).toEqual('23/01/2014')

  describe 'dateFormatUS', ->
    it 'should format as american date', ->
      # Arrange
      date = '2014/01/23'

      # Act
      result = _.dateFormatUS(date)

      # Assert
      expect(result).toEqual('1/23/2014')

