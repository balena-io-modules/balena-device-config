###
Copyright 2016 Balena

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
# @summary config.json validation schema
# @name schema
# @type {Object}
#
# @description
# This is a `revalidator` schema. Refer to the following documentation:
#
#		https://github.com/flatiron/revalidator
###
module.exports =
	properties:
		# Included for backwards compatibility - it does not exist in modern config files
		applicationName:
			description: 'application name'
			type: 'string'
			required: false
			allowEmpty: false
		applicationId:
			description: 'application id'
			type: 'number'
			minimum: 0
			required: true
		deviceType:
			description: 'device type'
			type: 'string'
			required: true
			allowEmpty: false
		# Included for backwards compatibility - it does not exist in modern config files
		userId:
			description: 'user id'
			type: 'number'
			minimum: 0
			required: false
		# Included for backwards compatibility - it does not exist in modern config files
		username:
			description: 'username'
			type: 'string'
			required: false
			allowEmpty: false
		files:
			description: 'files'
			type: 'object'
			required: false
			properties:
				'network/settings':
					description: 'network settings'
					type: 'string'
					required: true
					allowEmpty: false
				'network/network.config':
					description: 'network config'
					type: 'string'
					required: true
					allowEmpty: false
		appUpdatePollInterval:
			description: 'app update poll interval'
			type: 'number'
			minimum: 0
			required: true
		listenPort:
			description: 'listen port'
			type: 'number'
			minimum: 0
			required: true
		# Included for backwards compatibility - it does not exist in modern config files
		vpnPort:
			description: 'vpn port'
			type: 'number'
			minimum: 0
			required: false
			conform: _.negate(_.isNaN)
			messages:
				conform: 'is NaN'
		apiEndpoint:
			description: 'api endpoint'
			type: 'string'
			required: true
			allowEmpty: false
			format: 'url'
		deltaEndpoint:
			description: 'delta endpoint'
			type: 'string'
			required: false
			allowEmpty: false
			format: 'url'
		# Included for backwards compatibility - it does not exist in modern config files
		vpnEndpoint:
			description: 'vpn endpoint'
			type: 'string'
			required: false
			allowEmpty: false
			format: 'host-name'
		registryEndpoint:
			description: 'registry endpoint'
			type: 'string'
			required: true
			allowEmpty: false
			format: 'host-name'
		logsEndpoint:
			description: 'logs endpoint'
			type: 'string'
			required: false
			allowEmpty: false
			format: 'url'
		# Included for backwards compatibility - it does not exist in modern config files
		pubnubSubscribeKey:
			description: 'pubnub subscribe key'
			type: 'string'
			required: false
			allowEmpty: true
		# Included for backwards compatibility - it does not exist in modern config files
		pubnubPublishKey:
			description: 'pubnub publish key'
			type: 'string'
			required: false
			allowEmpty: true
		# Included for backwards compatibility - it does not exist in modern config files
		mixpanelToken:
			description: 'mixpanel token'
			type: 'string'
			required: false
			allowEmpty: false
		balenaRootCA:
			description: 'balena root CA'
			type: 'string'
			required: false
			allowEmpty: false
		# An api key is required, but it can be either apiKey or deviceApiKey (not both)
		apiKey:
			description: 'api key'
			type: 'string'
			required: false
			allowEmpty: false
		# The device api key is only useful if coupled with a uuid
		deviceApiKey:
			description: 'device api key'
			type: 'string'
			required: false
			allowEmpty: false
		registered_at:
			description: 'registered at'
			type: 'number'
			minimum: 0
			format: 'utc-millisec'
		deviceId:
			description: 'device id'
			type: 'number'
			minimum: 0
		uuid:
			description: 'uuid'
			type: 'string'
			allowEmpty: false
			pattern: /^[0-9a-f]{32,62}$/
		wifiSsid:
			description: 'wifi ssid'
			type: 'string'
			allowEmpty: true
		wifiKey:
			description: 'wifi key'
			type: 'string'
			allowEmpty: true
		connectivity:
			description: 'network management software'
			type: 'string'
			allowEmpty: false
			enum: ['NetworkManager', 'connman']
			default: 'connman'
		network:
			description: 'network configurations'
			type: 'array'
			required: false
			items:
				type: 'object'
				properties:
					wifiSsid:
						description: 'wifi ssid'
						type: 'string'
						allowEmpty: true
					wifiKey:
						description: 'wifi key'
						type: 'string'
						allowEmpty: true
					configuration:
						description: 'configuration'
						type: 'string'
						allowEmpty: true
