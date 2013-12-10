define nagios::resource::file(
  $resource_tag,
  $requires,
  $export = true,
  $ensure = 'present',
) {

  include nagios::params

  if $export {

    @@file { $name:
      ensure  => $ensure,
      tag     => $resource_tag,
      owner   => $nagios::params::user,
      mode    => 0644,
      require => $requires,
    }
  } else {

    file { $name:
      ensure  => $ensure,
      tag     => $resource_tag,
      owner   => $nagios::params::user,
      mode    => 0644,
      require => $requires,
    }
  }
}