m = require('mochainon')
Promise = require('bluebird')
timekeeper = require('timekeeper')
resin = require('resin-sdk')
errors = require('resin-errors')
deviceConfig = require('../lib/config')

describe 'Device Config:', ->

	describe '.get()', ->

		describe 'given succesful responses', ->

			beforeEach ->
				@deviceGetStub = m.sinon.stub(resin.models.device, 'get')
				@deviceGetStub.returns Promise.resolve
					id: 3
					application_name: 'App1'
					device_type: 'raspberry-pi'
					uuid: '7cf02a62a3a84440b1bb5579a3d57469148943278630b17e7fc6c4f7b465c9'

				@applicationGetApiKeyStub = m.sinon.stub(resin.models.application, 'getApiKey')
				@applicationGetApiKeyStub.withArgs('App1').returns(Promise.resolve('1234'))

				@authGetUserIdStub = m.sinon.stub(resin.auth, 'getUserId')
				@authGetUserIdStub.returns(Promise.resolve(13))

			afterEach ->
				@deviceGetStub.restore()
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
						@applicationGetStub.withArgs('App1').returns(Promise.reject(new errors.ResinApplicationNotFound('foo')))

					afterEach ->
						@applicationGetStub.restore()

					it 'should reject with the error', ->
						promise = deviceConfig.get('7cf02a62a3a84440b1bb5579a3d57469148943278630b17e7fc6c4f7b465c9', {})
						m.chai.expect(promise).to.be.rejectedWith(errors.ResinApplicationNotFound)

			describe 'given a valid application', ->

				beforeEach ->
					@applicationGetStub = m.sinon.stub(resin.models.application, 'get')
					@applicationGetStub.withArgs('App1').returns Promise.resolve
						id: 999
						app_name: 'App1'
						device_type: 'raspberry-pi'

				afterEach ->
					@applicationGetStub.restore()

				describe 'given a username', ->

					beforeEach ->
						@authWhoamiStub = m.sinon.stub(resin.auth, 'whoami')
						@authWhoamiStub.returns(Promise.resolve('johndoe'))

					afterEach ->
						@authWhoamiStub.restore()

					describe 'given a fixed time', ->

						beforeEach ->
							@currentTime = new Date(15000000)
							timekeeper.freeze(@currentTime)

						afterEach ->
							timekeeper.reset()

						it 'should eventually become a valid configuration', ->
							promise = deviceConfig.get('7cf02a62a3a84440b1bb5579a3d57469148943278630b17e7fc6c4f7b465c9', {})
							m.chai.expect(promise).to.eventually.become
								applicationId: '999'
								apiEndpoint: 'https://api.resin.io'
								vpnEndpoint: 'vpn.resin.io'
								registryEndpoint: 'registry.resin.io'
								deviceId: 3
								uuid: '7cf02a62a3a84440b1bb5579a3d57469148943278630b17e7fc6c4f7b465c9'
								apiKey: '1234'
								deviceType: 'raspberry-pi'
								userId: '13'
								registered_at: 15000
								username: 'johndoe'
								appUpdatePollInterval: '60000'
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
							promise = deviceConfig.get '7cf02a62a3a84440b1bb5579a3d57469148943278630b17e7fc6c4f7b465c9',
								wifiSsid: 'foo'
								wifiKey: 'bar'

							m.chai.expect(promise).to.eventually.become
								applicationId: '999'
								apiEndpoint: 'https://api.resin.io'
								vpnEndpoint: 'vpn.resin.io'
								registryEndpoint: 'registry.resin.io'
								deviceId: 3
								uuid: '7cf02a62a3a84440b1bb5579a3d57469148943278630b17e7fc6c4f7b465c9'
								apiKey: '1234'
								deviceType: 'raspberry-pi'
								userId: '13'
								registered_at: 15000
								username: 'johndoe'
								appUpdatePollInterval: '60000'
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
