require 'spec_helper'

describe 'clatd', :type => :class do

  ['debian8', 'ubuntu14', 'ubuntu16', 'el6', 'el7'].each do |os|
    context "on #{os}" do

      if os == 'debian8'
        let(:facts) { {
          :osfamily                  => 'Debian',
          :operatingsystem           => 'Debian',
          :lsbdistid                 => 'Debian',
          :lsbdistcodename           => 'wheezy',
          :operatingsystemrelease    => '8.0',
          :operatingsystemmajrelease => '8',
          :lsbmajdistrelease         => '8',
          :service_provider          => 'systemd',
        } }
      end

      if os == 'ubuntu14'
        let(:facts) { {
          :osfamily                  => 'Debian',
          :operatingsystem           => 'Ubuntu',
          :lsbdistid                 => 'Ubuntu',
          :lsbdistcodename           => 'trusty',
          :operatingsystemrelease    => '14.04',
          :operatingsystemmajrelease => '14',
          :lsbmajdistrelease         => '14',
          :service_provider          => 'upstart',
        } }
      end

      if os == 'ubuntu16'
        let(:facts) { {
          :osfamily                  => 'Debian',
          :operatingsystem           => 'Ubuntu',
          :lsbdistid                 => 'Ubuntu',
          :lsbdistcodename           => 'xenial',
          :operatingsystemrelease    => '16.04',
          :operatingsystemmajrelease => '16',
          :lsbmajdistrelease         => '16',
          :service_provider          => 'systemd',
        } }
      end

      if os == 'el6'
        let(:facts) { {
          :osfamily                  => 'RedHat',
          :operatingsystem           => 'RedHat',
          :operatingsystemrelease    => '6.5',
          :operatingsystemmajrelease => '6',
          :lsbmajdistrelease         => '6',
          :service_provider          => 'upstart',
        } }
      end

      if os == 'el7'
        let(:facts) { {
          :osfamily                  => 'RedHat',
          :operatingsystem           => 'RedHat',
          :operatingsystemrelease    => '7.2',
          :operatingsystemmajrelease => '7',
          :lsbmajdistrelease         => '7',
          :service_provider          => 'systemd',
        } }
      end

      if os == 'ubuntu14'
        it { should contain_package('perl-base') }
        it { should contain_package('perl-modules') }
        it { should contain_package('libnet-ip-perl') }
        it { should contain_package('libnet-dns-perl') }
        it { should contain_package('libio-socket-inet6-perl') }
        it { should contain_package('perl') }
        it { should contain_package('iproute') }
        it { should contain_package('iptables') }
        it { should contain_package('tayga') }

        it { should contain_service('clatd')
                     .with_enable(true)
                     .with_ensure('running')
                     .with_provider('upstart')
        }

        it { should contain_file('/etc/init/clatd.conf')
                      .that_notifies('Service[clatd]')
        }

        it { should contain_file('/usr/sbin/clatd')
                    .that_notifies('Service[clatd]')
        }
      end

      if os == 'ubuntu16'
        it { should contain_package('perl-base') }
        it { should contain_package('perl-modules') }
        it { should contain_package('libnet-ip-perl') }
        it { should contain_package('libnet-dns-perl') }
        it { should contain_package('libio-socket-inet6-perl') }
        it { should contain_package('perl') }
        it { should contain_package('iproute') }
        it { should contain_package('iptables') }
        it { should contain_package('tayga') }

        it { should contain_service('clatd')
                     .with_enable(true)
                     .with_ensure('running')
                     .with_provider('systemd')
        }

        it { should contain_file('/etc/systemd/system/clatd.service')
                      .that_notifies(['Exec[clatd reload systemd]','Service[clatd]'])
        }

        it { should contain_file('/usr/sbin/clatd')
                    .that_notifies('Service[clatd]')
        }
      end

      if os == 'debian8'
        it { should contain_package('perl-base') }
        it { should contain_package('perl-modules') }
        it { should contain_package('libnet-ip-perl') }
        it { should contain_package('libnet-dns-perl') }
        it { should contain_package('libio-socket-inet6-perl') }
        it { should contain_package('perl') }
        it { should contain_package('iproute') }
        it { should contain_package('iptables') }
        it { should contain_package('tayga') }

        it { should contain_service('clatd')
                     .with_enable(true)
                     .with_ensure('running')
                     .with_provider('systemd')
        }

        it { should contain_file('/etc/systemd/system/clatd.service')
                      .that_notifies(['Exec[clatd reload systemd]','Service[clatd]'])
        }

       it { should contain_file('/usr/sbin/clatd')
                      .that_notifies('Service[clatd]')
        }

      end

      if os == 'el6'
        it { should contain_package('clatd') }

        it { should contain_service('clatd')
                     .with_enable(true)
                     .with_ensure('running')
                     .with_provider('upstart')
        }
      end

      if os == 'el7'
        it { should contain_package('clatd') }

        it { should contain_service('clatd')
                     .with_enable(true)
                     .with_ensure('running')
                     .with_provider('systemd')
        }
      end

      # common for all

      it { should compile.with_all_deps }

      it { should contain_file('/etc/clatd.conf')
                    .that_notifies('Service[clatd]')
      }

      it { should contain_exec('clatd reload systemd') }

      it { should contain_class('clatd') }

      it { should contain_class('clatd::deps') }

    end
  end
end
