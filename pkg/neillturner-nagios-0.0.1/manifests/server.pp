#
# from http://www.allgoodbits.org/articles/view/32
#
class nagios::server {
    package { [
        'nagios',
		'nagios-plugins',
        'nagios-plugins-dhcp',
        'nagios-plugins-dns',
        'nagios-plugins-http',
        'nagios-plugins-icmp',
        'nagios-plugins-ldap',
        'nagios-plugins-nrpe',
        'nagios-plugins-ping',
        'nagios-plugins-smtp',
        'nagios-plugins-snmp',
        'nagios-plugins-ssh',
        'nagios-plugins-tcp',
     ]:
        ensure => installed,
    }

  
  service { nagios:
    ensure  => running,
    enable  => true,
	require => [Package['nagios'],Exec['make-nag-cfg-readable']]
  }

  # This is because puppet writes the config files so nagios can't read them
  exec {'make-nag-cfg-readable':
    command => "find /etc/nagios -type f -name '*cfg' | xargs chmod +r",
	require => Package['nagios']
  }

  file { 'resource-d':
    path   => '/etc/nagios/resource.d',
    ensure => directory,
    owner  => 'nagios',
	require => Package['nagios']
  }
  
  file { '/etc/nagios/objects/more_commands.cfg':
     ensure => "file",
	 owner => 'root',
     group => 'root',
     mode => 664,
	 source => 'puppet:///modules/nagios/more_commands.cfg',
	 require => Package['nagios']
 }	
 
 file { '/etc/nagios/objects/services.cfg':
     ensure => "file",
	 owner => 'root',
     group => 'root',
     mode => 664,
	 source => 'puppet:///modules/nagios/services.cfg',
	 require => Package['nagios']
 }	
 
 file { '/etc/nagios/nagios.cfg':
     ensure => "file",
	 owner => 'root',
     group => 'root',
     mode => 664,
	 source => 'puppet:///modules/nagios/nagios.cfg',
	 require => File['resource-d']
 }	
    # restart nagios to pickup new nagios.cfg  
	exec { 'nagios - service nagios restart':
     command     => "service nagios restart",
     cwd         => "/tmp",
     require    =>   File['/etc/nagios/nagios.cfg']
	} 

  # Collect the nagios_host resources
  Nagios_host <<||>> {
    require => File[resource-d],
    notify  => [Exec[make-nag-cfg-readable],Service[nagios]],
  }
  
  Nagios_hostdependency <<| tag == "nagios-${nagios_server}" |>> {
     require => File[resource-d],
     notify  => [Exec[make-nag-cfg-readable],Service[nagios]],
  }
	
  Nagios_service <<| tag == "nagios-${nagios_server}" |>> {
    require => File[resource-d],
    notify  => [Exec[make-nag-cfg-readable],Service[nagios]],
  }
  
  
  # Package['httpd'] is installed in base 
  service { 'httpd':
        ensure=>'running',
		require => Service['nagios']
   }
     
}