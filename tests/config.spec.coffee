m = require('mochainon')
Promise = require('bluebird')
resin = require('resin-sdk')
errors = require('resin-errors')
deviceConfig = require('../lib/config')

describe 'Device Config:', ->

	describe '.get()', ->

		describe 'given succesful responses', ->

			beforeEach ->
				@applicationGetApiKeyStub = m.sinon.stub(resin.models.application, 'getApiKey')
				@applicationGetApiKeyStub.returns(Promise.resolve('1234'))

				@authGetUserIdStub = m.sinon.stub(resin.auth, 'getUserId')
				@authGetUserIdStub.returns(Promise.resolve(13))

			afterEach ->
				@applicationGetApiKeyStub.restore()
				@authGetUserIdStub.restore()

			describe 'given a username', ->

				beforeEach ->
					@authWhoamiStub = m.sinon.stub(resin.auth, 'whoami')
					@authWhoamiStub.returns(Promise.resolve('johndoe'))

				afterEach ->
					@authWhoamiStub.restore()

				describe 'given an invalid application', ->

					beforeEach ->
						@applicationGetStub = m.sinon.stub(resin.models.application, 'get')
						@applicationGetStub.returns(Promise.reject(new errors.ResinApplicationNotFound('foo')))

					afterEach ->
						@applicationGetStub.restore()

					it 'should reject with the error', ->
						promise = deviceConfig.get('MyApp', {})
						m.chai.expect(promise).to.be.rejectedWith(errors.ResinApplicationNotFound)

			describe 'given a valid application', ->

				beforeEach ->
					@applicationGetStub = m.sinon.stub(resin.models.application, 'get')
					@applicationGetStub.returns Promise.resolve
						id: 999
						app_name: 'App1'
						device_type: 'raspberry-pi'

				afterEach ->
					@applicationGetStub.restore()

				describe 'given no username', ->

					beforeEach ->
						@authWhoamiStub = m.sinon.stub(resin.auth, 'whoami')
						@authWhoamiStub.returns(Promise.resolve(undefined))

					afterEach ->
						@authWhoamiStub.restore()

					it 'should be rejected', ->
						promise = deviceConfig.get('MyApp', {})
						m.chai.expect(promise).to.be.rejectedWith(errors.ResinNotLoggedIn)

				describe 'given a username', ->

					beforeEach ->
						@authWhoamiStub = m.sinon.stub(resin.auth, 'whoami')
						@authWhoamiStub.returns(Promise.resolve('johndoe'))

					afterEach ->
						@authWhoamiStub.restore()

					it 'should eventually become a valid configuration', ->
						promise = deviceConfig.get('MyApp', {})
						m.chai.expect(promise).to.eventually.become
							applicationId: '999'
							apiKey: '1234'
							deviceType: 'raspberry-pi'
							userId: '13'
							username: 'johndoe'
							wifiSsid: undefined
							wifiKey: undefined
							files:
								'network/settings': '''
									[global]
									OfflineMode=false

									[WiFi]
									Enable=true
									Tethering=false

									[Wired]
									Enable=true
									Tethering=false

									[Bluetooth]
									Enable=true
									Tethering=false
								'''
								'network/network.config': '''
									[service_home_ethernet]
									Type = ethernet
									Nameservers = 8.8.8.8,8.8.4.4
								'''

					it 'should eventually become a valid wifi configuration', ->
						promise = deviceConfig.get 'MyApp',
							wifiSsid: 'foo'
							wifiKey: 'bar'

						m.chai.expect(promise).to.eventually.become
							applicationId: '999'
							apiKey: '1234'
							deviceType: 'raspberry-pi'
							userId: '13'
							username: 'johndoe'
							wifiSsid: 'foo'
							wifiKey: 'bar'
							files:
								'network/settings': '''
									[global]
									OfflineMode=false

									[WiFi]
									Enable=true
									Tethering=false

									[Wired]
									Enable=true
									Tethering=false

									[Bluetooth]
									Enable=true
									Tethering=false
								'''
								'network/network.config': '''
									[service_home_ethernet]
									Type = ethernet
									Nameservers = 8.8.8.8,8.8.4.4

									[service_home_wifi]
									Type = wifi
									Name = foo
									Passphrase = bar
									Nameservers = 8.8.8.8,8.8.4.4
								'''
