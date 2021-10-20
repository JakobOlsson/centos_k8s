#!/usr/bin/env bash
# This script will install ansible locally on the provisioned target (CentOS)
# that way we will not need ansible locally on the host

echo "* Updating packages"
yum update -y --quiet
echo "* Installing ansible"
yum install -y --quiet ansible
