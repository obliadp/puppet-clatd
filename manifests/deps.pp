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
    }
    'RedHat': {
      case $::lsbmajdistrelease {
        '7': { # yessss, tayga is packaged for el7
          if !defined(Package['tayga']){
            $_packages = [
              'tayga',
              'iptables',
              'iproute',
            ]
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
  ensure_packages($_packages)
}
