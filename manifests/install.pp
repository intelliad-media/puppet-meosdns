# == Class: mesosdns::install
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
# Manage mesosdns installation of the binary
#
class mesosdns::install (
  $ensure,
  $version,
  $source,
  $install_path,
  $version_path,
  $version_file,
  $path_binary,
) {
  # inject version to template
  $_source = inline_template($source)

  if $ensure == 'present' {
    file { $install_path:
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
    }
    ->
    file { $version_path:
      ensure  => directory,
      purge   => true,
      recurse => true,
      force   => true,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      before  => Archive[$version_file],
    }

    # download file via archive
    archive { $version_file:
      source  => $_source,
      extract => false,
      cleanup => false,
    }

    file { $path_binary:
      ensure  => link,
      target  => $version_file,
      require => Archive[$version_file],
    }
    ->
    file { $version_file:
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      require => Archive[$version_file],
    }
  # Else ensure it is absent
  } else {
    file { $version_file:
      ensure => absent,
      purge  => true,
      force  => true,
    }
    ->
    file { $install_path:
      ensure  => absent,
      purge   => true,
      recurse => true,
      force   => true,
    }
  }
}
