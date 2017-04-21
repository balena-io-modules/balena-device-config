# Change Log

All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [4.0.1] - 2017-04-21

### Changed

- Make UUID validation more flexible to support new 16 byte UUID format

## [4.0.0] - 2017-04-15

### Added

- Added a required `deviceApiKey` parameter to `getByDevice`.

### Changed

- Updated bluebird to ^3.5.0
- Updated lodash to ^4.17.4
- Updated resin-sdk-preconfigured to ^6.0.0
- Updated coffee-script to ~1.12.5

## [3.3.3] - 2017-03-03

### Changed

- Don't include the connectivity section if a version >= 2.0.0 is given.

## [3.3.2] - 2017-02-15

### Changed

- Don't include the files section if a version >= 2.0.0 is given.

## [3.3.1] - 2017-01-24

### Changed

- Moved to [resin-sdk-preconfigured](https://github.com/resin-io-modules/resin-sdk-preconfigured)

## [3.3.0] - 2016-08-12

### Added

- Add `connectivity` property.

## [3.2.0] - 2016-07-18

### Changed

- Disable connman ntp as it is now handled by systemd-timesyncd.

## [3.1.0] - 2016-06-14

### Changed

- Support for hidden wifi networks.

## [3.0.1] - 2016-04-08

### Changed

- Expand shorter uuids in `.getByDevice()`.

## [3.0.0] - 2016-03-21

### Added

- Implement `.getByApplication()`.

### Changed

- Rename `.get()` to `.getByDevice()`.

## [2.6.1] - 2016-02-26

### Changed

- Upgrade `resin-sdk` to v5.1.0.

## [2.6.0] - 2016-02-18

### Added

- Add support for static IPs.

## [2.5.2] - 2016-02-11

### Changed

- Make `deltaEndpoint` optional.
- Throw an error if `vpnPort` becomes `NaN`.

## [2.5.1] - 2016-02-10

### Changed

- Make sure `vpnPort` is a number.

## [2.5.0] - 2016-02-03

### Added

- Add `deltaEndpoint` property to `config.json`.

## [2.4.4] - 2015-12-04

### Changed

- Omit tests in NPM package.

## [2.4.3] - 2015-11-24

- Upgrade Resin SDK to v4.0.0.
- Upgrade Resin Errors to v2.0.0.

## [2.4.2] - 2015-11-12

- Upgrade `resin-settings-client` to v3.2.2.

## [2.4.1] - 2015-11-09

- Upgrade `resin-settings-client` to v3.2.1.

## [2.4.0] - 2015-10-26

### Added

- Validate configuration right after generation.
- Add `wifiKey` nad `wifiSsid` options.

## [2.3.0] - 2015-10-22

### Added

- Implement `deviceConfig.generate()`.
- Implement `deviceConfig.validate()`.
- Add `vpnPort`.
- Add `applicationName`.
- Implement strict validation.

### Changed

- Validate output of `deviceConfig.get()` by default.

## [2.2.1] - 2015-10-12

### Changed

- Upgrade Resin SDK to v3.0.0.

## [2.2.0] - 2015-09-25

### Added

- Add `listenPort`.
- Add `pubnubSubscribeKey`.
- Add `pubnubPublishKey`.
- Add `mixpanelToken`.

## [2.1.0] - 2015-09-07

### Added

- Add `registered_at` property.
- Add default `appUpdatePollInterval` value.
- Add `vpnEndpoint` property.
- Add `registryUrl` property.

### Removed

- Remove `wifiSsid` deprecated property.
- Remove `wifiKey` deprecated property.

## [2.0.1] - 2015-09-07

### Added

- Add missing `apiEndpoint` property.

## [2.0.0] - 2015-08-10

### Added

- Add `deviceId` and `uuid` properties to the configuration object.

### Changed

- Take a `uuid` instead of an application name.

[4.0.1]: https://github.com/resin-io-modules/resin-device-config/compare/v4.0.0...v4.0.1
[4.0.0]: https://github.com/resin-io-modules/resin-device-config/compare/v3.3.3...v4.0.0
[3.3.3]: https://github.com/resin-io-modules/resin-device-config/compare/v3.3.2...v3.3.3
[3.3.2]: https://github.com/resin-io-modules/resin-device-config/compare/v3.3.1...v3.3.2
[3.3.1]: https://github.com/resin-io-modules/resin-device-config/compare/v3.3.0...v3.3.1
[3.3.0]: https://github.com/resin-io-modules/resin-device-config/compare/v3.2.0...v3.3.0
[3.2.0]: https://github.com/resin-io-modules/resin-device-config/compare/v3.1.0...v3.2.0
[3.1.0]: https://github.com/resin-io-modules/resin-device-config/compare/v3.0.1...v3.1.0
[3.0.1]: https://github.com/resin-io-modules/resin-device-config/compare/v3.0.0...v3.0.1
[3.0.0]: https://github.com/resin-io-modules/resin-device-config/compare/v2.6.1...v3.0.0
[2.6.1]: https://github.com/resin-io-modules/resin-device-config/compare/v2.6.0...v2.6.1
[2.6.0]: https://github.com/resin-io-modules/resin-device-config/compare/v2.5.2...v2.6.0
[2.5.2]: https://github.com/resin-io-modules/resin-device-config/compare/v2.5.1...v2.5.2
[2.5.1]: https://github.com/resin-io-modules/resin-device-config/compare/v2.5.0...v2.5.1
[2.5.0]: https://github.com/resin-io-modules/resin-device-config/compare/v2.4.4...v2.5.0
[2.4.4]: https://github.com/resin-io-modules/resin-device-config/compare/v2.4.3...v2.4.4
[2.4.3]: https://github.com/resin-io-modules/resin-device-config/compare/v2.4.2...v2.4.3
[2.4.2]: https://github.com/resin-io-modules/resin-device-config/compare/v2.4.1...v2.4.2
[2.4.1]: https://github.com/resin-io-modules/resin-device-config/compare/v2.4.0...v2.4.1
[2.4.0]: https://github.com/resin-io-modules/resin-device-config/compare/v2.3.0...v2.4.0
[2.3.0]: https://github.com/resin-io-modules/resin-device-config/compare/v2.2.1...v2.3.0
[2.2.1]: https://github.com/resin-io-modules/resin-device-config/compare/v2.2.0...v2.2.1
[2.2.0]: https://github.com/resin-io-modules/resin-device-config/compare/v2.1.0...v2.2.0
[2.1.0]: https://github.com/resin-io-modules/resin-device-config/compare/v2.0.1...v2.1.0
[2.0.1]: https://github.com/resin-io-modules/resin-device-config/compare/v2.0.0...v2.0.1
[2.0.0]: https://github.com/resin-io-modules/resin-device-config/compare/v1.0.0...v2.0.0
