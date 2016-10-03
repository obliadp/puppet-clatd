require 'spec_helper'

describe 'clatd', :type => :class do

  ['Debian', 'Ubuntu', 'RedHat'].each do |os|
    context "on #{os}" do

      if os == 'Debian'
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

      if os == 'Ubuntu'
        let(:facts) { {
          :osfamily                  => 'Debian',
          :operatingsystem           => 'Ubuntu',
          :lsbdistid                 => 'Ubuntu',
          :lsbdistcodename           => 'maverick',
          :operatingsystemrelease    => '14.04',
          :operatingsystemmajrelease => '14',
          :lsbmajdistrelease         => '14',
          :service_provider          => 'upstart',
        } }
      end

      if os == 'RedHat'
        let(:facts) { {
          :osfamily                  => 'RedHat',
          :operatingsystem           => 'RedHat',
          :operatingsystemrelease    => '7.2',
          :operatingsystemmajrelease => '7',
          :lsbmajdistrelease         => '7',
          :service_provider          => 'systemd',
        } }
      end

      if os == 'Ubuntu'
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

      end

      if os == 'Debian'
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

      end

      if os == 'RedHat'
        it { should contain_package('tayga') }
        it { should contain_package('iptables') }
        it { should contain_package('iproute') }

        it { should contain_service('clatd')
                     .with_enable(true)
                     .with_ensure('running')
                     .with_provider('systemd')
        }

        it { should contain_file('/etc/systemd/system/clatd.service')
                      .that_notifies(['Exec[clatd reload systemd]','Service[clatd]'])
        }
      end

      # common for all

      it { should compile.with_all_deps }

      it { should contain_file('/etc/clatd.conf')
                    .that_notifies('Service[clatd]')
      }

      it { should contain_file('/usr/sbin/clatd')
                    .that_notifies('Service[clatd]')
      }

      it { should contain_exec('clatd reload systemd') }

      it { should contain_class('clatd') }

      it { should contain_class('clatd::deps') }

    end
  end
end
