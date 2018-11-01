resin-device-config
-------------------

[![npm version](https://badge.fury.io/js/resin-device-config.svg)](http://badge.fury.io/js/resin-device-config)
[![dependencies](https://david-dm.org/resin-io-modules/resin-device-config.png)](https://david-dm.org/resin-io-modules/resin-device-config.png)
[![Build Status](https://travis-ci.org/resin-io-modules/resin-device-config.svg?branch=master)](https://travis-ci.org/resin-io-modules/resin-device-config)
[![Build status](https://ci.appveyor.com/api/projects/status/im9y5jv9ml0fs8jo/branch/master?svg=true)](https://ci.appveyor.com/project/resin-io/resin-device-config/branch/master)

Join our online chat at [![Gitter chat](https://badges.gitter.im/resin-io/chat.png)](https://gitter.im/resin-io/chat)

Get device config.json configuration.

Role
----

The intention of this module is to provide low level access to how a Resin.io device `config.json` file is generated.

**THIS MODULE IS LOW LEVEL AND IS NOT MEANT TO BE USED BY END USERS DIRECTLY**.

Installation
------------

Install `resin-device-config` by running:

```sh
$ npm install --save resin-device-config
```

Documentation
-------------


* [deviceConfig](#module_deviceConfig)
    * [.generate(options, params)](#module_deviceConfig.generate) ⇒ <code>Object</code>
    * [.validate(config)](#module_deviceConfig.validate)

<a name="module_deviceConfig.generate"></a>

### deviceConfig.generate(options, params) ⇒ <code>Object</code>
**Kind**: static method of [<code>deviceConfig</code>](#module_deviceConfig)  
**Summary**: Generate a basic config.json object  
**Returns**: <code>Object</code> - config.json  
**Access**: public  

| Param | Type | Description |
| --- | --- | --- |
| options | <code>Object</code> | options |
| params | <code>Object</code> | user params |

**Example**  
```js
config = deviceConfig.generate
	application:
		app_name: 'HelloWorldApp'
		id: 18
		device_type: 'raspberry-pi'
	user:
		id: 7
		username: 'johndoe'
	mixpanel:
		token: 'e3bc4100330c35722740fb8c6f5abddc'
	apiKey: 'asdf'
	vpnPort: 443
	endpoints:
		api: 'https://api.resin.io'
		vpn: 'vpn.resin.io'
		registry: 'registry.resin.io'
,
	network: 'ethernet'
	appUpdatePollInterval: 50000

console.log(config)
```
**Example**  
```js
config = deviceConfig.generate
	application:
		app_name: 'HelloWorldApp'
		id: 18
		device_type: 'raspberry-pi2'
	deviceType: 'raspberrypi3'
	user:
		id: 7
		username: 'johndoe'
	mixpanel:
		token: 'e3bc4100330c35722740fb8c6f5abddc'
	apiKey: 'asdf'
	vpnPort: 443
	endpoints:
		api: 'https://api.resin.io'
		vpn: 'vpn.resin.io'
		registry: 'registry.resin.io'
,
	network: 'ethernet'
	appUpdatePollInterval: 50000

console.log(config)
```
<a name="module_deviceConfig.validate"></a>

### deviceConfig.validate(config)
**Kind**: static method of [<code>deviceConfig</code>](#module_deviceConfig)  
**Summary**: Validate a generated config.json object  
**Throws**:

- Will throw if there is a validation error

**Access**: public  

| Param | Type | Description |
| --- | --- | --- |
| config | <code>Object</code> | generated config object |

**Example**  
```js
config = deviceConfig.generate
	application:
		app_name: 'HelloWorldApp'
		id: 18
		device_type: 'raspberry-pi'
	user:
		id: 7
		username: 'johndoe'
	mixpanel:
		token: 'e3bc4100330c35722740fb8c6f5abddc'
	apiKey: 'asdf'
	vpnPort: 443
	endpoints:
		api: 'https://api.resin.io'
		vpn: 'vpn.resin.io'
		registry: 'registry.resin.io'
,
	network: 'ethernet'
	appUpdatePollInterval: 50000

deviceConfig.validate(config)
```

Support
-------

If you're having any problem, please [raise an issue](https://github.com/resin-io-modules/resin-device-config/issues/new) on GitHub and the Resin.io team will be happy to help.

Tests
-----

Run the test suite by doing:

```sh
$ gulp test
```

Contribute
----------

- Issue Tracker: [github.com/resin-io-modules/resin-device-config/issues](https://github.com/resin-io-modules/resin-device-config/issues)
- Source Code: [github.com/resin-io-modules/resin-device-config](https://github.com/resin-io-modules/resin-device-config)

Before submitting a PR, please make sure that you include tests, and that [coffeelint](http://www.coffeelint.org/) runs without any warning:

```sh
$ gulp lint
```

License
-------

The project is licensed under the Apache 2.0 license.
