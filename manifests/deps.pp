class clatd::deps {

  case $::osfamily {
    'Debian': {
      $_packages = [
        'perl-base',
        'perl-modules',
        'libnet-ip-perl',
        'libnet-dns-perl',
        'libio-socket-inet6-perl',
        'perl',
        'iproute',
        'iptables',
        'tayga',
      ]

      ensure_packages($_packages)
    }

    'RedHat': {
      case $::lsbmajdistrelease {
        '7': {

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
