
/*
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
 */

/**
 * @module deviceConfig
 */
var Promise, errors, network, resin;

Promise = require('bluebird');

resin = require('resin-sdk');

errors = require('resin-errors');

network = require('./network');


/**
 * @summary Get a device configuration object
 * @public
 * @function
 *
 * @param {String} uuid - device uuid
 * @param {Object} [options={}] - options
 * @param {String} [options.wifiSsid] - wifi ssid
 * @param {String} [options.wifiKey] - wifi key
 *
 * @returns {Promise<Object>} device configuration
 *
 * @example
 * deviceConfig.get '7cf02a62a3a84440b1bb5579a3d57469148943278630b17e7fc6c4f7b465c9',
 * 	wifiSsid: 'foobar'
 * 	wifiKey: 'hello'
 * .then (configuration) ->
 * 	console.log(configuration)
 */

exports.get = function(uuid, options) {
  if (options == null) {
    options = {};
  }
  return resin.models.device.get(uuid).then(function(device) {
    return Promise.all([resin.models.application.get(device.application_name), resin.models.application.getApiKey(device.application_name), resin.auth.getUserId(), resin.auth.whoami(), resin.settings.get('apiUrl')]).spread(function(application, apiKey, userId, username, apiUrl) {
      if (username == null) {
        throw new errors.ResinNotLoggedIn();
      }
      return {
        applicationId: String(application.id),
        apiKey: apiKey,
        apiEndpoint: apiUrl,
        deviceType: device.device_type,
        userId: String(userId),
        username: username,
        wifiSsid: options.wifiSsid,
        wifiKey: options.wifiKey,
        files: network.getFiles(options),
        deviceId: device.id,
        uuid: device.uuid
      };
    });
  });
};
