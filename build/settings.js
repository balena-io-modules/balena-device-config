
/*
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
