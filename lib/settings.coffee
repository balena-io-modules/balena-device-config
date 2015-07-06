###
The MIT License

Copyright (c) 2015 Resin.io, Inc. https://resin.io.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
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
