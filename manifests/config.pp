# == Class: mesosdns::config
#
# Authors
# -------
#
# Richard Hillmann <rhillmann@intelliad.de>
#
# Copyright
# ---------
#
# Copyright 2016 intellAd Media GmbH.
#
# Description
# -----------
#
# Manage mesosdns config
#
# See also https://github.com/mesosphere/mesos-dns/blob/master/docs/docs/configuration-parameters.md
#
class mesosdns::config (
  $ensure,
  $config,
  $path,
  $zk_detection_timeout,
  $refresh_seconds,
  $state_timeout_seconds,
  $ttl,
  $domain,
  $port,
  $resolvers,
  $timeout,
  $listener,
  $dns_on,
  $http_on,
  $http_port,
  $external_on,
  $soa_mname,
  $soa_rname,
  $soa_refresh,
  $soa_retry,
  $soa_expire,
  $soa_minttl,
  $recurse_on,
  $enforce_rfc952,
  $ip_sources,
  $mesos_zk = undef,
  $mesos_master = undef,
  $mesos_authentication = undef,
  $mesos_credentials_principal = undef,
  $mesos_credentials_secret = undef,
) {

  if $ensure == 'present' {
    # validate all params
    if $mesos_zk == undef and $mesos_master == undef {
        fail('Please specifiy mesos_zk and or mesos_master')
    }
    if $mesos_master != undef {
      validate_array($mesos_master)
    }
    if $mesos_zk != undef {
      validate_string($mesos_zk)
    }
    if $mesos_authentication != undef {
      validate_re($mesos_authentication, ['^basic$', '^iam$'], "Invalid parameter mesos_authentication '${mesos_authentication}'")
    }
    if $mesos_credentials_principal != undef {
      validate_string($mesos_credentials_principal)
    }
    if $mesos_credentials_secret != undef {
      validate_string($mesos_credentials_secret)
    }

    # required, just validate the first entry
    validate_ip_address($resolvers[0])
    validate_ip_address($listener)
    validate_array($resolvers, $ip_sources)
    validate_bool($dns_on, $http_on, $external_on, $recurse_on, $enforce_rfc952)
    validate_re($soa_mname, '[\w\.]+')
    validate_re($soa_rname, '[\w\.]+')
    validate_integer([
      $zk_detection_timeout,
      $refresh_seconds,
      $state_timeout_seconds,
      $ttl,
      $port,
      $timeout,
      $http_port,
      $soa_refresh,
      $soa_retry,
      $soa_expire,
      $soa_minttl,
    ])

    file { $path:
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
    }
    ->
    file { $config:
      ensure  => file,
      content => template('mesosdns/config.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      notify  => Service['mesos-dns'],
    }
  } else {
    file { $path:
      ensure  => absent,
      purge   => true,
      recurse => true,
      force   => true,
    }
  }
}
