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

###*
# @module deviceConfig
###

_ = require('lodash')
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
# 		id: 18
# 		device_type: 'raspberry-pi'
# 	apiKey: 'asdf'
# 	vpnPort: 443
# 	endpoints:
# 		api: 'https://api.balena-cloud.com'
# 		vpn: 'vpn.balena-cloud.com'
# 		registry: 'registry.balena-cloud.com'
# ,
# 	network: 'ethernet'
# 	appUpdatePollInterval: 50000
#
# console.log(config)
#
# @example
# config = deviceConfig.generate
# 	application:
# 		id: 18
# 		device_type: 'raspberry-pi2'
# 	deviceType: 'raspberrypi3'
# 	apiKey: 'asdf'
# 	vpnPort: 443
# 	endpoints:
# 		api: 'https://api.balena-cloud.com'
# 		vpn: 'vpn.balena-cloud.com'
# 		registry: 'registry.balena-cloud.com'
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
		applicationId: options.application.id
		deviceType: options.deviceType or options.application.device_type
		userId: options.user?.id

		appUpdatePollInterval: params.appUpdatePollInterval or 60000

		listenPort: 48484
		vpnPort: options.vpnPort

		apiEndpoint: options.endpoints.api
		vpnEndpoint: options.endpoints.vpn
		registryEndpoint: options.endpoints.registry
		deltaEndpoint: options.endpoints.delta

		mixpanelToken: options.mixpanel?.token

	if options.apiKey?
		config.apiKey = options.apiKey

	if options.endpoints.logs?
		config.logsEndpoint = options.endpoints.logs

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
# 		id: 18
# 		device_type: 'raspberry-pi'
# 	apiKey: 'asdf'
# 	vpnPort: 443
# 	endpoints:
# 		api: 'https://api.balena-cloud.com'
# 		vpn: 'vpn.balena-cloud.com'
# 		registry: 'registry.balena-cloud.com'
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
