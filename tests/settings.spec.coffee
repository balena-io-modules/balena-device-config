m = require('mochainon')
settings = require('../lib/settings')

describe 'Settings:', ->

	describe '.main', ->

		it 'should be a string', ->
			m.chai.expect(settings.main).to.be.a('string')

		it 'should not be empty', ->
			m.chai.expect(settings.main).to.not.have.length(0)

	describe '.getHomeSettings()', ->

		describe 'given no wifiSsid', ->

			beforeEach ->
				@options = {}

			it 'should only return ethernet related settings', ->
				config = settings.getHomeSettings(@options)
				m.chai.expect(config).to.equal '''
					[service_home_ethernet]
					Type = ethernet
					Nameservers = 8.8.8.8,8.8.4.4
				'''

		describe 'given wifiSsid is an empty string', ->

			beforeEach ->
				@options =
					wifiSsid: ''

			it 'should only return ethernet related settings', ->
				config = settings.getHomeSettings(@options)
				m.chai.expect(config).to.equal '''
					[service_home_ethernet]
					Type = ethernet
					Nameservers = 8.8.8.8,8.8.4.4
				'''

		describe 'given wifiSsid is a string only containing spaces', ->

			beforeEach ->
				@options =
					wifiSsid: '     '

			it 'should only return ethernet related settings', ->
				config = settings.getHomeSettings(@options)
				m.chai.expect(config).to.equal '''
					[service_home_ethernet]
					Type = ethernet
					Nameservers = 8.8.8.8,8.8.4.4
				'''

		describe 'given a wifiSsid and a wifiKey', ->

			beforeEach ->
				@options =
					wifiSsid: 'foo'
					wifiKey: 'bar'

			it 'should configure wifi with a passphrase', ->
				config = settings.getHomeSettings(@options)
				m.chai.expect(config).to.equal '''
					[service_home_ethernet]
					Type = ethernet
					Nameservers = 8.8.8.8,8.8.4.4

					[service_home_wifi]
					Hidden = true
					Type = wifi
					Name = foo
					Passphrase = bar
					Nameservers = 8.8.8.8,8.8.4.4
				'''

		describe 'given a wifiSsid but no wifiKey', ->

			beforeEach ->
				@options =
					wifiSsid: 'foo'

			it 'should configure wifi without a passphrase', ->
				config = settings.getHomeSettings(@options)
				m.chai.expect(config).to.equal '''
					[service_home_ethernet]
					Type = ethernet
					Nameservers = 8.8.8.8,8.8.4.4

					[service_home_wifi]
					Hidden = true
					Type = wifi
					Name = foo
					Nameservers = 8.8.8.8,8.8.4.4
				'''
