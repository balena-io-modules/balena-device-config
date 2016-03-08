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
  * [.get(uuid, [options])](#module_deviceConfig.get) ⇒ <code>Promise.&lt;Object&gt;</code>

<a name="module_deviceConfig.generate"></a>
### deviceConfig.generate(options, params) ⇒ <code>Object</code>
**Kind**: static method of <code>[deviceConfig](#module_deviceConfig)</code>  
**Summary**: Generate a basic config.json object  
**Returns**: <code>Object</code> - config.json  
**Access:** public  

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
,
	network: 'ethernet'
	appUpdatePollInterval: 50000

console.log(config)
```
<a name="module_deviceConfig.validate"></a>
### deviceConfig.validate(config)
**Kind**: static method of <code>[deviceConfig](#module_deviceConfig)</code>  
**Summary**: Validate a generated config.json object  
**Throws**:

- Will throw if there is a validation error

**Access:** public  

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
,
	network: 'ethernet'
	appUpdatePollInterval: 50000

deviceConfig.validate(config)
```
<a name="module_deviceConfig.get"></a>
### deviceConfig.get(uuid, [options]) ⇒ <code>Promise.&lt;Object&gt;</code>
**Kind**: static method of <code>[deviceConfig](#module_deviceConfig)</code>  
**Summary**: Get a device configuration object  
**Returns**: <code>Promise.&lt;Object&gt;</code> - device configuration  
**Access:** public  
**Todo**

- [ ] Move this to the SDK


| Param | Type | Default | Description |
| --- | --- | --- | --- |
| uuid | <code>String</code> |  | device uuid |
| [options] | <code>Object</code> | <code>{}</code> | options |
| [options.wifiSsid] | <code>String</code> |  | wifi ssid |
| [options.wifiKey] | <code>String</code> |  | wifi key |

**Example**  
```js
deviceConfig.get '7cf02a62a3a84440b1bb5579a3d57469148943278630b17e7fc6c4f7b465c9',
	network: 'wifi'
	wifiSsid: 'foobar'
	wifiKey: 'hello'
.then (configuration) ->
	console.log(configuration)
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
