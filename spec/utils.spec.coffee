describe 'utils', ->

	describe '_fixValue', ->
		it 'should return the value string with 2 decimals', ->
			expect(_._fixValue(123)).toEqual('123.00')
			expect(_._fixValue(123.45)).toEqual('123.45')
			expect(_._fixValue(123.451)).toEqual('123.45')
			expect(_._fixValue(-123)).toEqual('-123.00')

		it 'should return the absolute value when options.absolute is true', ->
			expect(_._fixValue(-123, absolute: true)).toEqual('123.00')


	describe 'formatCurrency', ->
		it ''


	describe '_getCurrencySymbol', ->
		it 'should default to R$ when vtex.i18n is undefined', ->
			window.vtex = undefined
			expect(_._getCurrencySymbol()).toEqual('R$ ')

	describe '_getDecimalSeparator', ->
		it 'should default to . when vtex.i18n is undefined', ->
			window.vtex = undefined
			expect(_._getDecimalSeparator()).toEqual(',')


	describe '_getThousandsSeparator', ->
		it 'should default to , when vtex.i18n is undefined', ->
			window.vtex = undefined
			expect(_._getThousandsSeparator()).toEqual('.')


	describe 'pad', ->
		it 'should not modify strings larger than max', ->
			expect(_.pad('123', 2)).toEqual('123')
			expect(_.pad('abc', 2)).toEqual('abc')

		it 'should not modify strings that are the same size as max', ->
			expect(_.pad('123', 3)).toEqual('123')
			expect(_.pad('abc', 3)).toEqual('abc')

		it 'should pad strings with zeroes', ->
			expect(_.pad('123', 4)).toEqual('0123')
			expect(_.pad('123', 5)).toEqual('00123')
			expect(_.pad('abc', 4)).toEqual('0abc')
			expect(_.pad('abc', 5)).toEqual('00abc')


	describe 'readCookie', ->
		beforeEach ->
			document.cookie = 'a=123'
			document.cookie = 'b=456;'

		it 'should return undefined for an invalid name', ->
			expect(_.readCookie('abc')).not.toBeDefined()

		it 'should return the corresponding value for a valid name', ->
			expect(_.readCookie('a')).toEqual('123')
			expect(_.readCookie('b')).toEqual('456')


	describe 'getCookieValue', ->
		beforeEach ->
			@cook = 'a=b&c=d'

		it 'should return undefined for an invalid name', ->
			expect(_.getCookieValue(@cook, 'abc')).not.toBeDefined()

		it 'should return the corresponding value for a valid name', ->
			expect(_.getCookieValue(@cook, 'a')).toEqual('b')
			expect(_.getCookieValue(@cook, 'c')).toEqual('d')


	describe 'capitalizeWord', ->
		it 'should capitalize the first character', ->
			expect(_.capitalizeWord('hello')).toEqual('Hello')

		it 'should not trim', ->
			expect(_.capitalizeWord(' hello   ')).toEqual(' hello   ')

		it 'should not modify other characters', ->
			expect(_.capitalizeWord('WorlD!@#$%¨&*()')).toEqual('WorlD!@#$%¨&*()')

	describe 'capitalizeSentence', ->
		it 'should call capitalizeWord for every word', ->
			sentence =  'The quick brown fox jumps over the lazy dog'
			times = sentence.split(' ').length
			spyOn(_, 'capitalizeWord')
			_.capitalizeSentence(sentence)
			expect(_.capitalizeWord.callCount).toEqual(times)

	describe 'maskInfo', ->
		it 'should substitute * for some html', ->
			html = '<span class="masked-info">*</span>'
			expect(_.maskInfo('***aaa**a')).toEqual(html+html+html+'aaa'+html+html+'a')

	describe 'plainChars', ->
		it 'should planify characters', ->
			expect(_.plainChars('ąàáäâãåæćęèéëêìíïîłńòóöôõøśùúüûñçżź')).toEqual('aaaaaaaaceeeeeiiiilnoooooosuuuunczz')

		it 'should planify even if the characters are repeated', ->
			expect(_.plainChars('ąąąąą')).toEqual('aaaaa')

		it 'should not modify other characters', ->
			expect(_.plainChars('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890!@#$%¨&*()')).toEqual('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890!@#$%¨&*()')
