
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
 * @summary Get an application device configuration
 * @public
 * @function
 *
 * @param {String} name - application name
 * @param {Object} [options={}] - options
 * @param {String} [options.wifiSsid] - wifi ssid
 * @param {String} [options.wifiKey] - wifi key
 *
 * @returns {Promise<Object>} application configuration
 *
 * @example
 * deviceConfig.get 'MyApp',
 * 	wifiSsid: 'foobar'
 * 	wifiKey: 'hello'
 * .then (configuration) ->
 * 	console.log(configuration)
 */

exports.get = function(name, options) {
  if (options == null) {
    options = {};
  }
  return Promise.all([resin.models.application.get(name), resin.models.application.getApiKey(name), resin.auth.getUserId(), resin.auth.whoami()]).spread(function(application, apiKey, userId, username) {
    if (username == null) {
      throw new errors.ResinNotLoggedIn();
    }
    return {
      applicationId: String(application.id),
      apiKey: apiKey,
      deviceType: application.device_type,
      userId: String(userId),
      username: username,
      wifiSsid: options.wifiSsid,
      wifiKey: options.wifiKey,
      files: network.getFiles(options)
    };
  });
};
