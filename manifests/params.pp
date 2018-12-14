# == Class: mesosdns::params
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
# Set default parameters
#
class mesosdns::params {
  # service status
  $service_status = 'enabled'

  # restart on configuration change?
  $service_restart = true

  # determine default service provider by stdlib fact
  $service_provider = $::service_provider

  $service_provider_dir = {
    'upstart' => '/etc/init',
    'systemd' => '/etc/systemd/system'
  }

  $version = 'v0.5.1'

  # this is an erb template, so its possible to inject version or fix path
  $source_template = 'https://github.com/mesosphere/mesos-dns/releases/download/<%=@version%>/mesos-dns-<%=@version%>-linux-amd64'
  $install_path = '/opt/mesos-dns'
  $config_path = '/etc/mesos-dns'
}
