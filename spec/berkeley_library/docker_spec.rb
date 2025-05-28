require 'spec_helper'
require 'rails' # require Rails first to mimic load order
require 'berkeley_library/docker'

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

      KUBEISH_CGROUP = <<~EOL
        11:perf_event:/kubepods.slice/kubepods-besteffort.slice/kubepods-besteffort-pod9a_bc_de_f0_12.slice/cri-containerd-12345.scope
        10:hugetlb:/kubepods.slice/kubepods-besteffort.slice/kubepods-besteffort-pod9a_bc_de_f0_12.slice/cri-containerd-12345.scope
        9:devices:/kubepods.slice/kubepods-besteffort.slice/kubepods-besteffort-pod9a_bc_de_f0_12.slice/cri-containerd-12345.scope
        8:net_cls,net_prio:/kubepods.slice/kubepods-besteffort.slice/kubepods-besteffort-pod9a_bc_de_f0_12.slice/cri-containerd-12345.scope
        7:blkio:/kubepods.slice/kubepods-besteffort.slice/kubepods-besteffort-pod9a_bc_de_f0_12.slice/cri-containerd-12345.scope
        6:cpu,cpuacct:/kubepods.slice/kubepods-besteffort.slice/kubepods-besteffort-pod9a_bc_de_f0_12.slice/cri-containerd-12345.scope
        5:pids:/kubepods.slice/kubepods-besteffort.slice/kubepods-besteffort-pod9a_bc_de_f0_12.slice/cri-containerd-12345.scope
        4:cpuset:/kubepods.slice/kubepods-besteffort.slice/kubepods-besteffort-pod9a_bc_de_f0_12.slice/cri-containerd-12345.scope
        3:freezer:/kubepods.slice/kubepods-besteffort.slice/kubepods-besteffort-pod9a_bc_de_f0_12.slice/cri-containerd-12345.scope
        2:memory:/kubepods.slice/kubepods-besteffort.slice/kubepods-besteffort-pod9a_bc_de_f0_12.slice/cri-containerd-12345.scope
        1:name=systemd:/kubepods.slice/kubepods-besteffort.slice/kubepods-besteffort-pod9a_bc_de_f0_12.slice/cri-containerd-12345.scope
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

      CGROUPS = {
        trad: TRADITIONAL_CGROUP,
        kube: KUBEISH_CGROUP,
        docker: DOCKERISH_CGROUP
      }

      it 'is true when /.dockerenv exists' do
        mock_dockerenv
        expect(BerkeleyLibrary::Docker.running_in_container?).to be true
      end

      it 'is true when /proc/1/cgroup is docker-like' do
        mock_dockerenv(false)
        mock_init_cgroup(:docker)
        expect(BerkeleyLibrary::Docker.running_in_container?).to be true
      end

      it 'is true when /proc/1/cgroup is kube-like' do
        mock_dockerenv(false)
        mock_init_cgroup(:kube)
        expect(BerkeleyLibrary::Docker.running_in_container?).to be true
      end

      it 'is false when /proc/1/cgroup is traditional' do
        mock_dockerenv(false)
        mock_init_cgroup(:trad)
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

      def mock_init_cgroup(type)
        cgroup_data = CGROUPS.fetch(type)
        expect(File)
          .to receive(:open).with('/proc/1/cgroup')
          .and_return(StringIO.new(cgroup_data))
      end
    end
  end
end
