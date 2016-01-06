###
Copyright 2016 Resin.io

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
###

_ = require('lodash')

###*
# @summary Main network settings
# @constant
# @protected
# @type {String}
###
exports.main = '''
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

###*
# @summary Get ethernet/wifi network settings
# @function
# @protected
#
# @param {Object} options - options
# @param {String} [options.wifiSsid] - wifi ssid
# @param {String} [options.wifiKey] - wifi key
#
# @returns {String} Network configuration.
#
# @example
# networkSettings = settings.getHomeSettings
#		wifiSsid: 'foobar'
#		wifiKey: 'hello'
###
exports.getHomeSettings = (options) ->

	config = '''
		[service_home_ethernet]
		Type = ethernet
		Nameservers = 8.8.8.8,8.8.4.4
	'''

	if not _.isEmpty(options.wifiSsid?.trim())
		config += """\n
			[service_home_wifi]
			Type = wifi
			Name = #{options.wifiSsid}
		"""

		if options.wifiKey
			config += "\nPassphrase = #{options.wifiKey}"

		config += '\nNameservers = 8.8.8.8,8.8.4.4'

	return config
