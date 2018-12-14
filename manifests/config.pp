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
      unless $mesos_master =~ Array { fail 'The $mesos_master variable should contain an Array' }
    }
    if $mesos_zk != undef {
      unless $mesos_zk =~ String { fail 'The $mesos_zk variable should contain a String' }
    }
    if $mesos_authentication != undef {
      unless $mesos_authentication =~ '^basic$' or $mesos_authentication =~ '^iam$' { fail "Invalid parameter mesos_authentication ${mesos_authentication}" }
    }
    if $mesos_credentials_principal != undef {
      unless $mesos_credentials_principal =~ String { fail 'The $mesos_credentials_principal variable should contain a String' }
    }
    if $mesos_credentials_secret != undef {
      unless $mesos_credentials_secret =~ String { fail 'The $mesos_credentials_secret variable should contain a String' }
    }

    # required, just validate the first entry
    unless $resolvers[0] =~ Stdlib::IP::Address { fail 'The $resolvers[0] variable should contain an IP address' }
    unless $listener =~ Stdlib::IP::Address { fail 'The $listener variable should contain an IP address' }
    unless $resolvers =~ Array { fail 'The $resolvers variable should contain an Array' }
    unless $ip_sources =~ Array { fail 'The $ip_sources variable should contain an Array' }
    unless $dns_on =~ Boolean { fail 'The $dns_on variable should contain a Boolean' }
    unless $http_on =~ Boolean { fail 'The $http_on variable should contain a Boolean' }
    unless $external_on =~ Boolean { fail 'The $external_on variable should contain a Boolean' }
    unless $recurse_on =~ Boolean { fail 'The $recurse_on variable should contain a Boolean' }
    unless $enforce_rfc952 =~ Boolean { fail 'The $enforce_rfc952 variable should contain a Boolean' }
    unless $soa_mname =~ '[\w\.]+' { fail 'The $soa_mname variable does not match the regex string' }
    unless $soa_rname =~ '[\w\.]+' { fail 'The $soa_rname variable does not match the regex string' }
    unless $zk_detection_timeout =~ Integer { fail 'The $zk_detection_timeout variable should contain an Integer' }
    unless $refresh_seconds =~ Integer { fail 'The $refresh_seconds variable should contain an Integer' }
    unless $state_timeout_seconds =~ Integer { fail 'The $state_timeout_seconds variable should contain an Integer' }
    unless $ttl =~ Integer { fail 'The $ttl variable should contain an Integer' }
    unless $port =~ Integer { fail 'The $port variable should contain an Integer' }
    unless $timeout =~ Integer { fail 'The $timeout variable should contain an Integer' }
    unless $http_port =~ Integer { fail 'The $http_port variable should contain an Integer' }
    unless $soa_refresh =~ Integer { fail 'The $soa_refresh variable should contain an Integer' }
    unless $soa_retry =~ Integer { fail 'The $soa_retry variable should contain an Integer' }
    unless $soa_expire =~ Integer { fail 'The $soa_expire variable should contain an Integer' }
    unless $soa_minttl =~ Integer { fail 'The $soa_minttl variable should contain an Integer' }

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
    }
  # Else ensure it is absent
  } else {
    file { $config:
      ensure => absent,
      purge  => true,
      force  => true,
    }
    ->
    file { $path:
      ensure  => absent,
      purge   => true,
      recurse => true,
      force   => true,
    }
  }
}
