# == Class: mesosdns
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
# Main class to setup mesosdns
#
class mesosdns (
  $ensure = present,

  $version =  $::mesosdns::params::version,
  $source = $::mesosdns::params::source_template,
  $install_path =  $::mesosdns::params::install_path,
  $config_path = $::mesosdns::params::config_path,

  $service_status = $::mesosdns::params::service_status,
  $service_restart = $::mesosdns::params::service_restart,
  $service_provider = $::mesosdns::params::service_provider,

  $mesos_zk = undef,
  $mesos_master = undef,

  $mesos_authentication = undef,
  $mesos_credentials_principal = undef,
  $mesos_credentials_secret = undef,

  $zk_detection_timeout = 30,
  $refresh_seconds = 60,
  $state_timeout_seconds = 300,
  $ttl = 60,
  $domain = 'mesos',
  $port = 53,
  $resolvers = ['8.8.8.8'],
  $timeout = 5,
  $listener = '0.0.0.0',
  $dns_on = true,
  $http_on = true,
  $http_port = 8123,
  $external_on = true,
  $soa_mname = 'ns1.mesos.',
  $soa_rname = 'root.ns1.mesos.',
  $soa_refresh = 60,
  $soa_retry = 600,
  $soa_expire = 86400,
  $soa_minttl = 60,
  $recurse_on = true,
  $enforce_rfc952 = false,
  $ip_sources = ['netinfo', 'mesos', 'host'],
) inherits mesosdns::params {

  validate_re($ensure, ['^present$', '^absent$'], "Invalid parameter ensure '${ensure}'")

  $file_binary = "${install_path}/mesos-dns"
  $file_config = "${config_path}/config.json"

  class {'mesosdns::install':
    ensure  => $ensure,
    version => $version,
    source  => $source,
    path    => $install_path,
  }

  class {'mesosdns::config':
    ensure                      => $ensure,
    config                      => $file_config,
    path                        => $config_path,
    mesos_zk                    => $mesos_zk,
    mesos_master                => $mesos_master,
    mesos_authentication        => $mesos_authentication,
    mesos_credentials_principal => $mesos_credentials_principal,
    mesos_credentials_secret    => $mesos_credentials_secret,
    zk_detection_timeout        => $zk_detection_timeout,
    refresh_seconds             => $refresh_seconds,
    state_timeout_seconds       => $state_timeout_seconds,
    ttl                         => $ttl,
    domain                      => $domain,
    port                        => $port,
    resolvers                   => $resolvers,
    timeout                     => $timeout,
    listener                    => $listener,
    dns_on                      => $dns_on,
    http_on                     => $http_on,
    http_port                   => $http_port,
    external_on                 => $external_on,
    soa_mname                   => $soa_mname,
    soa_rname                   => $soa_rname,
    soa_refresh                 => $soa_refresh,
    soa_retry                   => $soa_retry,
    soa_expire                  => $soa_expire,
    soa_minttl                  => $soa_minttl,
    recurse_on                  => $recurse_on,
    enforce_rfc952              => $enforce_rfc952,
    ip_sources                  => $ip_sources,
  }

  class { 'mesosdns::service':
    ensure   => $ensure,
    binary   => $file_binary,
    config   => $file_config,
    status   => $service_status,
    restart  => $service_restart,
    provider => $service_provider,
    require  => Class['mesosdns::install', 'mesosdns::config']
  }

}
