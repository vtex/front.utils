describe 'context', ->

	it 'should create window.vtex.context object', ->
		# Arrange
		# Act
		# Assert
		expect(window.vtex.context).toBeDefined()
		expect(window.vtex.context.constructor).toBe((new window.vtex.Context()).constructor)

	it 'should search query string for options', ->
		# Arrange
		window.location.search = "showErrorLog=true"

		# Act
		context = new window.vtex.Context()

		# Assert
		expect(context.showErrorLog).toBe(true)
