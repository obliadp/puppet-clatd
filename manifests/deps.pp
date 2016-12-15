class clatd::deps {

  case $::osfamily {
    'Debian': {
      case $::lsbmajdistrelease {
        /^16/: {
          $_perlmodules = "perl-modules-5.22"
        }
        default: {
          $_perlmodules = "perl-modules"
        }
      }

      $_packages = [
        'perl-base',
        $_perlmodules,
        'libnet-ip-perl',
        'libnet-dns-perl',
        'libio-socket-inet6-perl',
        'perl',
        'iproute',
        'iptables',
        'tayga',
      ]

      ensure_packages($_packages)

      Package[$_packages] ~> Service['clatd']
    }

    'RedHat': {
      case $::lsbmajdistrelease {
        /^(6|7)$/: {
          package { 'clatd':
            notify => Service['clatd'],
          }
        }

        default: {
          fail("${::lsbmajdistrelease} not supported")
        }
      }
    }
    default: {
      fail("${::osfamily} not supported")
    }
  }
}
