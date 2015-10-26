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

###*
# @module deviceConfig
###

_ = require('lodash')
Promise = require('bluebird')
resin = require('resin-sdk')
errors = require('resin-errors')
revalidator = require('revalidator')
network = require('./network')
schema = require('./schema')

###*
# @summary Generate a basic config.json object
# @function
# @public
#
# @param {Object} options - options
# @param {Object} params - user params
#
# @returns {Object} config.json
#
# @example
# config = deviceConfig.generate
# 	application:
# 		app_name: 'HelloWorldApp'
# 		id: 18
# 		device_type: 'raspberry-pi'
# 	user:
# 		id: 7
# 		username: 'johndoe'
# 	pubnub:
# 		subscribe_key: 'demo'
# 		publish_key: 'demo'
# 	mixpanel:
# 		token: 'e3bc4100330c35722740fb8c6f5abddc'
# 	apiKey: 'asdf'
# 	vpnPort: 1723
# 	endpoints:
# 		api: 'https://api.resin.io'
# 		vpn: 'vpn.resin.io'
# 		registry: 'registry.resin.io'
# ,
# 	network: 'ethernet'
# 	appUpdatePollInterval: 50000
#
# console.log(config)
###
exports.generate = (options, params = {}) ->
	config =
		applicationName: options.application.app_name
		applicationId: options.application.id
		deviceType: options.application.device_type
		userId: options.user.id
		username: options.user.username

		files: network.getFiles(params)
		appUpdatePollInterval: params.appUpdatePollInterval or 60000

		listenPort: 48484
		vpnPort: options.vpnPort or 1723

		apiEndpoint: options.endpoints.api
		vpnEndpoint: options.endpoints.vpn
		registryEndpoint: options.endpoints.registry

		pubnubSubscribeKey: options.pubnub.subscribe_key
		pubnubPublishKey: options.pubnub.publish_key
		mixpanelToken: options.mixpanel.token
		apiKey: options.apiKey

	if params.network is 'wifi'
		config.wifiSsid = params.wifiSsid
		config.wifiKey = params.wifiKey

	exports.validate(config)
	return config

###*
# @summary Validate a generated config.json object
# @function
# @public
#
# @param {Object} config - generated config object
# @throws Will throw if there is a validation error
#
# @example
# config = deviceConfig.generate
# 	application:
# 		app_name: 'HelloWorldApp'
# 		id: 18
# 		device_type: 'raspberry-pi'
# 	user:
# 		id: 7
# 		username: 'johndoe'
# 	pubnub:
# 		subscribe_key: 'demo'
# 		publish_key: 'demo'
# 	mixpanel:
# 		token: 'e3bc4100330c35722740fb8c6f5abddc'
# 	apiKey: 'asdf'
# 	vpnPort: 1723
# 	endpoints:
# 		api: 'https://api.resin.io'
# 		vpn: 'vpn.resin.io'
# 		registry: 'registry.resin.io'
# ,
# 	network: 'ethernet'
# 	appUpdatePollInterval: 50000
#
# deviceConfig.validate(config)
###
exports.validate = (config) ->
	validation = revalidator.validate(config, schema)

	if not validation.valid
		error = _.first(validation.errors)
		throw new Error("Validation: #{error.property} #{error.message}")

	disallowedProperty = _.chain(config)
		.keys()
		.difference(_.keys(schema.properties))
		.first()
		.value()

	if disallowedProperty?
		throw new Error("Validation: #{disallowedProperty} not recognized")

###*
# @summary Get a device configuration object
# @public
# @function
#
# @param {String} uuid - device uuid
# @param {Object} [options={}] - options
# @param {String} [options.wifiSsid] - wifi ssid
# @param {String} [options.wifiKey] - wifi key
#
# @returns {Promise<Object>} device configuration
#
# @todo Move this to the SDK
#
# @example
# deviceConfig.get '7cf02a62a3a84440b1bb5579a3d57469148943278630b17e7fc6c4f7b465c9',
# 	network: 'wifi'
# 	wifiSsid: 'foobar'
# 	wifiKey: 'hello'
# .then (configuration) ->
# 	console.log(configuration)
###
exports.get = (uuid, options = {}) ->
	resin.models.device.get(uuid).then (device) ->
		Promise.props
			application: resin.models.application.get(device.application_name)
			apiKey: resin.models.application.getApiKey(device.application_name)
			userId: resin.auth.getUserId()
			username: resin.auth.whoami()
			apiUrl: resin.settings.get('apiUrl')
			vpnUrl: resin.settings.get('vpnUrl')
			registryUrl: resin.settings.get('registryUrl')
			pubNubKeys: resin.models.config.getPubNubKeys()
			mixpanelToken: resin.models.config.getMixpanelToken()
		.then (results) ->
			throw new errors.ResinNotLoggedIn() if not results.username?

			config = exports.generate
				application: results.application
				user:
					id: results.userId
					username: results.username
				pubnub: results.pubNubKeys
				mixpanel:
					token: results.mixpanelToken
				apiKey: results.apiKey
				endpoints:
					api: results.apiUrl
					vpn: results.vpnUrl
					registry: results.registryUrl
			, options

			# Associate a device, to prevent the supervisor
			# from creating another one on it's own.
			config.registered_at = Math.floor(Date.now() / 1000)
			config.deviceId = device.id
			config.uuid = uuid

			exports.validate(config)

			return config
