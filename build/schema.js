
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

/**
 * @summary config.json validation schema
 * @name schema
 * @type {Object}
 *
 * @description
 * This is a `revalidator` schema. Refer to the following documentation:
 *
 *		https://github.com/flatiron/revalidator
 */
module.exports = {
  properties: {
    applicationName: {
      description: 'application name',
      type: 'string',
      required: true,
      allowEmpty: false
    },
    applicationId: {
      description: 'application id',
      type: 'number',
      minimum: 0,
      required: true
    },
    deviceType: {
      description: 'device type',
      type: 'string',
      required: true,
      allowEmpty: false
    },
    userId: {
      description: 'user id',
      type: 'number',
      minimum: 0,
      required: true
    },
    username: {
      description: 'username',
      type: 'string',
      required: true,
      allowEmpty: false
    },
    files: {
      description: 'files',
      type: 'object',
      required: true,
      properties: {
        'network/settings': {
          description: 'network settings',
          type: 'string',
          required: true,
          allowEmpty: false
        },
        'network/network.config': {
          description: 'network config',
          type: 'string',
          required: true,
          allowEmpty: false
        }
      }
    },
    appUpdatePollInterval: {
      description: 'app update poll interval',
      type: 'number',
      minimum: 0,
      required: true
    },
    listenPort: {
      description: 'listen port',
      type: 'number',
      minimum: 0,
      required: true
    },
    vpnPort: {
      description: 'vpn port',
      type: 'number',
      minimum: 0,
      required: true
    },
    apiEndpoint: {
      description: 'api endpoint',
      type: 'string',
      required: true,
      allowEmpty: false,
      format: 'url'
    },
    vpnEndpoint: {
      description: 'vpn endpoint',
      type: 'string',
      required: true,
      allowEmpty: false,
      format: 'host-name'
    },
    registryEndpoint: {
      description: 'registry endpoint',
      type: 'string',
      required: true,
      allowEmpty: false,
      format: 'host-name'
    },
    pubnubSubscribeKey: {
      description: 'pubnub subscribe key',
      type: 'string',
      required: true,
      allowEmpty: false
    },
    pubnubPublishKey: {
      description: 'pubnub publish key',
      type: 'string',
      required: true,
      allowEmpty: false
    },
    mixpanelToken: {
      description: 'mixpanel token',
      type: 'string',
      required: true,
      allowEmpty: false
    },
    apiKey: {
      description: 'api key',
      type: 'string',
      required: true,
      allowEmpty: false
    },
    registered_at: {
      description: 'registered at',
      type: 'number',
      minimum: 0,
      format: 'utc-millisec'
    },
    deviceId: {
      description: 'device id',
      type: 'number',
      minimum: 0
    },
    uuid: {
      description: 'uuid',
      type: 'string',
      allowEmpty: false,
      pattern: /^[0-9a-f]{62}$/
    },
    wifiSsid: {
      description: 'wifi ssid',
      type: 'string',
      allowEmpty: true
    },
    wifiKey: {
      description: 'wifi key',
      type: 'string',
      allowEmpty: true
    }
  }
};
