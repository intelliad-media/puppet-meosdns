# Mesos-DNS Puppet Module
[![Puppet Forge](http://img.shields.io/puppetforge/v/intelliad/mesosdns.svg)](https://forge.puppetlabs.com/intelliad/mesosdns)
[![Puppet Forge score](https://img.shields.io/puppetforge/f/intelliad/mesosdns.svg)](https://forge.puppetlabs.com/intelliad/mesosdns)
[![Build Status](https://travis-ci.org/intelliad-media/puppet-mesosdns.svg?branch=master)](https://travis-ci.org/intelliad-media/puppet-mesosdns)


Manage [Mesos-DNS](http://mesosphere.github.io/) - An DNS-based service discovery for Mesos.

## Usage

Example with default config and master is set via zookeeper url
```puppet
class{'mesosdns':
    mesos_zk => 'zk://localhost:2181/mesos',
}

```

Example with default config and master is set via mesos master address
```puppet
class{'mesosdns':
  mesos_master => ['localhost:5050'],
}
```

Its also possible to set both mesos master and zookeeper, mesos-dns uses both.
```puppet
class{'mesosdns':
  mesos_zk => 'zk://localhost:2181/mesos',
  mesos_master => ['localhost:5050'],
}
```

## Class ::mesosdns Parameters

### Required Parameters

- `mesos_zk` - Zookeeper url of mesos
- `mesos_master` - or/and `array` of mesos masters - host:port

### Optional Parameters

- `ensure` - `present` to install and configure mesos-dns or `absent` to remove all
- `version` - download and install an specific release from [GitHub](https://github.com/mesosphere/mesos-dns/releases)
- `source` - Download URL (erb template) to use, can be used to specify an custom url for the final binary
- `install_path` - Install and downloads the binary to this path
- `config_path` - config.json will be placed here

- `service_status` - Status of the configured services.
  - Valid values are 'enabled', 'disabled', 'running' and 'unmanaged',
  - Defaults to enabled

- `service_restart` - Should service be restarted on config changes
  - Boolean
  - Defaults to true

- `service_provider` - Set an specific service provider
  - Currently implemented `upstart` and `systemd`
  - Default is got by puppet stdlib fact $::service_provider and depence on the running OS

### Mesos-DNS Configuration Parameters


For further details have a look on [Mesos-DNS configuration documentation](http://mesosphere.github.io/mesos-dns/docs/configuration-parameters.html). For default values have a look on _mesosdns::init_

- `zk_detection_timeout` -> `zkDetectionTimeout` - Integer
- `refresh_seconds` -> `refreshSeconds` - Integer
- `state_timeout_seconds` -> `stateTimeoutSeconds` - Integer
- `ttl` -> `ttl` - Integer
- `domain` -> `domain` - String
- `port` -> `port` - Integer
- `resolvers` -> `resolvers` - Array of Strings
- `timeout` -> `timeout` - Integer
- `listener` -> `listener` - String (IP)
- `dns_on` -> `dnson` - Boolean
- `http_on` -> `httpon` - Boolean
- `http_port` -> `httpport` - Integer
- `external_on` -> `externalon` - Boolean
- `soa_mname` -> `SOAMname` - String
- `soa_rname` -> `SOARname` - String
- `soa_refresh` -> `SOARefresh` - Integer
- `soa_retry` -> `SOARetry` - Integer
- `soa_expire` -> `SOAExpire` - Integer
- `soa_minttl` -> `SOAMinttl` - Integer
- `recurse_on` -> `recurseon` - Boolean
- `enforce_rfc952` -> `enforceRFC952` - Boolean
- `ip_sources` -> `IPSources` - Array of Strings

## Requirements
 * Puppet >= 4.6 and < 6.0

## Dependencies
* [stdlib](https://forge.puppetlabs.com/puppetlabs/stdlib) version `>= 4.10.0` - we need fact `service_provider` and some validiation functions
* [archive](https://github.com/puppetlabs/puppet-archive)  version `>= 0.4.0` - is required to download binary

## Issues
* The builds on Puppet 5.2 fail due to some incompatibility with stdlib and its IP type:
       Syntax error at ']' at /home/travis/build/intelliad-media/puppet-mesosdns/spec/fixtures/modules/stdlib/types/ip/address.pp:4:1

## Limitations
This module should work out of the box with all Linux systems which has service provider `upstart` or `systemd` (detected by stdlib facter)

## Links

For more information see [Mesos-DNS project](http://mesosphere.github.io/mesos-dns/)

## License

Apache License 2.0

## Contributors

- Richard Hillmann <rhillmann@intelliad.de>
