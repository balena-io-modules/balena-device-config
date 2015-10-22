m = require('mochainon')
_ = require('lodash')
schema = require('../lib/schema')

describe 'Schema:', ->

	it 'should be a plain object', ->
		m.chai.expect(_.isPlainObject(schema)).to.be.true

	it 'should contains a `properties` object property', ->
		m.chai.expect(_.isPlainObject(schema.properties)).to.be.true
