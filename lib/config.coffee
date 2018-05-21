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

###*
# @module deviceConfig
###

_ = require('lodash')
Promise = require('bluebird')
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
# 	vpnPort: 443
# 	endpoints:
# 		api: 'https://api.resin.io'
# 		vpn: 'vpn.resin.io'
# 		registry: 'registry.resin.io'
# ,
# 	network: 'ethernet'
# 	appUpdatePollInterval: 50000
#
# console.log(config)
#
# @example
# config = deviceConfig.generate
# 	application:
# 		app_name: 'HelloWorldApp'
# 		id: 18
# 		device_type: 'raspberry-pi2'
# 	deviceType: 'raspberrypi3'
# 	user:
# 		id: 7
# 		username: 'johndoe'
# 	pubnub:
# 		subscribe_key: 'demo'
# 		publish_key: 'demo'
# 	mixpanel:
# 		token: 'e3bc4100330c35722740fb8c6f5abddc'
# 	apiKey: 'asdf'
# 	vpnPort: 443
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

	_.defaults options,
		vpnPort: 443

	config =
		applicationName: options.application.app_name
		applicationId: options.application.id
		deviceType: options.deviceType or options.application.device_type
		userId: options.user.id
		username: options.user.username

		appUpdatePollInterval: params.appUpdatePollInterval or 60000

		listenPort: 48484
		vpnPort: options.vpnPort

		apiEndpoint: options.endpoints.api
		vpnEndpoint: options.endpoints.vpn
		registryEndpoint: options.endpoints.registry
		deltaEndpoint: options.endpoints.delta

		pubnubSubscribeKey: options.pubnub.subscribe_key
		pubnubPublishKey: options.pubnub.publish_key
		mixpanelToken: options.mixpanel.token

	if options.apiKey?
		config.apiKey = options.apiKey

	majorVersion = parseInt(options.version.split('.', 1)[0]) if options.version
	if not majorVersion or majorVersion < 2
		config.files = network.getFiles(params)
		config.connectivity = params.connectivity or 'connman'

	if params.network is 'wifi'
		config.wifiSsid = params.wifiSsid
		config.wifiKey = params.wifiKey

	if _.isArray(params.network)
		config.network = params.network

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
# 	vpnPort: 443
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
	validation = revalidator.validate(config, schema, cast: true)

	if not validation.valid
		error = _.head(validation.errors)
		throw new Error("Validation: #{error.property} #{error.message}")

	disallowedProperty = _.chain(config)
		.keys()
		.difference(_.keys(schema.properties))
		.head()
		.value()

	if disallowedProperty?
		throw new Error("Validation: #{disallowedProperty} not recognized")

getApplicationConfig = (application, options = {}) ->
	resin = require('resin-sdk-preconfigured')
	Promise.props
		application: resin.models.application.get(application)
		userId: resin.auth.getUserId()
		username: resin.auth.whoami()
		apiUrl: resin.settings.get('apiUrl')
		vpnUrl: resin.settings.get('vpnUrl')
		registryUrl: resin.settings.get('registryUrl')
		deltaUrl: resin.settings.get('deltaUrl')
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
			endpoints:
				api: results.apiUrl
				vpn: results.vpnUrl
				registry: results.registryUrl
				delta: results.deltaUrl
		, options

		return config

###*
# @summary Get a device configuration object for provisioning from an application
# @public
# @function
#
# @param {String} application - application name
# @param {Object} [options={}] - options
# @param {String} [options.wifiSsid] - wifi ssid
# @param {String} [options.wifiKey] - wifi key
#
# @returns {Promise<Object>} device configuration
#
# @todo Move this to the SDK
#
# @example
# deviceConfig.getByApplication 'App1',
# 	network: 'wifi'
# 	wifiSsid: 'foobar'
# 	wifiKey: 'hello'
# .then (configuration) ->
# 	console.log(configuration)
###
exports.getByApplication = (application, options = {}) ->
	resin = require('resin-sdk-preconfigured')
	Promise.join(
		resin.models.application.getApiKey(application)
		getApplicationConfig(application, options)
		(apiKey, config) ->
			config.apiKey = apiKey

			exports.validate(config)

			return config
	)

###*
# @summary Get a device configuration object for a provisioned device
# @public
# @function
#
# @param {String} uuid - device uuid
# @param {String} [deviceApiKey] - device api key
# @param {Object} [options={}] - options
# @param {String} [options.wifiSsid] - wifi ssid
# @param {String} [options.wifiKey] - wifi key
#
# @returns {Promise<Object>} device configuration
#
# @todo Move this to the SDK
# @todo Require device api key to be provided
#
# @example
# deviceConfig.getByDevice '7cf02a6', '4321'
# 	network: 'wifi'
# 	wifiSsid: 'foobar'
# 	wifiKey: 'hello'
# .then (configuration) ->
# 	console.log(configuration)
###
exports.getByDevice = Promise.method (uuid, deviceApiKey, options = {}) ->
	if not _.isString(deviceApiKey)
		throw new Error('deviceApiKey must be a string')

	resin = require('resin-sdk-preconfigured')
	resin.models.device.get(uuid).then (device) ->
		return getApplicationConfig(device.application_name, options).then (config) ->

			# Associate a device, to prevent the supervisor
			# from creating another one on it's own.
			config.registered_at = Math.floor(Date.now() / 1000)
			config.deviceId = device.id
			config.uuid = device.uuid
			config.deviceApiKey = deviceApiKey
			config.deviceType = device.device_type

			exports.validate(config)
			return config
