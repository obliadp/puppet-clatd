# denne inkluderes manuelt der clatd er ønskelig
# https://github.com/toreanderson/clatd

class clatd( $options = {} ) {

  class { 'clatd::deps': }

  File { notify => Service['clatd'] }

  unless $::operatingsystem =~ /(?i:RedHatEnterprise|CentOS|Fedora|Scientific)/ {
    # debian/ubuntu has no clatd package atm.
    file { '/usr/sbin/clatd':
      source => 'puppet:///modules/clatd/bin/clatd',
      mode   => '0755',
    }
  }

  case $::clatd_service_provider {
    /(upstart|redhat)/: {
      $_initsystem = 'upstart'
    }
    'systemd': {
      $_initsystem = 'systemd'
    }
    'debian': {
      case $::lsbmajdistrelease {
        /^14/: {
          $_initsystem = 'upstart'
        }
        /^16/: {
          $_initsystem = 'systemd'
        }
        default: {
          fail("not supported on lsbmajdistrelease ${::lsbmajdistrelease} for service provider ${::clatd_service_provider}")
        }
      }
    }
    default: {
      fail("not supported on ${::clatd_service_provider} service provider")
    }
  }

  case $_initsystem {
    'upstart': {
      file { '/etc/init/clatd.conf':
        source => 'puppet:///modules/clatd/init/clatd.upstart',
      }
    }
    'systemd': {
      file { '/etc/systemd/system/clatd.service':
        source => 'puppet:///modules/clatd/init/clatd.systemd',
        notify => [
          Exec['clatd reload systemd'],
          Service['clatd'],
          ],
      }
    }
    default: {
      fail("not supported on ${::_initsystem} init system")
    }
  }

  file { '/etc/clatd.conf':
    content => template('clatd/conf/clatd.conf.erb'),
  }

  service { 'clatd':
    ensure   => running,
    enable   => true,
    provider => $_initsystem,
  }

  exec { 'clatd reload systemd':
    path        => '/usr/local/bin:/usr/bin:/bin',
    command     => 'systemctl daemon-reload',
    refreshonly => true,
  }

  # validate input.
  # the options hash is passed verbatim from hiera to clatd.conf
  # this is a best effort attempt at sanity checking the input

  if $options['quiet'] {
    validate_integer($options['quiet']) # suppress normal output
  }

  if $options['debug'] {
    validate_integer($options['debug']) # debugging output level
  }

  if $options['forwarding-enable'] {
    validate_integer($options['forwarding-enable']) # enable ipv6 forwarding?
  }

  if $options['proxynd-enable'] {
    validate_integer($options['proxynd-enable']) # add proxy-nd entry for clat?
  }

  if $options['v4-conncheck-enable'] {
    validate_integer($options['v4-conncheck-enable']) # check v4 connectivity in startup
  }

  if $options['v4-defaultroute-enable'] {
    validate_integer($options['v4-defaultroute-enable']) # add a v4 defaultroute via the CLAT?
  }

  if $options['v4-defaultroute-replace'] {
    validate_integer($options['v4-defaultroute-replace']) # replace v4 defaultroute?
  }

  if $options['v4-conncheck-delay'] {
    validate_integer($options['v4-conncheck-delay']) # seconds before checking for v4 conn.
  }

  if $options['v4-defaultroute-metric'] {
    validate_integer($options['v4-defaultroute-metric']) # metric for the default route
  }

  if $options['v4-defaultroute-mtu'] {
    validate_integer($options['v4-defaultroute-metric']) # MTU for the IPv4 defaultroute
  }

  if $options['v4-defaultroute-advmss'] {
    # The "advmss" value assigned to the the default route potining to the CLAT. This controls
    # the advertised TCP MSS value for TCP connections made through the CLAT.
    validate_integer($options['v4-defaultroute-advmss'])
  }

  if $options['script-up'] and !(is_absolute_path($options['script-up'])) {
    fail('script-up not an absolute path') # sh script to run when starting up
  }

  if $options['script-down'] and !(is_absolute_path($options['script-down'])) {
    fail('script-down not an absolute path') # sh script to run when shutting down
  }

  if $options['clat_ipv6_bindaddress'] {
    validate_ip_address($options['clat_ipv6_bindaddress']) # from RFC 7335, default derive from SLAAC address
  }

  if $options['clat_ipv4_bindaddress'] {
    validate_ip_address($options['clat_ipv4_bindaddress'])  # from RFC 7335, default 192.0.0.1
  }

  if $options['tayga-v4-addr'] {
    validate_ip_address($options['tayga-v4-addr'])  # from RFC 7335, default 192.0.0.2
  }

  if $options['plat-prefix'] {
    validate_ip_address($options['plat-prefix'])  # detect using DNS64 by default
  }

  if $options['dns64-servers'] {
    validate_string($options['dns64-servers'])  # to override whats in resolv.conf
  }

  if $options['plat-dev'] {

    $_interfaces = split($::interfaces, ',')

    if !(member($_interfaces, $options['plat-dev'])) {
      fail("${options['plat-dev']} is not a member of \${::interfaces}") # PLAT-facing device, default detect
    }
  }
}
