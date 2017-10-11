m = require('mochainon')
Promise = require('bluebird')
timekeeper = require('timekeeper')
resin = require('resin-sdk-preconfigured')
errors = require('resin-errors')
deviceConfig = require('../lib/config')
_ = require('lodash')

describe 'Device Config:', ->

	describe '.generate()', ->

		it 'should pass validation', ->
			config = deviceConfig.generate
				application:
					app_name: 'HelloWorldApp'
					id: 18
					device_type: 'raspberry-pi'
				user:
					id: 7
					username: 'johndoe'
				pubnub:
					subscribe_key: 'demo'
					publish_key: 'demo'
				mixpanel:
					token: 'e3bc4100330c35722740fb8c6f5abddc'
				apiKey: 'asdf'
				vpnPort: 1723
				endpoints:
					api: 'https://api.resin.io'
					vpn: 'vpn.resin.io'
					registry: 'registry.resin.io'
					delta: 'https://delta.resin.io'
			,
				network: 'ethernet'
				appUpdatePollInterval: 50000

			m.chai.expect ->
				deviceConfig.validate(config)
			.to.not.throw(Error)

		it 'should default appUpdatePollInterval to 1 second', ->
			config = deviceConfig.generate
				application:
					app_name: 'HelloWorldApp'
					id: 18
					device_type: 'raspberry-pi'
				user:
					id: 7
					username: 'johndoe'
				pubnub:
					subscribe_key: 'demo'
					publish_key: 'demo'
				mixpanel:
					token: 'e3bc4100330c35722740fb8c6f5abddc'
				apiKey: 'asdf'
				vpnPort: 1723
				endpoints:
					api: 'https://api.resin.io'
					vpn: 'vpn.resin.io'
					registry: 'registry.resin.io'
					delta: 'https://delta.resin.io'
			,
				network: 'ethernet'

			m.chai.expect(config.appUpdatePollInterval).to.equal(60000)

		it 'should include files section if no version is given', ->
			config = deviceConfig.generate
				application:
					app_name: 'HelloWorldApp'
					id: 18
					device_type: 'raspberry-pi'
				user:
					id: 7
					username: 'johndoe'
				pubnub:
					subscribe_key: 'demo'
					publish_key: 'demo'
				mixpanel:
					token: 'e3bc4100330c35722740fb8c6f5abddc'
				apiKey: 'asdf'
				vpnPort: 1723
				endpoints:
					api: 'https://api.resin.io'
					vpn: 'vpn.resin.io'
					registry: 'registry.resin.io'
					delta: 'https://delta.resin.io'
			,
				network: 'ethernet'

			m.chai.expect(config.files).to.exist

		it 'should include files and connectivity sections if the given version is < 2.0.0', ->
			config = deviceConfig.generate
				application:
					app_name: 'HelloWorldApp'
					id: 18
					device_type: 'raspberry-pi'
				user:
					id: 7
					username: 'johndoe'
				pubnub:
					subscribe_key: 'demo'
					publish_key: 'demo'
				mixpanel:
					token: 'e3bc4100330c35722740fb8c6f5abddc'
				apiKey: 'asdf'
				vpnPort: 1723
				endpoints:
					api: 'https://api.resin.io'
					vpn: 'vpn.resin.io'
					registry: 'registry.resin.io'
					delta: 'https://delta.resin.io'
				version: '1.9.999'
				connectivity: 'connman'
			,
				network: 'ethernet'

			m.chai.expect(config.files).to.exist
			m.chai.expect(config.connectivity).to.exist

		it 'should not include files or connectivity sections if the given version is >= 2.0.0', ->
			config = deviceConfig.generate
				application:
					app_name: 'HelloWorldApp'
					id: 18
					device_type: 'raspberry-pi'
				user:
					id: 7
					username: 'johndoe'
				pubnub:
					subscribe_key: 'demo'
					publish_key: 'demo'
				mixpanel:
					token: 'e3bc4100330c35722740fb8c6f5abddc'
				apiKey: 'asdf'
				vpnPort: 1723
				endpoints:
					api: 'https://api.resin.io'
					vpn: 'vpn.resin.io'
					registry: 'registry.resin.io'
					delta: 'https://delta.resin.io'
				version: '2.0.1'
				connectivity: 'connman'
			,
				network: 'ethernet'

			m.chai.expect(config.files).to.not.exist
			m.chai.expect(config.connectivity).to.not.exist

		it 'should default appUpdatePollInterval to 1 second if NaN', ->
			config = deviceConfig.generate
				application:
					app_name: 'HelloWorldApp'
					id: 18
					device_type: 'raspberry-pi'
				user:
					id: 7
					username: 'johndoe'
				pubnub:
					subscribe_key: 'demo'
					publish_key: 'demo'
				mixpanel:
					token: 'e3bc4100330c35722740fb8c6f5abddc'
				apiKey: 'asdf'
				vpnPort: 1723
				endpoints:
					api: 'https://api.resin.io'
					vpn: 'vpn.resin.io'
					registry: 'registry.resin.io'
					delta: 'https://delta.resin.io'
			,
				network: 'ethernet'
				appUpdatePollInterval: NaN

			m.chai.expect(config.appUpdatePollInterval).to.equal(60000)

		it 'should default vpnPort to 1723', ->
			config = deviceConfig.generate
				application:
					app_name: 'HelloWorldApp'
					id: 18
					device_type: 'raspberry-pi'
				user:
					id: 7
					username: 'johndoe'
				pubnub:
					subscribe_key: 'demo'
					publish_key: 'demo'
				mixpanel:
					token: 'e3bc4100330c35722740fb8c6f5abddc'
				apiKey: 'asdf'
				endpoints:
					api: 'https://api.resin.io'
					vpn: 'vpn.resin.io'
					registry: 'registry.resin.io'
					delta: 'https://delta.resin.io'
			,
				network: 'ethernet'

			m.chai.expect(config.vpnPort).to.equal(1723)

		it 'should handle wifi configuration', ->
			config = deviceConfig.generate
				application:
					app_name: 'HelloWorldApp'
					id: 18
					device_type: 'raspberry-pi'
				user:
					id: 7
					username: 'johndoe'
				pubnub:
					subscribe_key: 'demo'
					publish_key: 'demo'
				mixpanel:
					token: 'e3bc4100330c35722740fb8c6f5abddc'
				apiKey: 'asdf'
				endpoints:
					api: 'https://api.resin.io'
					vpn: 'vpn.resin.io'
					registry: 'registry.resin.io'
					delta: 'https://delta.resin.io'
			,
				network: 'wifi'
				wifiSsid: 'mywifi'
				wifiKey: 'secret'

			m.chai.expect(config.wifiSsid).to.equal('mywifi')
			m.chai.expect(config.wifiKey).to.equal('secret')

		it 'should parse vpnPort as an integer automatically', ->
			config = deviceConfig.generate
				application:
					app_name: 'HelloWorldApp'
					id: 18
					device_type: 'raspberry-pi'
				user:
					id: 7
					username: 'johndoe'
				pubnub:
					subscribe_key: 'demo'
					publish_key: 'demo'
				mixpanel:
					token: 'e3bc4100330c35722740fb8c6f5abddc'
				apiKey: 'asdf'
				vpnPort: '1234'
				endpoints:
					api: 'https://api.resin.io'
					vpn: 'vpn.resin.io'
					registry: 'registry.resin.io'
					delta: 'https://delta.resin.io'
			,
				network: 'wifi'
				wifiSsid: 'mywifi'
				wifiKey: 'secret'

			m.chai.expect(config.vpnPort).to.equal(1234)

		it 'should throw an error if vpnPort becomes NaN', ->
			m.chai.expect ->
				config = deviceConfig.generate
					application:
						app_name: 'HelloWorldApp'
						id: 18
						device_type: 'raspberry-pi'
					user:
						id: 7
						username: 'johndoe'
					pubnub:
						subscribe_key: 'demo'
						publish_key: 'demo'
					mixpanel:
						token: 'e3bc4100330c35722740fb8c6f5abddc'
					apiKey: 'asdf'
					vpnPort: 'hello'
					endpoints:
						api: 'https://api.resin.io'
						vpn: 'vpn.resin.io'
						registry: 'registry.resin.io'
						delta: 'https://delta.resin.io'
				,
					network: 'wifi'
					wifiSsid: 'mywifi'
					wifiKey: 'secret'
			.to.throw('Validation: vpnPort must be of number type')

		it 'should throw an error if vpnPort is NaN', ->
			m.chai.expect ->
				config = deviceConfig.generate
					application:
						app_name: 'HelloWorldApp'
						id: 18
						device_type: 'raspberry-pi'
					user:
						id: 7
						username: 'johndoe'
					pubnub:
						subscribe_key: 'demo'
						publish_key: 'demo'
					mixpanel:
						token: 'e3bc4100330c35722740fb8c6f5abddc'
					apiKey: 'asdf'
					vpnPort: NaN
					endpoints:
						api: 'https://api.resin.io'
						vpn: 'vpn.resin.io'
						registry: 'registry.resin.io'
						delta: 'https://delta.resin.io'
				,
					network: 'wifi'
					wifiSsid: 'mywifi'
					wifiKey: 'secret'
			.to.throw('Validation: vpnPort is NaN')

		it 'should allow deltaEndpoint to be undefined', ->
			config = null
			m.chai.expect ->
				config = deviceConfig.generate
					application:
						app_name: 'HelloWorldApp'
						id: 18
						device_type: 'raspberry-pi'
					user:
						id: 7
						username: 'johndoe'
					pubnub:
						subscribe_key: 'demo'
						publish_key: 'demo'
					mixpanel:
						token: 'e3bc4100330c35722740fb8c6f5abddc'
					apiKey: 'asdf'
					vpnPort: '1234'
					endpoints:
						api: 'https://api.resin.io'
						vpn: 'vpn.resin.io'
						registry: 'registry.resin.io'
				,
					network: 'wifi'
					wifiSsid: 'mywifi'
					wifiKey: 'secret'
			.to.not.throw('Validation: deltaEndpoint is required')
			m.chai.expect(config.deltaEndpoint).to.not.exist

	describe '.validate()', ->

		it 'should throw an error for an invalid property', ->
			m.chai.expect ->
				deviceConfig.generate
					application:
						id: 18
						device_type: 'raspberry-pi'
					user:
						id: 7
						username: 'johndoe'
					pubnub:
						subscribe_key: 'demo'
						publish_key: 'demo'
					mixpanel:
						token: 'e3bc4100330c35722740fb8c6f5abddc'
					apiKey: 'asdf'
					endpoints:
						api: 'https://api.resin.io'
						vpn: 'vpn.resin.io'
						registry: 'registry.resin.io'
						delta: 'https://delta.resin.io'
				,
					network: 'ethernet'
			.to.throw('Validation: applicationName is required')

		it 'should throw an error if the config json contains extra properties', ->
			config = deviceConfig.generate
				application:
					app_name: 'HelloWorldApp'
					id: 18
					device_type: 'raspberry-pi'
				user:
					id: 7
					username: 'johndoe'
				pubnub:
					subscribe_key: 'demo'
					publish_key: 'demo'
				mixpanel:
					token: 'e3bc4100330c35722740fb8c6f5abddc'
				apiKey: 'asdf'
				vpnPort: 1723
				endpoints:
					api: 'https://api.resin.io'
					vpn: 'vpn.resin.io'
					registry: 'registry.resin.io'
					delta: 'https://delta.resin.io'
			,
				network: 'ethernet'

			config.foo = 'bar'

			m.chai.expect ->
				deviceConfig.validate(config)
			.to.throw('Validation: foo not recognized')

	describe '.getByDevice()', ->

		describe 'given successful responses', ->

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

				@configGetPubNubKeysStub = m.sinon.stub(resin.models.config, 'getPubNubKeys')
				@configGetPubNubKeysStub.returns Promise.resolve
					publish_key: '1234'
					subscribe_key: '5678'

				@configGetMixpanelToken = m.sinon.stub(resin.models.config, 'getMixpanelToken')
				@configGetMixpanelToken.returns(Promise.resolve('asdf'))

			afterEach ->
				@deviceGetStub.restore()
				@applicationGetApiKeyStub.restore()
				@authGetUserIdStub.restore()
				@configGetPubNubKeysStub.restore()
				@configGetMixpanelToken.restore()

			describe 'given a username', ->

				beforeEach ->
					@authWhoamiStub = m.sinon.stub(resin.auth, 'whoami')
					@authWhoamiStub.returns(Promise.resolve('johndoe'))

				afterEach ->
					@authWhoamiStub.restore()

				describe 'given an invalid application', ->

					beforeEach ->
						@applicationGetStub = m.sinon.stub(resin.models.application, 'get')
						@applicationGetStub.withArgs('App1').returns(Promise.delay(1).throw(new errors.ResinApplicationNotFound('foo')))

					afterEach ->
						@applicationGetStub.restore()

					it 'should reject with the error', ->
						promise = deviceConfig.getByDevice('7cf02a62a3a84440b1bb5579a3d57469148943278630b17e7fc6c4f7b465c9', '4321', {})
						m.chai.expect(promise).to.eventually.be.rejectedWith(errors.ResinApplicationNotFound)

				describe 'given an invalid device api key', ->

					it 'should reject with the error', ->
						promise = deviceConfig.getByDevice('7cf02a62a3a84440b1bb5579a3d57469148943278630b17e7fc6c4f7b465c9')
						m.chai.expect(promise).to.eventually.be.rejectedWith(Error)

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

						config =
							applicationId: 999
							applicationName: 'App1'
							apiEndpoint: 'https://api.resin.io'
							vpnPort: 1723
							vpnEndpoint: 'vpn.resin.io'
							registryEndpoint: 'registry.resin.io'
							deltaEndpoint: 'https://delta.resin.io'
							deviceId: 3
							uuid: '7cf02a62a3a84440b1bb5579a3d57469148943278630b17e7fc6c4f7b465c9'
							deviceApiKey: '4321'
							deviceType: 'raspberry-pi'
							userId: 13
							listenPort: 48484
							pubnubSubscribeKey: '5678'
							pubnubPublishKey: '1234'
							mixpanelToken: 'asdf'
							registered_at: 15000
							username: 'johndoe'
							appUpdatePollInterval: 60000
							connectivity: 'connman'
							files:
								'network/settings': '''
									[global]
									OfflineMode=false
									TimeUpdates=manual

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

						it 'should eventually become a valid device key configuration', ->
							promise = deviceConfig.getByDevice('7cf02a62a3a84440b1bb5579a3d57469148943278630b17e7fc6c4f7b465c9', '4321', {})
							m.chai.expect(promise).to.eventually.become config

						it 'should eventually become a valid wifi configuration', ->
							promise = deviceConfig.getByDevice '7cf02a62a3a84440b1bb5579a3d57469148943278630b17e7fc6c4f7b465c9', '4321',
								wifiSsid: 'foo'
								wifiKey: 'bar'

							m.chai.expect(promise).to.eventually.become _.assign {}, config,
								files:
									'network/settings': '''
										[global]
										OfflineMode=false
										TimeUpdates=manual

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
										Hidden = true
										Type = wifi
										Name = foo
										Passphrase = bar
										Nameservers = 8.8.8.8,8.8.4.4
									'''

						it 'should expand a shorter uuid by default', ->
							promise = deviceConfig.getByDevice('7cf02a6', '4321', {})
							m.chai.expect(promise).to.eventually.become config

	describe '.getByApplication()', ->

		describe 'given successful responses', ->

			beforeEach ->
				@applicationGetStub = m.sinon.stub(resin.models.application, 'get')
				@applicationGetStub.returns Promise.resolve
					id: 3
					app_name: 'App1'
					device_type: 'raspberry-pi'

				@applicationGetApiKeyStub = m.sinon.stub(resin.models.application, 'getApiKey')
				@applicationGetApiKeyStub.withArgs('App1').returns(Promise.resolve('1234'))

				@authGetUserIdStub = m.sinon.stub(resin.auth, 'getUserId')
				@authGetUserIdStub.returns(Promise.resolve(13))

				@configGetPubNubKeysStub = m.sinon.stub(resin.models.config, 'getPubNubKeys')
				@configGetPubNubKeysStub.returns Promise.resolve
					publish_key: '1234'
					subscribe_key: '5678'

				@configGetMixpanelToken = m.sinon.stub(resin.models.config, 'getMixpanelToken')
				@configGetMixpanelToken.returns(Promise.resolve('asdf'))

			afterEach ->
				@applicationGetStub.restore()
				@applicationGetApiKeyStub.restore()
				@authGetUserIdStub.restore()
				@configGetPubNubKeysStub.restore()
				@configGetMixpanelToken.restore()

			describe 'given a username', ->

				beforeEach ->
					@authWhoamiStub = m.sinon.stub(resin.auth, 'whoami')
					@authWhoamiStub.returns(Promise.resolve('johndoe'))

				afterEach ->
					@authWhoamiStub.restore()

				it 'should eventually become a valid configuration', ->
					promise = deviceConfig.getByApplication('App1', {})
					m.chai.expect(promise).to.eventually.become
						applicationId: 3
						applicationName: 'App1'
						apiEndpoint: 'https://api.resin.io'
						vpnPort: 1723
						vpnEndpoint: 'vpn.resin.io'
						registryEndpoint: 'registry.resin.io'
						deltaEndpoint: 'https://delta.resin.io'
						apiKey: '1234'
						deviceType: 'raspberry-pi'
						userId: 13
						listenPort: 48484
						pubnubSubscribeKey: '5678'
						pubnubPublishKey: '1234'
						mixpanelToken: 'asdf'
						username: 'johndoe'
						appUpdatePollInterval: 60000
						connectivity: 'connman'
						files:
							'network/settings': '''
								[global]
								OfflineMode=false
								TimeUpdates=manual

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
					promise = deviceConfig.getByApplication 'App1',
						wifiSsid: 'foo'
						wifiKey: 'bar'

					m.chai.expect(promise).to.eventually.become
						applicationId: 3
						applicationName: 'App1'
						deltaEndpoint: 'https://delta.resin.io'
						apiEndpoint: 'https://api.resin.io'
						vpnPort: 1723
						vpnEndpoint: 'vpn.resin.io'
						registryEndpoint: 'registry.resin.io'
						apiKey: '1234'
						deviceType: 'raspberry-pi'
						userId: 13
						listenPort: 48484
						pubnubSubscribeKey: '5678'
						pubnubPublishKey: '1234'
						mixpanelToken: 'asdf'
						username: 'johndoe'
						appUpdatePollInterval: 60000
						connectivity: 'connman'
						files:
							'network/settings': '''
								[global]
								OfflineMode=false
								TimeUpdates=manual

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
								Hidden = true
								Type = wifi
								Name = foo
								Passphrase = bar
								Nameservers = 8.8.8.8,8.8.4.4
							'''
