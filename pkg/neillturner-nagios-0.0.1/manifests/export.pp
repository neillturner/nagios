class nagios::export {
  nagios::resource { $::fqdn:
    type => 'host',
    #address => inline_template("<%= has_variable?('my_nagios_interface') ? eval('ipaddress_' + my_nagios_interface) : ipaddress %>"),
    address => $::ipaddress,
    #hostgroups => inline_template("<%= has_variable?('my_nagios_hostgroups') ? $my_nagios_hostgroups : 'all-servers' %>"),
    hostgroups => 'linux-servers',
    check_command => 'check-host-alive!3000.0,80%!5000.0,100%!10',
    export => true,
  }
}
