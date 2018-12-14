# == Class: mesosdns::service
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
# Manage mesosdns service daemon with support of several providers
#
class mesosdns::service (
  $binary,
  $config,
  $version_file,
  $ensure       = present,
  $status       = enabled,
  $restart      = true,
  $provider     = $::service_provider,
) {
  include mesosdns

  if $ensure == 'present' {
    $service_restart = $restart
    case $status {
      # make sure service is currently running, start it on boot
      'enabled': {
        $service_ensure = 'running'
        $service_enable = true
      }
      # make sure service is currently stopped, do not start it on boot
      'disabled': {
        $service_ensure = 'stopped'
        $service_enable = false
      }
      # make sure service is currently running, do not start it on boot
      'running': {
        $service_ensure = 'running'
        $service_enable = false
      }
      # do not start service on boot, do not care whether currently running or not
      'unmanaged': {
        $service_ensure = undef
        $service_enable = false
      }
      # unknown status
      default: {
        fail("\"${status}\" is an unknown service status value")
      }
    }
  } else {
    # make sure the service is stopped and disabled
    $service_restart = false
    $service_ensure = 'stopped'
    $service_enable = false
  }

  $provider_dir = $::mesosdns::params::service_provider_dir[$provider]
  $service_name = 'mesos-dns'

  case $provider {
    'upstart': {
      $service_file = "${provider_dir}/${service_name}.conf"
    }
    'systemd': {
      $service_file = "${provider_dir}/${service_name}.service"
      $systemd_exec_subsribe = $ensure ? {
                                  present => File[$service_file],
                                  absent  => undef,
                                }
      exec {"mesosdns systemd systemctl-daemon-reload ${title}":
          command     => 'systemctl daemon-reload',
          refreshonly => true,
          path        => $::path,
          subscribe   => $systemd_exec_subsribe,
          before      => Service[$service_name],
      }
    }
    default: {
      fail("Service provider '${provider}' is not supported")
    }
  }

  $notify_service = $service_restart ? {
    true    => Service[$service_name],
    default => undef,
  }

  file { $service_file:
    ensure  => $ensure,
    owner   => root,
    group   => root,
    mode    => '0744',
    content => template("mesosdns/service/${provider}.erb"),
    notify  => $notify_service,
  }

  # stop service before removing
  $service_before = $ensure ? {
    present => undef,
    absent => File[$service_file],
  }

  service { $service_name:
    ensure     => $service_ensure,
    enable     => $service_enable,
    hasrestart => true,
    hasstatus  => true,
    provider   => $provider,
    before     => $service_before,
    subscribe  => [File[$config], File[$version_file]],
  }
}
