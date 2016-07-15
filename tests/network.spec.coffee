m = require('mochainon')
_ = require('lodash')
network = require('../lib/network')

describe 'Network:', ->

	describe '.getFiles()', ->

		it 'should throw an error if options is not an object', ->
			m.chai.expect ->
				network.getFiles(123)
			.to.throw('Invalid options: 123')

		it 'should return an object', ->
			files = network.getFiles()
			m.chai.expect(_.isPlainObject(files)).to.be.true

		describe 'given no options', ->

			it 'should configure for ethernet only', ->
				files = network.getFiles()
				m.chai.expect(files).to.deep.equal
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

		describe 'given static ips', ->

			it 'should configure for ethernet', ->
				files = network.getFiles
					ip: '192.168.1.100'
					netmask: '255.255.255.0'
					gateway: '192.168.1.1'

				m.chai.expect(files['network/network.config']).to.equal '''
					[service_home_ethernet]
					Type = ethernet
					Nameservers = 8.8.8.8,8.8.4.4
					IPv4 = 192.168.1.100/255.255.255.0/192.168.1.1
				'''

			it 'should apply a default netmask', ->
				files = network.getFiles
					ip: '192.168.1.100'
					gateway: '192.168.1.1'

				m.chai.expect(files['network/network.config']).to.equal '''
					[service_home_ethernet]
					Type = ethernet
					Nameservers = 8.8.8.8,8.8.4.4
					IPv4 = 192.168.1.100/255.255.255.0/192.168.1.1
				'''

			it 'should throw if no gateway', ->
				m.chai.expect ->
					network.getFiles
						ip: '192.168.1.100'
				.to.throw('Missing network gateway')

			it 'should configure for both wifi and ethernet', ->
				files = network.getFiles
					wifiSsid: 'mynetwork'
					wifiKey: 'secret'
					ip: '192.168.1.100'
					netmask: '255.255.255.0'
					gateway: '192.168.1.1'

				m.chai.expect(files['network/network.config']).to.equal '''
					[service_home_ethernet]
					Type = ethernet
					Nameservers = 8.8.8.8,8.8.4.4
					IPv4 = 192.168.1.100/255.255.255.0/192.168.1.1

					[service_home_wifi]
					Hidden = true
					Type = wifi
					Name = mynetwork
					Passphrase = secret
					Nameservers = 8.8.8.8,8.8.4.4
					IPv4 = 192.168.1.100/255.255.255.0/192.168.1.1
				'''

		describe 'given a wifi ssid but no key', ->

			it 'should configure for wifi without a passphrase', ->
				files = network.getFiles(wifiSsid: 'foobar')
				m.chai.expect(files).to.deep.equal
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
						Name = foobar
						Nameservers = 8.8.8.8,8.8.4.4
					'''

		describe 'given a wifi ssid and a key', ->

			it 'should configure for wifi with a passphrase', ->
				files = network.getFiles
					wifiSsid: 'foobar'
					wifiKey: 'hello'

				m.chai.expect(files).to.deep.equal
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
						Name = foobar
						Passphrase = hello
						Nameservers = 8.8.8.8,8.8.4.4
					'''
