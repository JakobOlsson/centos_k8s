# Kubernetes on CentOS

This is a vagrant virtual machine with provisioning ansible playbooks to setup the instance to
run latest version of Kuberntes together with the CRI-O container runtime

## Requirements

- Vagrant
  
  You need to install Vagrant to create and run the virtual machine. You get vagrant from url: [Vagrant](https://www.vagrantup.com/downloads)

- Git Bash (only on windows)

  We need to install Git for Windows to be able to install rsync, which is the way we will sync files until the virtual machine during provisioning. [Git Bash for Windows](https://git-scm.com/download/win)

- Rsync

  On linux, rsync should already be installed but if not, Ubuntu: `apt install -y rsync`, RHEL/CentOS/Fedora: `dnf install -y rsync`

  On Windows, you need to download and install following to get rsync working:
  1. [ztds compression tool](https://github.com/facebook/zstd/releases/download/v1.5.0/zstd-v1.5.0-win64.zip) Unzip and put in `%LOCALAPPDATA%\Microsoft\WindowsApps`
  2. [libzstd](https://mirror.msys2.org/msys/x86_64/libzstd-1.5.0-1-x86_64.pkg.tar.zst) Unpack with `tar axvf libzstd-1.5.0-1-x86_64.pkg.tar.zst` and copy file `usr\bin\msys-zstd-1.dll` to `%LOCALAPPDATA%\Microsoft\WindowsApps`
  3. [libxxhash](https://mirror.msys2.org/msys/x86_64/libxxhash-0.8.0-1-x86_64.pkg.tar.zst) Unpack with `tar axvf libxxhash-0.8.0-1-x86_64.pkg.tar.zst` and copy file `usr\bin\msys-xxhash-0.8.0.dll` to `%LOCALAPPDATA%\Microsoft\WindowsApps`
  4. [rsync](https://mirror.msys2.org/msys/x86_64/rsync-3.2.3-1-x86_64.pkg.tar.zst) Unpack with `tar axvf ` and copy file `usr\bin\rsync.exe` to `%LOCALAPPDATA%\Microsoft\WindowsApps`
  5. now try `rsync` in a shell (bash, cmd or powershell) to verify it works

## Privision the machine

Now you can start a shell, go to the same folder as this `README.md` file and the `Vagrantfile` and write: `vagrant up`  
You should se the output from the vagrant process of provisioning the machine and the task described in the ansible playbook.
Once the machine is ready you can write `vagrant ssh main` to get a ssh shell onto the machine.

## Create your kubernetes cluster

In the `privisioning\k8s_setup.sh` are a set of steps to create your first Kubernetes cluster and run a simple first pod. Once you have ssh into the machine you can write `bash /vagrant/provisioning/k8s_setup.sh` to run the script.

## Destroy your Kubernetes cluster

Once ssh onto the machine, you can run `sudo kubeadm reset` to remove the Kubernetes cluster and be able to create the cluster again

## Propogate changes to the machine

If you have done any changes to the files in this directory, like provisioning playbooks and scripts, the are not automatically propegated to the host. To do that you need to run `vagrant reload --provision`

## Remove the virtual machine / start from a new

You can at any time destroy the machine and start from scratch with `vagrant destroy`