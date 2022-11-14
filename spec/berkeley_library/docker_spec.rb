require 'rails' # require Rails first to mimic load order
require 'berkeley_library/docker'
require 'spec_helper'

module BerkeleyLibrary
  describe Docker do
    describe '#running_in_container?' do
      DOCKERISH_CGROUP = <<~EOL
        11:cpuacct,cpu:/docker/12345
        10:devices:/docker/12345
        9:hugetlb:/docker/12345
        8:freezer:/docker/12345
        7:blkio:/docker/12345
        6:net_prio,net_cls:/docker/12345
        5:memory:/docker/12345
        4:pids:/docker/12345
        3:perf_event:/docker/12345
        2:cpuset:/docker/12345
        1:name=systemd:/docker/12345
      EOL

      TRADITIONAL_CGROUP = <<~EOL
        11:cpuacct,cpu:/
        10:devices:/
        9:hugetlb:/
        8:freezer:/
        7:blkio:/
        6:net_prio,net_cls:/
        5:memory:/
        4:pids:/
        3:perf_event:/
        2:cpuset:/
        1:name=systemd:/
      EOL

      it 'is true when /.dockerenv exists' do
        mock_dockerenv
        expect(BerkeleyLibrary::Docker.running_in_container?).to be true
      end

      it 'is true when /proc/1/cgroup is docker-like' do
        mock_dockerenv(false)
        mock_init_cgroup
        expect(BerkeleyLibrary::Docker.running_in_container?).to be true
      end

      it 'is false when /proc/1/cgroup is traditional' do
        mock_dockerenv(false)
        mock_init_cgroup(false)
        expect(BerkeleyLibrary::Docker.running_in_container?).to be false
      end

      it 'is false when /proc/1/cgroup does not exist' do
        mock_dockerenv(false)
        expect(File)
          .to receive(:open).with('/proc/1/cgroup')
          .and_raise(Errno::ENOENT)
        expect(BerkeleyLibrary::Docker.running_in_container?).to be false
      end

      private

      def mock_dockerenv(exists = true)
        expect(File)
          .to receive(:exist?).with('/.dockerenv')
          .and_return(exists)
      end

      def mock_init_cgroup(dockerish = true)
        expect(File)
          .to receive(:open).with('/proc/1/cgroup')
          .and_return(
            StringIO.new(dockerish ? DOCKERISH_CGROUP : TRADITIONAL_CGROUP))
      end
    end
  end
end
