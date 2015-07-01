# CHEF_DRIVER=docker chef-client -z docker.rb

require 'chef/provisioning'

serf_config = {
  'serf' => {
    'version' => '0.6.4', # 2015/02/13 latest
    'agent' => {
      'discover' => 'docker'
    }
  }
}

#
# base
#
machine_image 'serf' do
  recipe 'serf::default'
  attributes serf_config

  machine_options :docker_options => {
    :base_image => {
      :name       => 'ubuntu',
      :repository => 'ubuntu',
      :tag        => '14.04'
    }
  }
end

#
# serf
#
( '101' .. '105' ).each do |i|
  machine "serf#{i}" do
    from_image 'serf'

    machine_options :docker_options => {
      :command => '/usr/bin/serf agent ' +
                  '-config-file /opt/serf/config/serf_agent.json'
    }
  end
end

#
# [EOF]
#
