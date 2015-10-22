
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
    }
  }
};
