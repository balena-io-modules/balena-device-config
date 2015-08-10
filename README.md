resin-device-config
-------------------

[![npm version](https://badge.fury.io/js/resin-device-config.svg)](http://badge.fury.io/js/resin-device-config)
[![dependencies](https://david-dm.org/resin-io/resin-device-config.png)](https://david-dm.org/resin-io/resin-device-config.png)
[![Build Status](https://travis-ci.org/resin-io/resin-device-config.svg?branch=master)](https://travis-ci.org/resin-io/resin-device-config)
[![Build status](https://ci.appveyor.com/api/projects/status/im9y5jv9ml0fs8jo?svg=true)](https://ci.appveyor.com/project/jviotti/resin-device-config)

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

<a name="module_deviceConfig.get"></a>
### deviceConfig.get(uuid, [options]) ⇒ <code>Promise.&lt;Object&gt;</code>
**Kind**: static method of <code>[deviceConfig](#module_deviceConfig)</code>  
**Summary**: Get a device configuration object  
**Returns**: <code>Promise.&lt;Object&gt;</code> - device configuration  
**Access:** public  

| Param | Type | Default | Description |
| --- | --- | --- | --- |
| uuid | <code>String</code> |  | device uuid |
| [options] | <code>Object</code> | <code>{}</code> | options |
| [options.wifiSsid] | <code>String</code> |  | wifi ssid |
| [options.wifiKey] | <code>String</code> |  | wifi key |

**Example**  
```js
deviceConfig.get '7cf02a62a3a84440b1bb5579a3d57469148943278630b17e7fc6c4f7b465c9',
	wifiSsid: 'foobar'
	wifiKey: 'hello'
.then (configuration) ->
	console.log(configuration)
```

Support
-------

If you're having any problem, please [raise an issue](https://github.com/resin-io/resin-device-config/issues/new) on GitHub and the Resin.io team will be happy to help.

Tests
-----

Run the test suite by doing:

```sh
$ gulp test
```

Contribute
----------

- Issue Tracker: [github.com/resin-io/resin-device-config/issues](https://github.com/resin-io/resin-device-config/issues)
- Source Code: [github.com/resin-io/resin-device-config](https://github.com/resin-io/resin-device-config)

Before submitting a PR, please make sure that you include tests, and that [coffeelint](http://www.coffeelint.org/) runs without any warning:

```sh
$ gulp lint
```

License
-------

The project is licensed under the MIT license.
