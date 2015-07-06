
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
var _;

_ = require('lodash');


/**
 * @summary Main network settings
 * @constant
 * @protected
 * @type {String}
 */

exports.main = '[global]\nOfflineMode=false\n\n[WiFi]\nEnable=true\nTethering=false\n\n[Wired]\nEnable=true\nTethering=false\n\n[Bluetooth]\nEnable=true\nTethering=false';


/**
 * @summary Get ethernet/wifi network settings
 * @function
 * @protected
 *
 * @param {Object} options - options
 * @param {String} [options.wifiSsid] - wifi ssid
 * @param {String} [options.wifiKey] - wifi key
 *
 * @returns {String} Network configuration.
 *
 * @example
 * networkSettings = settings.getHomeSettings
 *		wifiSsid: 'foobar'
 *		wifiKey: 'hello'
 */

exports.getHomeSettings = function(options) {
  var config, _ref;
  config = '[service_home_ethernet]\nType = ethernet\nNameservers = 8.8.8.8,8.8.4.4';
  if (!_.isEmpty((_ref = options.wifiSsid) != null ? _ref.trim() : void 0)) {
    config += "\n\n[service_home_wifi]\nType = wifi\nName = " + options.wifiSsid;
    if (options.wifiKey) {
      config += "\nPassphrase = " + options.wifiKey;
    }
    config += '\nNameservers = 8.8.8.8,8.8.4.4';
  }
  return config;
};
