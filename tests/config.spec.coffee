m = require('mochainon')
deviceConfig = require('../build/config')

describe 'Device Config:', ->

	describe '.generate()', ->

		it 'should pass validation', ->
			config = deviceConfig.generate
				application:
					id: 18
					device_type: 'raspberry-pi'
				apiKey: 'asdf'
				vpnPort: 443
				endpoints:
					api: 'https://api.balena-cloud.com'
					vpn: 'vpn.balena-cloud.com'
					registry: 'registry.balena-cloud.com'
					delta: 'https://delta.balena-cloud.com'
					logs: 'https://logs.balena-cloud.com'
			,
				network: 'ethernet'
				appUpdatePollInterval: 50000
				balenaRootCA: 'abcdef1234567890'

			m.chai.expect ->
				deviceConfig.validate(config)
			.to.not.throw(Error)

		it 'should default appUpdatePollInterval to 1 second', ->
			config = deviceConfig.generate
				application:
					id: 18
					device_type: 'raspberry-pi'
				apiKey: 'asdf'
				vpnPort: 443
				endpoints:
					api: 'https://api.balena-cloud.com'
					vpn: 'vpn.balena-cloud.com'
					registry: 'registry.balena-cloud.com'
					delta: 'https://delta.balena-cloud.com'
			,
				network: 'ethernet'

			m.chai.expect(config.appUpdatePollInterval).to.equal(60000)

		it 'should default to the application device type when an explicit one is not provided', ->
			config = deviceConfig.generate
				application:
					id: 18
					device_type: 'raspberry-pi2'
				apiKey: 'asdf'
				vpnPort: 443
				endpoints:
					api: 'https://api.balena-cloud.com'
					vpn: 'vpn.balena-cloud.com'
					registry: 'registry.balena-cloud.com'
					delta: 'https://delta.balena-cloud.com'
				version: '1.9.999'
				connectivity: 'connman'
			,
				network: 'ethernet'

			m.chai.expect(config.deviceType).to.equal('raspberry-pi2')

		it 'should add logsEndpoint if it exists', ->
			config = deviceConfig.generate
				application:
					id: 18
					device_type: 'raspberry-pi2'
				apiKey: 'asdf'
				vpnPort: 443
				endpoints:
					api: 'https://api.balena-cloud.com'
					vpn: 'vpn.balena-cloud.com'
					registry: 'registry.balena-cloud.com'
					delta: 'https://delta.balena-cloud.com'
					logs: 'https://logs.balena-cloud.com'
				version: '1.9.999'
				connectivity: 'connman'
			,
				network: 'ethernet'

			m.chai.expect(config.logsEndpoint).to.equal('https://logs.balena-cloud.com')

		it 'should not include logsEndpoint if url is not provided', ->
			config = deviceConfig.generate
				application:
					id: 18
					device_type: 'raspberry-pi2'
				apiKey: 'asdf'
				vpnPort: 443
				endpoints:
					api: 'https://api.balena-cloud.com'
					vpn: 'vpn.balena-cloud.com'
					registry: 'registry.balena-cloud.com'
					delta: 'https://delta.balena-cloud.com'
				version: '1.9.999'
				connectivity: 'connman'
			,
				network: 'ethernet'

			m.chai.expect(config.logsEndpoint).to.not.exist

		it 'should use the provided device type instead of the application one', ->
			config = deviceConfig.generate
				application:
					id: 18
					device_type: 'raspberry-pi2'
				deviceType: 'raspberrypi3'
				apiKey: 'asdf'
				vpnPort: 443
				endpoints:
					api: 'https://api.balena-cloud.com'
					vpn: 'vpn.balena-cloud.com'
					registry: 'registry.balena-cloud.com'
					delta: 'https://delta.balena-cloud.com'
				version: '1.9.999'
				connectivity: 'connman'
			,
				network: 'ethernet'

			m.chai.expect(config.deviceType).to.equal('raspberrypi3')

		it 'should include files section if no version is given', ->
			config = deviceConfig.generate
				application:
					id: 18
					device_type: 'raspberry-pi'
				apiKey: 'asdf'
				vpnPort: 443
				endpoints:
					api: 'https://api.balena-cloud.com'
					vpn: 'vpn.balena-cloud.com'
					registry: 'registry.balena-cloud.com'
					delta: 'https://delta.balena-cloud.com'
			,
				network: 'ethernet'

			m.chai.expect(config.files).to.exist

		it 'should include files and connectivity sections if the given version is < 2.0.0', ->
			config = deviceConfig.generate
				application:
					id: 18
					device_type: 'raspberry-pi'
				apiKey: 'asdf'
				vpnPort: 443
				endpoints:
					api: 'https://api.balena-cloud.com'
					vpn: 'vpn.balena-cloud.com'
					registry: 'registry.balena-cloud.com'
					delta: 'https://delta.balena-cloud.com'
				version: '1.9.999'
				connectivity: 'connman'
			,
				network: 'ethernet'

			m.chai.expect(config.files).to.exist
			m.chai.expect(config.connectivity).to.exist

		it 'should not include files or connectivity sections if the given version is >= 2.0.0', ->
			config = deviceConfig.generate
				application:
					id: 18
					device_type: 'raspberry-pi'
				apiKey: 'asdf'
				vpnPort: 443
				endpoints:
					api: 'https://api.balena-cloud.com'
					vpn: 'vpn.balena-cloud.com'
					registry: 'registry.balena-cloud.com'
					delta: 'https://delta.balena-cloud.com'
				version: '2.0.1'
				connectivity: 'connman'
			,
				network: 'ethernet'

			m.chai.expect(config.files).to.not.exist
			m.chai.expect(config.connectivity).to.not.exist

		it 'should default appUpdatePollInterval to 1 second if NaN', ->
			config = deviceConfig.generate
				application:
					id: 18
					device_type: 'raspberry-pi'
				apiKey: 'asdf'
				vpnPort: 443
				endpoints:
					api: 'https://api.balena-cloud.com'
					vpn: 'vpn.balena-cloud.com'
					registry: 'registry.balena-cloud.com'
					delta: 'https://delta.balena-cloud.com'
			,
				network: 'ethernet'
				appUpdatePollInterval: NaN

			m.chai.expect(config.appUpdatePollInterval).to.equal(60000)

		it 'should default vpnPort to 443', ->
			config = deviceConfig.generate
				application:
					id: 18
					device_type: 'raspberry-pi'
				apiKey: 'asdf'
				endpoints:
					api: 'https://api.balena-cloud.com'
					vpn: 'vpn.balena-cloud.com'
					registry: 'registry.balena-cloud.com'
					delta: 'https://delta.balena-cloud.com'
			,
				network: 'ethernet'

			m.chai.expect(config.vpnPort).to.equal(443)

		it 'should handle wifi configuration', ->
			config = deviceConfig.generate
				application:
					id: 18
					device_type: 'raspberry-pi'
				apiKey: 'asdf'
				endpoints:
					api: 'https://api.balena-cloud.com'
					vpn: 'vpn.balena-cloud.com'
					registry: 'registry.balena-cloud.com'
					delta: 'https://delta.balena-cloud.com'
			,
				network: 'wifi'
				wifiSsid: 'mywifi'
				wifiKey: 'secret'

			m.chai.expect(config.wifiSsid).to.equal('mywifi')
			m.chai.expect(config.wifiKey).to.equal('secret')

		it 'should handle multiple network configurations', ->
			config = deviceConfig.generate
				application:
					id: 18
					device_type: 'raspberry-pi'
				apiKey: 'asdf'
				endpoints:
					api: 'https://api.balena-cloud.com'
					vpn: 'vpn.balena-cloud.com'
					registry: 'registry.balena-cloud.com'
					delta: 'https://delta.balena-cloud.com'
			,
				network: [
						wifiSsid: 'mywifi1'
						wifiKey: 'secret1'
					,
						wifiSsid: 'mywifi2'
						wifiKey: 'secret2'
					,
						configuration: 'Lorem ipsum dolor sit amet'
				]

			m.chai.expect(config.network[0].wifiSsid).to.equal('mywifi1')
			m.chai.expect(config.network[0].wifiKey).to.equal('secret1')
			m.chai.expect(config.network[1].wifiSsid).to.equal('mywifi2')
			m.chai.expect(config.network[1].wifiKey).to.equal('secret2')
			m.chai.expect(config.network[2].configuration).to.equal('Lorem ipsum dolor sit amet')

		it 'should parse vpnPort as an integer automatically', ->
			config = deviceConfig.generate
				application:
					id: 18
					device_type: 'raspberry-pi'
				apiKey: 'asdf'
				vpnPort: '1234'
				endpoints:
					api: 'https://api.balena-cloud.com'
					vpn: 'vpn.balena-cloud.com'
					registry: 'registry.balena-cloud.com'
					delta: 'https://delta.balena-cloud.com'
			,
				network: 'wifi'
				wifiSsid: 'mywifi'
				wifiKey: 'secret'

			m.chai.expect(config.vpnPort).to.equal(1234)

		it 'should throw an error if vpnPort becomes NaN', ->
			m.chai.expect ->
				deviceConfig.generate
					application:
						id: 18
						device_type: 'raspberry-pi'
					apiKey: 'asdf'
					vpnPort: 'hello'
					endpoints:
						api: 'https://api.balena-cloud.com'
						vpn: 'vpn.balena-cloud.com'
						registry: 'registry.balena-cloud.com'
						delta: 'https://delta.balena-cloud.com'
				,
					network: 'wifi'
					wifiSsid: 'mywifi'
					wifiKey: 'secret'
			.to.throw('Validation: vpnPort must be of number type')

		it 'should throw an error if vpnPort is NaN', ->
			m.chai.expect ->
				deviceConfig.generate
					application:
						id: 18
						device_type: 'raspberry-pi'
					apiKey: 'asdf'
					vpnPort: NaN
					endpoints:
						api: 'https://api.balena-cloud.com'
						vpn: 'vpn.balena-cloud.com'
						registry: 'registry.balena-cloud.com'
						delta: 'https://delta.balena-cloud.com'
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
						id: 18
						device_type: 'raspberry-pi'
					apiKey: 'asdf'
					vpnPort: '1234'
					endpoints:
						api: 'https://api.balena-cloud.com'
						vpn: 'vpn.balena-cloud.com'
						registry: 'registry.balena-cloud.com'
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
						device_type: 'raspberry-pi'
					apiKey: 'asdf'
					endpoints:
						api: 'https://api.balena-cloud.com'
						vpn: 'vpn.balena-cloud.com'
						registry: 'registry.balena-cloud.com'
						delta: 'https://delta.balena-cloud.com'
				,
					network: 'ethernet'
			.to.throw('Validation: applicationId is required')

		it 'should throw an error if the config json contains extra properties', ->
			config = deviceConfig.generate
				application:
					id: 18
					device_type: 'raspberry-pi'
				apiKey: 'asdf'
				vpnPort: 443
				endpoints:
					api: 'https://api.balena-cloud.com'
					vpn: 'vpn.balena-cloud.com'
					registry: 'registry.balena-cloud.com'
					delta: 'https://delta.balena-cloud.com'
			,
				network: 'ethernet'

			config.foo = 'bar'

			m.chai.expect ->
				deviceConfig.validate(config)
			.to.throw('Validation: foo not recognized')

		it 'should allow balenaRootCA to be undefined', ->
			config = deviceConfig.generate
				application:
					id: 18
					device_type: 'raspberry-pi'
				apiKey: 'asdf'
				vpnPort: '1234'
				endpoints:
					api: 'https://api.balena-cloud.com'
					vpn: 'vpn.balena-cloud.com'
					registry: 'registry.balena-cloud.com'
			,
				network: 'wifi'
				wifiSsid: 'mywifi'
				wifiKey: 'secret'
			m.chai.expect(config.balenaRootCA).to.not.exist

		it 'should allow config without pubnub keys', ->
			config = {
				applicationName: 'app',
				applicationId: 123,
				deviceType: 'devicetype',
				userId: 123,
				username: 'username',
				appUpdatePollInterval: 60000,
				listenPort: 48484,
				vpnPort: 443,
				apiEndpoint: 'https://api.com',
				vpnEndpoint: 'https://vpn.com',
				registryEndpoint: 'https://registry.com',
				deltaEndpoint: undefined,
				mixpanelToken: 'mixpanel'
			}

			m.chai.expect ->
				deviceConfig.validate(config)
			.to.not.throw(Error)

		it 'should allow config with empty pubnub keys', ->
			config = {
				applicationName: 'app',
				applicationId: 123,
				deviceType: 'devicetype',
				userId: 123,
				username: 'username',
				appUpdatePollInterval: 60000,
				listenPort: 48484,
				vpnPort: 443,
				apiEndpoint: 'https://api.com',
				vpnEndpoint: 'https://vpn.com',
				registryEndpoint: 'https://registry.com',
				deltaEndpoint: undefined,
				pubnubSubscribeKey: '',
				pubnubPublishKey: '',
				mixpanelToken: 'mixpanel'
			}

			m.chai.expect ->
				deviceConfig.validate(config)
			.to.not.throw(Error)
